#include "em_chip.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "em_timer.h"

#define MAX_TOP_TIMER3 28000

static volatile uint32_t ms_tick;

void SysTick_Handler(void) { ++ms_tick; }

void MSP_Delay(uint32_t ms_delay) {
  uint32_t cur_tick = ms_tick;

  while (ms_tick - cur_tick < ms_delay) {
  }

  ms_tick = 0;
}

__attribute__((noreturn)) void main(void) {
  CHIP_Init();

  CMU_HFRCOBandSet(cmuHFRCOBand_28MHz);
  SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000);
  CMU_ClockEnable(cmuClock_GPIO, true);
  CMU_ClockEnable(cmuClock_TIMER3, true);

  TIMER_Init_TypeDef tim3 = TIMER_INIT_DEFAULT;
  TIMER_InitCC_TypeDef tim3cc = {timerEventEveryEdge,
                                 timerEdgeNone,
                                 timerPRSSELCh0,
                                 timerOutputActionNone,
                                 timerOutputActionSet,
                                 timerOutputActionClear,
                                 timerCCModePWM,
                                 false,
                                 false,
                                 false,
                                 false};

  uint16_t timer_val = 0;
  int16_t inc = 400;

  TIMER_CounterSet(TIMER3, 0);
  TIMER_TopSet(TIMER3, MAX_TOP_TIMER3);
  TIMER_CompareSet(TIMER3, 2, timer_val);
  TIMER_InitCC(TIMER3, 2, &tim3cc);
  TIMER3->ROUTE = (1 << 16) | (1 << 2);
  TIMER_Init(TIMER3, &tim3);
  GPIO_PinModeSet(gpioPortE, 2, gpioModePushPull, 0);
  GPIO_PinModeSet(gpioPortE, 3, gpioModePushPull, 0);

  while (true) {
    MSP_Delay(5);
    timer_val += inc;

    if (timer_val == 0 || timer_val == MAX_TOP_TIMER3) {
      inc = -inc;
    }

    TIMER_CompareSet(TIMER3, 2, timer_val);
  }
}

int _exit(void) { return 0; }
