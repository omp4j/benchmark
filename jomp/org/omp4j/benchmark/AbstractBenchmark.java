package org.omp4j.benchmark;

public abstract class AbstractBenchmark {

	protected int workload;
	protected final long timeout = 10;

	public AbstractBenchmark(Integer workload) {
		this.workload = workload;
	}

	public final double getSpeedup() {
		warmup();

		long startR = System.nanoTime();
		runReference();
		long stopR = System.nanoTime();

		long startB = System.nanoTime();
		runBenchmark();
		long stopB = System.nanoTime();

		return 1.0 * (stopR - startR) / (stopB - startB);
	}

	protected final void work() {
		try {
			Thread.sleep(timeout);
		} catch (InterruptedException e) {}
	}

	protected void warmup() {}

	protected abstract void runBenchmark();
	protected abstract void runReference();

}
