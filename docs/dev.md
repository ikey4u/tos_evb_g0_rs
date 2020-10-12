# 项目介绍

项目基本结构如下所示

    +-- docs/: 相关文档
    +-- src
        +-- BSP/: borad support package, 嵌入式板子支持工具包
            +-- Hardware/
                +-- CH20/
                +-- OLED/
                +-- PM2D5/
            +-- Inc/: BSP 头文件
            +-- Src/
                +-- main.c: 板子启动后, 从这里的 main 函数开始执行
        +-- main.c: 入口文件
        +-- toolchain/: 工具链编译配置
        +-- TOS_CONFIG/
            +-- tos_config.h: tos 配置
            +-- _user_config: 用户信息配置
        +-- CMakeLists.txt: 整个项目的 cmake 文件
    +-- README.md: 项目概览文档

板子启动后会自动执行 BSP/Src/main.c 中的 main 函数,
在 main 函数中会调用用户定义的如下函数

    void application_entry(void *arg);

这个函数的默认定义如下

    __weak void application_entry(void *arg)
    {
        while (1) {
            printf("This is a demo task,please use your task entry!\r\n");
            tos_task_delay(1000);
        }
    }

`__weak` 修饰符并非 C/C++ 标准关键字, 属于编译器相关的符号.
这个符号表示该函数在链接时可以被覆盖掉, 这有什么好处呢?
这样能够确保如果用户定义了这个函数, 那么该函数的实际实现就是用户的实现,
如果用户没有实现, 那么就采用默认实现. 因此无论在哪种情况,
都能够确保该函数有一个具体的实现.

入口函数 `application_entry` 定义在项目根目录下的 `main.c` 中.

除了入口函数, 需要有底层的中断服务实现, 这个实现位于 `BSP/Src/stm32g0xx_it.c` 中.

# 集成 rust

主要参考如下几篇文章

Hosting Embedded Rust apps on Apache Mynewt with STM32 Blue Pill: https://medium.com/@ly.lee/hosting-embedded-rust-apps-on-apache-mynewt-with-stm32-blue-pill-c86b119fe5f
STM32L0 Rust Part 1 - Getting Started: https://craigjb.com/2019/12/31/stm32l0-rust/: https://github.com/hashmismatch/freertos.rs

基本的设计架构如下


    ------------------------------------
            Rust Application
    ------------------------------------
            Rust Wrapper
    ------------------------------------
    TencentOS API | Third Libraries API
    ------------------------------------
              TencentOS
    ------------------------------------


- 基础准备

    如果 rustc 版本低于 1.47.0 则切换到 nightly 版本, 否则不用切换

        rustup default nightly

    安装 target

        rustup target add thumbv6m-none-eabi

    安装 arm-none-eabi-xxx 工具链

        sudo apt-get install -y gcc-arm-none-eabi

    其他可选工具

        sudo apt-get install gdb-arm-none-eabi
        sudo apt-get install OpenOCD

    获取 libcore 路径

        RUST_THUMBV6M_SYSROOT=$(rustc --print sysroot --target thumbv6m-none-eabi)
        RUST_LIBCORE_SRC=$(ls -1 $RUST_THUMBV6M_SYSROOT/lib/rustlib/thumbv6m-none-eabi/lib/libcore-*.rlib)

    查看 rlib 的内容

        arm-none-eabi-ar t $RUST_LIBCORE_SRC

            core-1ba29f225cca71e5.core.1ml6ett9-cgu.0.rcgu.o
            lib.rmeta

- 新建项目

    cargo new app

    1. 进入 app/src 目录, 删除 main.rs, 然后新建 lib.rs.
    2. 配置 app/Cargo.toml
    3. 配置 app/.cargo/config 文件

    然后执行 cargo build 构建文件.

    在 app/target/thumbv6m-none-eabi/debug/deps 目录中是构建的 .rlib 产物,
    每一个 rlib 文件实际上是包含了编译过程对象文件.

- TOS 构建过程

- 封装 tos API 供 rust 调用
