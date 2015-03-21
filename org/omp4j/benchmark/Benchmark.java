package org.omp4j.benchmark;

public class Benchmark implements Runnable {

	final private Runnable test;
	final String fqn;

	public Benchmark(String fqn) throws ClassNotFoundException, InstantiationException, IllegalAccessException {
		this.fqn = fqn;
		Class<Runnable> c = (Class<Runnable>) Class.forName(fqn);
		test = c.newInstance();
	}

	@Override
	public void run() {
		// identify test
		String tokens[] = fqn.split("_");
		String id = tokens[0];
		String threads = tokens[1];
		String workload = tokens[2];
		String schedule = tokens[3];

		// measure walltime
		long start = System.nanoTime();
		test.run();
		long stop = System.nanoTime();

		// print output
		System.out.format("%s;%s;%s;%s;%s;%d;%d\n", fqn, id, threads, workload, schedule, start, stop);
	}

	public static void main(String[] args) {
		try {
			Runnable bench = new Benchmark(args[0]);
			bench.run();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
