package org.omp4j.benchmark;

import java.util.Random;

public class MM extends AbstractBenchmark {

	public MM(int workload) {
		super(workload);

		A = buildRandomSquare(workload, 930131);
		B = buildRandomSquare(workload, 310193);
	}

	private int[][] buildRandomSquare(int size, long seed) {
		Random r = new Random(seed);
			
		int result[][] = new int[size][size];
		for (int i = 0; i < size; i++)
			for (int j = 0; j < size; j++)
				result[i][j] = r.nextInt(1000);

		return result;
	}

	private final int A[][];
	private final int B[][];

	@Override
	protected void runBenchmark() {

		int result[][] = new int[workload][workload];

		// omp parallel for threadNum(!threadNum!) schedule(!schedule!)
		for (int i = 0; i < workload; i++) {
			for (int j = 0; j < workload; j++) {
				int d = 0;
				for (int k = 0; k < workload; k++) {
					d += A[i][k] * B[k][j];
				}
				result[i][j] += d;
			}
		}
	}

	@Override
	protected void runReference() {
		int result[][] = new int[workload][workload];

		for (int i = 0; i < workload; i++) {
			for (int j = 0; j < workload; j++) {
				for (int k = 0; k < workload; k++) {
					result[i][j]  += A[i][k] * B[k][j];
				}
			}
		}
	}
}
