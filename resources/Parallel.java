package org.omp4j.benchmark;

public class Parallel extends AbstractBenchmark {

	public Parallel(int workload) {
		super(workload);
	}

	@Override
	protected void runBenchmark() {
		for (int i = 0; i < workload; i++) {
			// omp parallel threadNum(!threadNum!) schedule(!schedule!)
			{
				work();
			}
		}
	}

	@Override
	protected void runReference() {
		for (int i = 0; i < workload; i++) {
			for (int t = 0; t < !threadNum!; t++) {
				work();
			}
		}
	}
}
