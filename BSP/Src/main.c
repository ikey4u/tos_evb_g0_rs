#include "mcu_init.h"
#include "cmsis_os.h"

#define APPLICATION_TASK_STK_SIZE       1024
extern void application_entry_rust();
osThreadDef(application_entry_rust, osPriorityNormal, 1, APPLICATION_TASK_STK_SIZE);

/*
__weak void application_entry_rust()
{
    while (1) {
        printf("This is a demo task,please use your task entry!\r\n");
        tos_task_delay(1000);
    }
}
*/

int main(void)
{
    board_init();
    printf("Welcome to TencentOS tiny\r\n");
    osKernelInitialize();
    osThreadCreate(osThread(application_entry_rust), NULL);
    osKernelStart();
}
