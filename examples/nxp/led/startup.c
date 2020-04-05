/**
 * \file
 * \brief
 * \author
 */

#include "system_MK64F12.h"

#include <stdint.h>

extern uint32_t __stack_top__;
typedef void (*irq_handler)(void);

void Default_Handler(void);
__attribute__((noreturn)) void Reset_Handler(void);

/* Cortex-M Processor Exceptions */
void NMI_Handler(void) __attribute__((weak, alias("Default_Handler")));
void HardFault_Handler(void) __attribute__((weak, alias("Default_Handler")));
void MemManage_Handler(void) __attribute__((weak, alias("Default_Handler")));
void BusFault_Handler(void) __attribute__((weak, alias("Default_Handler")));
void UsageFault_Handler(void) __attribute__((weak, alias("Default_Handler")));
void DebugMon_Handler(void) __attribute__((weak, alias("Default_Handler")));
void SVC_Handler(void) __attribute__((weak, alias("Default_Handler")));
void PendSV_Handler(void) __attribute__((weak, alias("Default_Handler")));
void SysTick_Handler(void) __attribute__((weak, alias("Default_Handler")));

void DefaultISR(void) __attribute__((weak, alias("Default_Handler")));

#define WEAK_DEF_DECLARE(func_name)                                            \
  void func_name(void) __attribute__((weak, alias("Default_Handler")))

WEAK_DEF_DECLARE(DMA0_IRQHandler);
WEAK_DEF_DECLARE(DMA1_IRQHandler);
WEAK_DEF_DECLARE(DMA2_IRQHandler);
WEAK_DEF_DECLARE(DMA3_IRQHandler);
WEAK_DEF_DECLARE(DMA4_IRQHandler);
WEAK_DEF_DECLARE(DMA5_IRQHandler);
WEAK_DEF_DECLARE(DMA6_IRQHandler);
WEAK_DEF_DECLARE(DMA7_IRQHandler);
WEAK_DEF_DECLARE(DMA8_IRQHandler);
WEAK_DEF_DECLARE(DMA9_IRQHandler);
WEAK_DEF_DECLARE(DMA10_IRQHandler);
WEAK_DEF_DECLARE(DMA11_IRQHandler);
WEAK_DEF_DECLARE(DMA12_IRQHandler);
WEAK_DEF_DECLARE(DMA13_IRQHandler);
WEAK_DEF_DECLARE(DMA14_IRQHandler);
WEAK_DEF_DECLARE(DMA15_IRQHandler);
WEAK_DEF_DECLARE(DMA_Error_IRQHandler);
WEAK_DEF_DECLARE(MCM_IRQHandler);
WEAK_DEF_DECLARE(FTFE_IRQHandler);
WEAK_DEF_DECLARE(Read_Collision_IRQHandler);
WEAK_DEF_DECLARE(LVD_LVW_IRQHandler);
WEAK_DEF_DECLARE(LLWU_IRQHandler);
WEAK_DEF_DECLARE(WDOG_EWM_IRQHandler);
WEAK_DEF_DECLARE(RNG_IRQHandler);
WEAK_DEF_DECLARE(I2C0_IRQHandler);
WEAK_DEF_DECLARE(I2C1_IRQHandler);
WEAK_DEF_DECLARE(SPI0_IRQHandler);
WEAK_DEF_DECLARE(SPI1_IRQHandler);
WEAK_DEF_DECLARE(I2S0_Tx_IRQHandler);
WEAK_DEF_DECLARE(I2S0_Rx_IRQHandler);
WEAK_DEF_DECLARE(UART0_LON_IRQHandler);
WEAK_DEF_DECLARE(UART0_RX_TX_IRQHandler);
WEAK_DEF_DECLARE(UART0_ERR_IRQHandler);
WEAK_DEF_DECLARE(UART1_RX_TX_IRQHandler);
WEAK_DEF_DECLARE(UART1_ERR_IRQHandler);
WEAK_DEF_DECLARE(UART2_RX_TX_IRQHandler);
WEAK_DEF_DECLARE(UART2_ERR_IRQHandler);
WEAK_DEF_DECLARE(UART3_RX_TX_IRQHandler);
WEAK_DEF_DECLARE(UART3_ERR_IRQHandler);
WEAK_DEF_DECLARE(ADC0_IRQHandler);
WEAK_DEF_DECLARE(CMP0_IRQHandler);
WEAK_DEF_DECLARE(CMP1_IRQHandler);
WEAK_DEF_DECLARE(FTM0_IRQHandler);
WEAK_DEF_DECLARE(FTM1_IRQHandler);
WEAK_DEF_DECLARE(FTM2_IRQHandler);
WEAK_DEF_DECLARE(CMT_IRQHandler);
WEAK_DEF_DECLARE(RTC_IRQHandler);
WEAK_DEF_DECLARE(RTC_Seconds_IRQHandler);
WEAK_DEF_DECLARE(PIT0_IRQHandler);
WEAK_DEF_DECLARE(PIT1_IRQHandler);
WEAK_DEF_DECLARE(PIT2_IRQHandler);
WEAK_DEF_DECLARE(PIT3_IRQHandler);
WEAK_DEF_DECLARE(PDB0_IRQHandler);
WEAK_DEF_DECLARE(USB0_IRQHandler);
WEAK_DEF_DECLARE(USBDCD_IRQHandler);
WEAK_DEF_DECLARE(Reserved71_IRQHandler);
WEAK_DEF_DECLARE(DAC0_IRQHandler);
WEAK_DEF_DECLARE(MCG_IRQHandler);
WEAK_DEF_DECLARE(LPTMR0_IRQHandler);
WEAK_DEF_DECLARE(PORTA_IRQHandler);
WEAK_DEF_DECLARE(PORTB_IRQHandler);
WEAK_DEF_DECLARE(PORTC_IRQHandler);
WEAK_DEF_DECLARE(PORTD_IRQHandler);
WEAK_DEF_DECLARE(PORTE_IRQHandler);
WEAK_DEF_DECLARE(SWI_IRQHandler);
WEAK_DEF_DECLARE(SPI2_IRQHandler);
WEAK_DEF_DECLARE(UART4_RX_TX_IRQHandler);
WEAK_DEF_DECLARE(UART4_ERR_IRQHandler);
WEAK_DEF_DECLARE(UART5_RX_TX_IRQHandler);
WEAK_DEF_DECLARE(UART5_ERR_IRQHandler);
WEAK_DEF_DECLARE(CMP2_IRQHandler);
WEAK_DEF_DECLARE(FTM3_IRQHandler);
WEAK_DEF_DECLARE(DAC1_IRQHandler);
WEAK_DEF_DECLARE(ADC1_IRQHandler);
WEAK_DEF_DECLARE(I2C2_IRQHandler);
WEAK_DEF_DECLARE(CAN0_ORed_Message_buffer_IRQHandler);
WEAK_DEF_DECLARE(CAN0_Bus_Off_IRQHandler);
WEAK_DEF_DECLARE(CAN0_Error_IRQHandler);
WEAK_DEF_DECLARE(CAN0_Tx_Warning_IRQHandler);
WEAK_DEF_DECLARE(CAN0_Rx_Warning_IRQHandler);
WEAK_DEF_DECLARE(CAN0_Wake_Up_IRQHandler);
WEAK_DEF_DECLARE(SDHC_IRQHandler);
WEAK_DEF_DECLARE(ENET_1588_Timer_IRQHandler);
WEAK_DEF_DECLARE(ENET_Transmit_IRQHandler);
WEAK_DEF_DECLARE(ENET_Receive_IRQHandler);
WEAK_DEF_DECLARE(ENET_Error_IRQHandler);

