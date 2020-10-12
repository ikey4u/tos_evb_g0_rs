# FIXME

- `app/target` 导致固件无法正常运行

    如果 rust 编译后的 `app/target` 目录存在, 此时重新对固件进行编译 

        mkdir -p build && cd build && cmake ..
        make
        make flash

    烧录后的系统只会成功订阅一次, 之后无法订阅成功.

# 教程

## 基本编译信息

- 配置信息

    将 `TOS_CONFIG/_user_config.h` 复制一份为 `TOS_CONFIG/user_config.h`,
    写入设备信息和 WiFI 信息.

- 环境变量

    新建系统环境变量 TOS_SRC_ROOT, 其值为 TencentOS Tiny 的源码绝对路径.

- 编译

        mkdir -p build && cd build && cmake ..
        make
        make flash

更多详细可以参考 `docs/` 目录.

