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
		long start = System.nanoTime();
		test.run();
		long stop = System.nanoTime();
		System.out.println(fqn + ";" + start + ";" + stop);
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
