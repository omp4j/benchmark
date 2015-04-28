#include <omp.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <err.h>
#include <errno.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <arpa/inet.h>

#define ITERS 1000

uint64_t now ()
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	double time_in_mill =  (tv.tv_sec) * 1000 + (tv.tv_usec) / 1000;
	return ((uint64_t) time_in_mill);
}

int fibonacci (const int n)
{
	if (n <= 1) return 1;
	else return fibonacci(n-1) + fibonacci(n-2);
}

int main (int argc, char ** argv)
{

	uint64_t start_t = now();

	#pragma omp parallel for schedule(dynamic)
	for (int i = 0; i < ITERS; i++) {
		fibonacci(20 + i % 13);
	}

	uint64_t end_t = now();

	printf("%s;%s;%d;%d;%s;%llu;%llu\n",
		"cpp_test",
		"org.omp4j.benchmark.CppFibonacci",
		omp_get_max_threads(),
		ITERS,
		"dynamic",
		(unsigned long long)(start_t),
		(unsigned long long)(end_t)
	);

	return 0;
}
