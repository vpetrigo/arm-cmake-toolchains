"""Install official Arm binaries on the GitHub-hosted runners used by build.yml."""

import hashlib
import os
from pathlib import Path
import subprocess
import tarfile
import tempfile
import zipfile


BASE_URL = (
    "https://gitlab.arm.com/api/v4/projects/"
    "tooling%2Fgnu-toolchains-for-arm/packages/generic/gnu-toolchain"
)
# SHA-256 values from Arm's package_files API, not the third-party setup action.
# https://gitlab.arm.com/tooling/gnu-toolchains-for-arm/-/packages
CHECKSUMS = {
    "15.3.rel2": {
        "Linux-X64": "463df9665c246fa13bab2102115bbf83440661b6eb70b44f3dfd4712ca30037a",
        "Windows-X64": "93bfdac2fc5f8ed86db08689ca23fc18603efda299afd61b50f346494da6bc19",
        "macOS-ARM64": "f011e4832046155f06408dda6b252b21b139a8159c8529802227371f06656c60",
    },
    "14.3.rel1": {
        "Linux-X64": "8f6903f8ceb084d9227b9ef991490413014d991874a1e34074443c2a72b14dbd",
        "Windows-X64": "836ebe51fd71b6542dd7884c8fb2011192464b16c28e4b38fddc9350daba5ee8",
        "macOS-ARM64": "30f4d08b219190a37cded6aa796f4549504902c53cfc3c7e044a8490b6eba1f7",
    },
    "13.3.rel1": {
        "Linux-X64": "95c011cee430e64dd6087c75c800f04b9c49832cc1000127a92a97f9c8d83af4",
        "Windows-X64": "e46fda043c0ce83582bc8db4b3ef85f77f4beb7333344c2f4193c17e1167a095",
        "macOS-ARM64": "fb6921db95d345dc7e5e487dd43b745e3a5b4d5c0c7ca4f707347148760317b4",
    },
}
HOSTS = {
    "Linux-X64": ("x86_64", "tar.xz"),
    "Windows-X64": ("mingw-w64-i686", "zip"),
    "macOS-ARM64": ("darwin-arm64", "tar.xz"),
}


def main():
    release = os.environ["ARM_GCC_RELEASE"]
    host = f"{os.environ['RUNNER_OS']}-{os.environ['RUNNER_ARCH']}"
    if release not in CHECKSUMS or host not in CHECKSUMS[release]:
        raise SystemExit(f"Unsupported Arm GNU Toolchain release/host: {release}/{host}")
    architecture, extension = HOSTS[host]
    name = f"arm-gnu-toolchain-{release}-{architecture}-arm-none-eabi"
    filename = f"{name}.{extension}"
    url = f"{BASE_URL}/{release}/{filename}"
    # Keep the verified installation for subsequent workflow steps.
    destination = Path(tempfile.mkdtemp(prefix="arm-gcc-", dir=os.environ["RUNNER_TEMP"]))
    archive = destination / filename
    print(f"Downloading {url}", flush=True)
    subprocess.run(
        ["curl", "--fail", "--location", "--retry", "3", "--output", str(archive), url],
        check=True,
    )
    with archive.open("rb") as stream:
        checksum = hashlib.file_digest(stream, "sha256").hexdigest()
    if checksum != CHECKSUMS[release][host]:
        raise SystemExit(f"SHA-256 mismatch for {filename}: {checksum}")
    print(f"Verified SHA-256: {checksum}", flush=True)
    if extension == "zip":
        with zipfile.ZipFile(archive) as bundle:
            bundle.extractall(destination)
    else:
        with tarfile.open(archive) as bundle:
            bundle.extractall(destination, filter="data")
    archive.unlink()
    # Windows ZIPs can contain bin/ directly; Unix archives have a named root.
    compiler_name = "arm-none-eabi-gcc.exe" if host.startswith("Windows") else "arm-none-eabi-gcc"
    bin_dir = destination / name / "bin"
    if (destination / "bin" / compiler_name).is_file():
        bin_dir = destination / "bin"
    subprocess.run([str(bin_dir / compiler_name), "--version"], check=True)
    with open(os.environ["GITHUB_PATH"], "a", encoding="utf-8") as stream:
        stream.write(f"{bin_dir}\n")


if __name__ == "__main__":
    main()
