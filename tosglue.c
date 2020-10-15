/*

    TencentOS API wrapper for rust world

*/

#include "tos_k.h"
#include "esp8266_tencent_firmware.h"
#include "tencent_firmware_module_wrapper.h"
#include "ch20_parser.h"
#include "oled.h"
#include "user_config.h"

void rust_print(const char *msg) {
    printf("%s\r\n", msg);
}

void rust_oled_print(unsigned int x, unsigned int y, char *msg) {
    OLED_ShowString(0, 2, (uint8_t*)msg, 16);
}

int rust_wifi_init() {
    esp8266_tencent_firmware_sal_init(HAL_UART_PORT_2);
}

void rust_wifi_connect(const char *ssid, const char *psd) {
    esp8266_tencent_firmware_join_ap(ssid, psd);
}

void rust_sleep(unsigned int ms) {
    tos_sleep_ms(ms);
}
