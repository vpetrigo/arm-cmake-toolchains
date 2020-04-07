/**
 * \file
 * \brief
 * \author
 */

#include "fsl_gpio.h"
#include "fsl_port.h"
#include "system.h"

static unsigned count_ms = 0;

__attribute__((interrupt("IRQ"))) void SysTick_Handler(void) { ++count_ms; }

void delay(unsigned timeout_ms) {
  unsigned until = count_ms + timeout_ms;

  while (count_ms != until) {
    __WFI();
  }
}

__attribute__((noreturn)) int main(void) {
  gpio_pin_config_t config = {.pinDirection = kGPIO_DigitalOutput,
                              .outputLogic = 0};
  SystemCoreClockUpdate();
  SysTick_Config(SystemCoreClockGet() / 1000);
  EnableIRQ(SysTick_IRQn);
  CLOCK_EnableClock(kCLOCK_PortB);
  // PB21 - Blue LED
  PORT_SetPinMux(PORTB, 21, kPORT_MuxAsGpio);
  GPIO_PinInit(GPIOB, 21, &config);
  GPIO_PinWrite(GPIOB, 21, 0);

  while (1) {
    delay(63);
    GPIO_PortToggle(GPIOB, (1U << 21U));
  }
}
