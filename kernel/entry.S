        # qemu -kernel loads the kernel at 0x80000000
        # and causes each hart (i.e. CPU) to jump there.
        # QEMU加载内核到0x8000_0000,让后让所有的核从这个地址执行
        # kernel.ld causes the following code to
        # be placed at 0x80000000.
        # kernel.ld 链接脚本确保这个 _entry代码放在 0x8000_0000
.section .text
.global _entry
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + (hartid * 4096)
        la sp, stack0        # 加载 stack0 的地址到sp，stack0 在start.c 中定义了
        li a0, 1024*4        # 设置每个CPU的栈的大小为 4KB，加载到 a0 寄存器
        csrr a1, mhartid     # 读取当前CPU的id 【Control and Status Register Read】
        addi a1, a1, 1       # a1 = a1 + 1，避免第一个 CPU 栈和 stack0 重叠
        mul a0, a0, a1       # 计算当前CPU 的栈偏移量
        add sp, sp, a0       # 计算当前CPU栈顶，并赋值给 sp
        # jump to start() in start.c
        call start
spin:
        j spin
