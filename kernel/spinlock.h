// Mutual exclusion lock.
struct spinlock {
  uint locked;       // Is the lock held? /* 0 没有锁住， 1 锁住 */

  // For debugging:
  char *name;        // Name of lock.
  struct cpu *cpu;   // The cpu holding the lock.
};