static const irq_handler vectors[] __attribute__((section(".isr_vectors"),
                                                  used)) = {
    (irq_handler)&__stack_top__, /* Stack Bottom Value */
    Reset_Handler,               /* Reset Handler */
    NMI_Handler,                 /* NMI Handler*/
    HardFault_Handler,           /* Hard Fault Handler*/
    MemManage_Handler,           /* MPU Fault Handler*/
    BusFault_Handler,            /* Bus Fault Handler*/
    UsageFault_Handler,          /* Usage Fault Handler*/
    0,                           /* Reserved*/
    0,                           /* Reserved*/
    0,                           /* Reserved*/
    0,                           /* Reserved*/
    SVC_Handler,                 /* SVCall Handler*/
    DebugMon_Handler,            /* Debug Monitor Handler*/
    0,                           /* Reserved*/
    PendSV_Handler,              /* PendSV Handler*/
    SysTick_Handler,             /* SysTick Handler*/

    /* External Interrupts*/
    DMA0_IRQHandler,           /* DMA Channel 0 Transfer Complete*/
    DMA1_IRQHandler,           /* DMA Channel 1 Transfer Complete*/
    DMA2_IRQHandler,           /* DMA Channel 2 Transfer Complete*/
    DMA3_IRQHandler,           /* DMA Channel 3 Transfer Complete*/
    DMA4_IRQHandler,           /* DMA Channel 4 Transfer Complete*/
    DMA5_IRQHandler,           /* DMA Channel 5 Transfer Complete*/
    DMA6_IRQHandler,           /* DMA Channel 6 Transfer Complete*/
    DMA7_IRQHandler,           /* DMA Channel 7 Transfer Complete*/
    DMA8_IRQHandler,           /* DMA Channel 8 Transfer Complete*/
    DMA9_IRQHandler,           /* DMA Channel 9 Transfer Complete*/
    DMA10_IRQHandler,          /* DMA Channel 10 Transfer Complete*/
    DMA11_IRQHandler,          /* DMA Channel 11 Transfer Complete*/
    DMA12_IRQHandler,          /* DMA Channel 12 Transfer Complete*/
    DMA13_IRQHandler,          /* DMA Channel 13 Transfer Complete*/
    DMA14_IRQHandler,          /* DMA Channel 14 Transfer Complete*/
    DMA15_IRQHandler,          /* DMA Channel 15 Transfer Complete*/
    DMA_Error_IRQHandler,      /* DMA Error Interrupt*/
    MCM_IRQHandler,            /* Normal Interrupt*/
    FTFE_IRQHandler,           /* FTFE Command complete interrupt*/
    Read_Collision_IRQHandler, /* Read Collision Interrupt*/
    LVD_LVW_IRQHandler,        /* Low Voltage Detect, Low Voltage Warning*/
    LLWU_IRQHandler,           /* Low Leakage Wakeup Unit*/
    WDOG_EWM_IRQHandler,       /* WDOG Interrupt*/
    RNG_IRQHandler,            /* RNG Interrupt*/
    I2C0_IRQHandler,           /* I2C0 interrupt*/
    I2C1_IRQHandler,           /* I2C1 interrupt*/
    SPI0_IRQHandler,           /* SPI0 Interrupt*/
    SPI1_IRQHandler,           /* SPI1 Interrupt*/
    I2S0_Tx_IRQHandler,        /* I2S0 transmit interrupt*/
    I2S0_Rx_IRQHandler,        /* I2S0 receive interrupt*/
    UART0_LON_IRQHandler,      /* UART0 LON interrupt*/
    UART0_RX_TX_IRQHandler,    /* UART0 Receive/Transmit interrupt*/
    UART0_ERR_IRQHandler,      /* UART0 Error interrupt*/
    UART1_RX_TX_IRQHandler,    /* UART1 Receive/Transmit interrupt*/
    UART1_ERR_IRQHandler,      /* UART1 Error interrupt*/
    UART2_RX_TX_IRQHandler,    /* UART2 Receive/Transmit interrupt*/
    UART2_ERR_IRQHandler,      /* UART2 Error interrupt*/
    UART3_RX_TX_IRQHandler,    /* UART3 Receive/Transmit interrupt*/
    UART3_ERR_IRQHandler,      /* UART3 Error interrupt*/
    ADC0_IRQHandler,           /* ADC0 interrupt*/
    CMP0_IRQHandler,           /* CMP0 interrupt*/
    CMP1_IRQHandler,           /* CMP1 interrupt*/
    FTM0_IRQHandler,           /* FTM0 fault, overflow and channels interrupt*/
    FTM1_IRQHandler,           /* FTM1 fault, overflow and channels interrupt*/
    FTM2_IRQHandler,           /* FTM2 fault, overflow and channels interrupt*/
    CMT_IRQHandler,            /* CMT interrupt*/
    RTC_IRQHandler,            /* RTC interrupt*/
    RTC_Seconds_IRQHandler,    /* RTC seconds interrupt*/
    PIT0_IRQHandler,           /* PIT timer channel 0 interrupt*/
    PIT1_IRQHandler,           /* PIT timer channel 1 interrupt*/
    PIT2_IRQHandler,           /* PIT timer channel 2 interrupt*/
    PIT3_IRQHandler,           /* PIT timer channel 3 interrupt*/
    PDB0_IRQHandler,           /* PDB0 Interrupt*/
    USB0_IRQHandler,           /* USB0 interrupt*/
    USBDCD_IRQHandler,         /* USBDCD Interrupt*/
    Reserved71_IRQHandler,     /* Reserved interrupt 71*/
    DAC0_IRQHandler,           /* DAC0 interrupt*/
    MCG_IRQHandler,            /* MCG Interrupt*/
    LPTMR0_IRQHandler,         /* LPTimer interrupt*/
    PORTA_IRQHandler,          /* Port A interrupt*/
    PORTB_IRQHandler,          /* Port B interrupt*/
    PORTC_IRQHandler,          /* Port C interrupt*/
    PORTD_IRQHandler,          /* Port D interrupt*/
    PORTE_IRQHandler,          /* Port E interrupt*/
    SWI_IRQHandler,            /* Software interrupt*/
    SPI2_IRQHandler,           /* SPI2 Interrupt*/
    UART4_RX_TX_IRQHandler,    /* UART4 Receive/Transmit interrupt*/
    UART4_ERR_IRQHandler,      /* UART4 Error interrupt*/
    UART5_RX_TX_IRQHandler,    /* UART5 Receive/Transmit interrupt*/
    UART5_ERR_IRQHandler,      /* UART5 Error interrupt*/
    CMP2_IRQHandler,           /* CMP2 interrupt*/
    FTM3_IRQHandler,           /* FTM3 fault, overflow and channels interrupt*/
    DAC1_IRQHandler,           /* DAC1 interrupt*/
    ADC1_IRQHandler,           /* ADC1 interrupt*/
    I2C2_IRQHandler,           /* I2C2 interrupt*/
    CAN0_ORed_Message_buffer_IRQHandler, /* CAN0 OR'd message buffers
                                            interrupt*/
    CAN0_Bus_Off_IRQHandler,             /* CAN0 bus off interrupt*/
    CAN0_Error_IRQHandler,               /* CAN0 error interrupt*/
    CAN0_Tx_Warning_IRQHandler,          /* CAN0 Tx warning interrupt*/
    CAN0_Rx_Warning_IRQHandler,          /* CAN0 Rx warning interrupt*/
    CAN0_Wake_Up_IRQHandler,             /* CAN0 wake up interrupt*/
    SDHC_IRQHandler,                     /* SDHC interrupt*/
    ENET_1588_Timer_IRQHandler, /* Ethernet MAC IEEE 1588 Timer Interrupt*/
    ENET_Transmit_IRQHandler,   /* Ethernet MAC Transmit Interrupt*/
    ENET_Receive_IRQHandler,    /* Ethernet MAC Receive Interrupt*/
    ENET_Error_IRQHandler,   /* Ethernet MAC Error and miscelaneous Interrupt*/
    DefaultISR,              /* 102*/
    DefaultISR,              /* 103*/
    DefaultISR,              /* 104*/
    DefaultISR,              /* 105*/
    DefaultISR,              /* 106*/
    DefaultISR,              /* 107*/
    DefaultISR,              /* 108*/
    DefaultISR,              /* 109*/
    DefaultISR,              /* 110*/
    DefaultISR,              /* 111*/
    DefaultISR,              /* 112*/
    DefaultISR,              /* 113*/
    DefaultISR,              /* 114*/
    DefaultISR,              /* 115*/
    DefaultISR,              /* 116*/
    DefaultISR,              /* 117*/
    DefaultISR,              /* 118*/
    DefaultISR,              /* 119*/
    DefaultISR,              /* 120*/
    DefaultISR,              /* 121*/
    DefaultISR,              /* 122*/
    DefaultISR,              /* 123*/
    DefaultISR,              /* 124*/
    DefaultISR,              /* 125*/
    DefaultISR,              /* 126*/
    DefaultISR,              /* 127*/
    DefaultISR,              /* 128*/
    DefaultISR,              /* 129*/
    DefaultISR,              /* 130*/
    DefaultISR,              /* 131*/
    DefaultISR,              /* 132*/
    DefaultISR,              /* 133*/
    DefaultISR,              /* 134*/
    DefaultISR,              /* 135*/
    DefaultISR,              /* 136*/
    DefaultISR,              /* 137*/
    DefaultISR,              /* 138*/
    DefaultISR,              /* 139*/
    DefaultISR,              /* 140*/
    DefaultISR,              /* 141*/
    DefaultISR,              /* 142*/
    DefaultISR,              /* 143*/
    DefaultISR,              /* 144*/
    DefaultISR,              /* 145*/
    DefaultISR,              /* 146*/
    DefaultISR,              /* 147*/
    DefaultISR,              /* 148*/
    DefaultISR,              /* 149*/
    DefaultISR,              /* 150*/
    DefaultISR,              /* 151*/
    DefaultISR,              /* 152*/
    DefaultISR,              /* 153*/
    DefaultISR,              /* 154*/
    DefaultISR,              /* 155*/
    DefaultISR,              /* 156*/
    DefaultISR,              /* 157*/
    DefaultISR,              /* 158*/
    DefaultISR,              /* 159*/
    DefaultISR,              /* 160*/
    DefaultISR,              /* 161*/
    DefaultISR,              /* 162*/
    DefaultISR,              /* 163*/
    DefaultISR,              /* 164*/
    DefaultISR,              /* 165*/
    DefaultISR,              /* 166*/
    DefaultISR,              /* 167*/
    DefaultISR,              /* 168*/
    DefaultISR,              /* 169*/
    DefaultISR,              /* 170*/
    DefaultISR,              /* 171*/
    DefaultISR,              /* 172*/
    DefaultISR,              /* 173*/
    DefaultISR,              /* 174*/
    DefaultISR,              /* 175*/
    DefaultISR,              /* 176*/
    DefaultISR,              /* 177*/
    DefaultISR,              /* 178*/
    DefaultISR,              /* 179*/
    DefaultISR,              /* 180*/
    DefaultISR,              /* 181*/
    DefaultISR,              /* 182*/
    DefaultISR,              /* 183*/
    DefaultISR,              /* 184*/
    DefaultISR,              /* 185*/
    DefaultISR,              /* 186*/
    DefaultISR,              /* 187*/
    DefaultISR,              /* 188*/
    DefaultISR,              /* 189*/
    DefaultISR,              /* 190*/
    DefaultISR,              /* 191*/
    DefaultISR,              /* 192*/
    DefaultISR,              /* 193*/
    DefaultISR,              /* 194*/
    DefaultISR,              /* 195*/
    DefaultISR,              /* 196*/
    DefaultISR,              /* 197*/
    DefaultISR,              /* 198*/
    DefaultISR,              /* 199*/
    DefaultISR,              /* 200*/
    DefaultISR,              /* 201*/
    DefaultISR,              /* 202*/
    DefaultISR,              /* 203*/
    DefaultISR,              /* 204*/
    DefaultISR,              /* 205*/
    DefaultISR,              /* 206*/
    DefaultISR,              /* 207*/
    DefaultISR,              /* 208*/
    DefaultISR,              /* 209*/
    DefaultISR,              /* 210*/
    DefaultISR,              /* 211*/
    DefaultISR,              /* 212*/
    DefaultISR,              /* 213*/
    DefaultISR,              /* 214*/
    DefaultISR,              /* 215*/
    DefaultISR,              /* 216*/
    DefaultISR,              /* 217*/
    DefaultISR,              /* 218*/
    DefaultISR,              /* 219*/
    DefaultISR,              /* 220*/
    DefaultISR,              /* 221*/
    DefaultISR,              /* 222*/
    DefaultISR,              /* 223*/
    DefaultISR,              /* 224*/
    DefaultISR,              /* 225*/
    DefaultISR,              /* 226*/
    DefaultISR,              /* 227*/
    DefaultISR,              /* 228*/
    DefaultISR,              /* 229*/
    DefaultISR,              /* 230*/
    DefaultISR,              /* 231*/
    DefaultISR,              /* 232*/
    DefaultISR,              /* 233*/
    DefaultISR,              /* 234*/
    DefaultISR,              /* 235*/
    DefaultISR,              /* 236*/
    DefaultISR,              /* 237*/
    DefaultISR,              /* 238*/
    DefaultISR,              /* 239*/
    DefaultISR,              /* 240*/
    DefaultISR,              /* 241*/
    DefaultISR,              /* 242*/
    DefaultISR,              /* 243*/
    DefaultISR,              /* 244*/
    DefaultISR,              /* 245*/
    DefaultISR,              /* 246*/
    DefaultISR,              /* 247*/
    DefaultISR,              /* 248*/
    DefaultISR,              /* 249*/
    DefaultISR,              /* 250*/
    DefaultISR,              /* 251*/
    DefaultISR,              /* 252*/
    DefaultISR,              /* 253*/
    DefaultISR,              /* 254*/
    (irq_handler)0xFFFFFFFF, /*  Reserved for user TRIM value*/
};

static const uint32_t flash_config[]
    __attribute__((section(".fconfig"), used)) = {0xFFFFFFFF, 0xFFFFFFFF,
                                                  0xFFFFFFFF, 0xFFFFFFFE};

__attribute__((noreturn)) void Reset_Handler(void) {
  extern int main(void);
  extern uint32_t __text_end__;
  extern uint32_t __data_start__;
  extern uint32_t __data_end__;
  extern uint32_t __bss_start__;
  extern uint32_t __bss_end__;

  SystemInit();
  uint32_t *data_start_flash = &__text_end__;
  uint32_t *copy_start = &__data_start__;

  while (copy_start < &__data_end__) {
    *copy_start++ = *data_start_flash++;
  }

  uint32_t *bss_start = &__bss_start__;

  while (bss_start < &__bss_end__) {
    *bss_start++ = 0UL;
  }

  main();

  while (1) {
  }
}

void Default_Handler(void) {
  while (1) {
  }
}
