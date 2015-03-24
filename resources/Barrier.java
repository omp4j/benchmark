package org.omp4j.benchmark;

public class Barrier extends AbstractBenchmark {

	public Barrier(int workload) {
		super(workload);
	}

	@Override
	protected void runBenchmark() {
		// omp parallel threadNum(!threadNum!) schedule(!schedule!)
		{
			// omp for
			for (int j = 0; j < workload; j++) {
				work();
	
				// omp barrier
				{}
			}

		}
	}

	@Override
	protected void runReference() {
		for (int t = 0; t < !threadNum!; t++) {
			for (int j = 0; j < workload; j++) {
				work();
			}
		}
	}
}
