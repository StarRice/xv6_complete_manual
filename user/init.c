// init: The initial user-level program

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/spinlock.h"
#include "kernel/sleeplock.h"
#include "kernel/fs.h"
#include "kernel/file.h"
#include "user/user.h"
#include "kernel/fcntl.h"

char *argv[] = { "sh", 0 };

int
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){  /* 打开字符设备 */
    mknod("console", CONSOLE, 0);   /*  如果打开失败，这创建（mknod）一个字符设备/dev/console */
    open("console", O_RDWR);
  }

  /** 标准输入和标准错误就都会输出到 console */
  dup(0);  // stdout   /* (duplicate file descriptor) 复制文件描述符，让两个文件描述符指向同一文件 */
  dup(0);  // stderr

  for(;;){ /* 准备启动 sh */
    printf("init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){ /* 子进程 */
      exec("sh", argv);
      /* 如果成功，子进程执行sh，不会返回 */
      printf("init: exec sh failed\n");
      exit(1);
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
      if(wpid == pid){
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
        printf("init: wait returned an error\n");
        exit(1);
      } else {
        // it was a parentless process; do nothing.
      }
    }
  }
}
