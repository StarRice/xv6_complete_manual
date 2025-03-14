# Initial process that execs /init.
# This code runs in user space.

# xv6 内核启动的第一个用户态进程。

#include "syscall.h"

# exec(init, argv)
.globl start              # start 标签，代表程序的入口点
start:
        la a0, init       # 将init字符串的地址加载到a0寄存器，作为第一个参数
        la a1, argv       # 将argv的地址，作为第二个参数
        li a7, SYS_exec   # 调用 系统调用 exec
        ecall             # 若成功，当前进程会被 /init 覆盖，执行 /init 进程。
# exec 失败，代码会跳到 exit 标签
# for(;;) exit();
exit:
        li a7, SYS_exit
        ecall       # 执行exit() 以终止进程
        jal exit    #如果 exit 失败，会继续跳转到 exit 重新执行，形成 死循环，防止进程执行非法操作。
# 定义 init 变量
# char init[] = "/init\0";
init: 
  .string "/init\0"

# 定义argv 参数数组
# char *argv[] = { init, 0 };
.p2align 2      # 4字节对齐
argv:
  .quad init
  .quad 0
