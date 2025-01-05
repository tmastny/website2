#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>
#if defined(__APPLE__)
#include <mach/thread_policy.h>
#include <mach/thread_act.h>
#endif

#define ARRAY_SIZE 80000
#define FLUSH_SIZE 50000000
#define CACHE_LINE 128
#define ITERATIONS 10

// Pin current thread to a specific core (0 in this case)
static void pin_to_core(void) {
#if defined(__APPLE__)
    thread_affinity_policy_data_t policy = { 0 };  // Core 0
    thread_port_t mach_thread = pthread_mach_thread_np(pthread_self());
    thread_policy_set(mach_thread, THREAD_AFFINITY_POLICY,
                     (thread_policy_t)&policy, 1);
#endif
}

__attribute__((noinline))
void flush_cache(uint64_t *flush, size_t size, unsigned int *seed) {
    volatile uint64_t dummy = 0;
    for (size_t i = 0; i < size; i++) {
        size_t idx = rand_r(seed) % size;
        dummy += flush[idx];
    }
}

__attribute__((noinline))
uint64_t sum_array(uint64_t *A, size_t size) {
    uint64_t sum = 0;
    for (size_t i = 0; i < size; i++) {
        sum += A[i];
    }
    return sum;
}

int main() {
    pin_to_core();

    uint64_t *A = NULL;
    if (posix_memalign((void**)&A, CACHE_LINE, ARRAY_SIZE * sizeof(uint64_t)) != 0) {
        printf("Failed to allocate aligned memory\n");
        return 1;
    }

    uint64_t *flush = NULL;
    if (posix_memalign((void**)&flush, CACHE_LINE, FLUSH_SIZE * sizeof(uint64_t)) != 0) {
        printf("Failed to allocate aligned flush memory\n");
        free(A);
        return 1;
    }

    unsigned int seed = time(NULL);
    for (int i = 0; i < ARRAY_SIZE; i++) {
        A[i] = rand_r(&seed);
    }

    for (int iter = 0; iter < ITERATIONS; iter++) {
        flush_cache(flush, FLUSH_SIZE, &seed);
        uint64_t sum = sum_array(A, ARRAY_SIZE);
        printf("Sum: %lu, Iteration: %d\n", sum, iter);
    }

    free(flush);
    free(A);
    return 0;
}

/*
gcc -g -O2 -fno-vectorize sum.c -o sum
*/