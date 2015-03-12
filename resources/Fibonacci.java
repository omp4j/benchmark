public class Fibonacci implements Runnable {

	private int fibonacci(int n) {
		if (n <= 1) return 1;
		else return fibonacci(n-1) + fibonacci(n-2);
	}

	@Override
	public void run() {

		int arr[] = new int[10];

		// omp parallel for threadNum(!threadNum!) schedule(!schedule!)
		for (int i = 0; i < !N!; i++) {
			fibonacci(30);
		}
	}
}
