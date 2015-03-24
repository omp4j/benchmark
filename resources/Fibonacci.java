package org.omp4j.benchmark;

public class Fibonacci extends AbstractBenchmark {

	public Fibonacci(int workload) {
		super(workload);
	}

	private int fibonacci(int n) {
		if (n <= 1) return 1;
		else return fibonacci(n-1) + fibonacci(n-2);
	}

	@Override
	protected void runBenchmark() {
		// omp parallel for threadNum(!threadNum!) schedule(!schedule!)
		for (int i = 0; i < workload; i++) {
			fibonacci(30 + i % 5);
		}
	}

	@Override
	protected void runReference() {
		for (int i = 0; i < workload; i++) {
			fibonacci(30 + i % 5);
		}
	}
}
