package org.omp4j.benchmark;

import java.util.Random;

public class Max2D extends AbstractBenchmark {

	public Max2D(int workload) {
		super(workload);
	}

	private final int chunk = 500;

	private double fun(int ix, int iy) {
		double x = (double) ix;
		double y = (double) iy;

		return Math.log(x*x + 6*y) - Math.sin(x-y) + 4*Math.sqrt(Math.abs(x*x*x - y*y*y)) - Math.cosh(3*x);
	}

	@Override
	protected void runBenchmark() {

		double totalMax = Double.NEGATIVE_INFINITY;

		// omp parallel for threadNum(!threadNum!) schedule(!schedule!)
		for (int i = -workload/2; i < workload/2; i+=chunk) {
			double maxR = Double.NEGATIVE_INFINITY;

			for (int d = 0; d < chunk; d++) {
				for (int j = -workload/2; j < workload/2; j++) {
					double val = fun(i+d,j);
					maxR = Math.max(maxR, val);
				}
			}

			// omp critical
			{
				totalMax = Math.max(totalMax, maxR);
			}
		}
	}

	@Override
	protected void runReference() {
		double totalMax = Double.NEGATIVE_INFINITY;
		for (int i = -workload/2; i < workload/2; i++) {
			for (int j = -workload/2; j < workload/2; j++) {
				totalMax = Math.max(totalMax, fun(i,j));
			}
		}
	}
}
