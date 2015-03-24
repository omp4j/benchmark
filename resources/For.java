package org.omp4j.benchmark;

public class For extends AbstractBenchmark {

	public For(int workload) {
		super(workload);
	}

	@Override
	protected void runBenchmark() {
		// omp parallel threadNum(!threadNum!) schedule(!schedule!)
		{
			for (int i = 0; i < workload; i++) {
				// omp for
				for (int j = 0; j < !threadNum!; j++) {
					work();
				}
			}
		}
	}

	@Override
	protected void runReference() {
		for (int t = 0; t < !threadNum!; t++) {
			for (int i = 0; i < workload; i++) {
				for (int j = 0; j < !threadNum!; j++) {
					work();
				}
			}
		}
	}
}
