package org.omp4j.benchmark;

import java.lang.reflect.*;

public class Benchmark implements Runnable {

	final private AbstractBenchmark test;
	final String fqn;
	final int workload;

	public Benchmark(String fqn, int workload) throws ClassNotFoundException, InstantiationException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
		this.fqn = fqn;
		this.workload = workload;

		Class<AbstractBenchmark> c = (Class<AbstractBenchmark>) Class.forName(fqn);
		Constructor<AbstractBenchmark> constr = (Constructor<AbstractBenchmark>)c.getConstructors()[0];
		this.test = constr.newInstance(workload);
	}

	@Override
	public void run() {
		// identify test

		String id = "FibJOMP";
		String threads = System.getProperty("jomp.threads");
		String schedule = "dynamic";

		double speedup = test.getSpeedup();

		// print output
		System.out.format("%s;%s;%d;%s;%f\n", id, threads, workload, schedule, speedup);
	}

	public static void main(String[] args) {
		try {
			Runnable bench = new Benchmark(args[0], Integer.parseInt(args[1]));
			bench.run();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
