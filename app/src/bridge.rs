use cty::*;

/// These glue functions are from tosfns.c
extern {
    pub fn rust_print(msg: *const u8);
    pub fn rust_oled_print(msg: *const u8);
    pub fn rust_wifi_init();
    pub fn rust_wifi_connect(ssid: *const u8, passwd: *const u8);
    pub fn rust_sleep(ms: u32);
}
