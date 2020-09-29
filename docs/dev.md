# 项目介绍

项目基本结构如下所示

    +-- BSP/: borad support package, 嵌入式板子支持工具包
        +-- Hardware/
            +-- CH20/
            +-- OLED/
            +-- PM2D5/
        +-- Inc/: BSP 头文件
        +-- Src/
            +-- main.c: 板子启动后, 从这里的 main 函数开始执行
    +-- docs/: 相关文档
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
