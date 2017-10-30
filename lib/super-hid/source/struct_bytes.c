#include <stdio.h>
#include <stddef.h>

#include <linux/input.h>

void main() {
  printf("sizeof(input_event): % 2d\n", sizeof(struct input_event));
  printf("sizeof(timeval    ): % 2d\n", sizeof(struct timeval    ));
  printf("offsetof(input_event, time ): % 2d\n", offsetof(struct input_event, time ));
  printf("offsetof(input_event, type ): % 2d\n", offsetof(struct input_event, type ));
  printf("offsetof(input_event, code ): % 2d\n", offsetof(struct input_event, code ));
  printf("offsetof(input_event, value): % 2d\n", offsetof(struct input_event, value));
}
