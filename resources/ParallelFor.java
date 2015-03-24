package org.omp4j.benchmark;

public class ParallelFor extends AbstractBenchmark {

	public ParallelFor(int workload) {
		super(workload);
	}

	@Override
	protected void runBenchmark() {
		for (int i = 0; i < workload; i++) {
			// omp parallel for threadNum(!threadNum!) schedule(!schedule!)
			for (int j = 0; j < !threadNum!; j++) {
				work();
			}
		}
	}

	@Override
	protected void runReference() {
		for (int i = 0; i < workload; i++) {
			for (int j = 0; j < !threadNum!; j++) {
				work();
			}
		}
	}
}
