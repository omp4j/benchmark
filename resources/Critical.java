package org.omp4j.benchmark;

public class Critical extends AbstractBenchmark {

	public Critical(int workload) {
		super(workload);
	}

	@Override
	protected void runBenchmark() {
		// omp parallel threadNum(!threadNum!) schedule(!schedule!)
		{
			// omp for
			for (int j = 0; j < workload / !threadNum!; j++) {
				// omp critical
				{
					work();
				}
			}
		}
	}

	@Override
	protected void runReference() {
		for (int t = 0; t < !threadNum!; t++) {
			for (int j = 0; j < workload / !threadNum!; j++) {
				work();
			}
		}
	}
}

