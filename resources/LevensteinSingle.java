package org.omp4j.benchmark;

import java.util.Random;

public class LevensteinSingle extends AbstractBenchmark {

	public LevensteinSingle(int workload) {
		super(workload);

		this.strA = getRandomString(workload, 930131);
		this.strB = getRandomString(workload, 310193);
	}

	final private String characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+";
	private String getRandomString(int length, int seed) {
		StringBuilder result = new StringBuilder();
		while(length > 0) {
			Random rand = new Random(seed);
			result.append(characters.charAt(rand.nextInt(characters.length())));
			length--;
		}
		return result.toString();
	}

	final private String strA;
	final private String strB;

	/** Source code from Wikipedia - http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#Java*/
	public int computeLD(String s0, String s1) {						  
		int len0 = s0.length() + 1;													 
		int len1 = s1.length() + 1;													 
	 
		// the array of distances													   
		int[] cost = new int[len0];													 
		int[] newcost = new int[len0];												  
	 
		// initial cost of skipping prefix in String s0								 
		for (int i = 0; i < len0; i++) cost[i] = i;									 
	 
		// dynamically computing the array of distances								  
	 
		// transformation cost for each letter in s1									
		for (int j = 1; j < len1; j++) {												
			// initial cost of skipping prefix in String s1							 
			newcost[0] = j;															 
	 
			// transformation cost for each letter in s0								
			for(int i = 1; i < len0; i++) {											 
				// matching current letters in both strings							 
				int match = (s0.charAt(i - 1) == s1.charAt(j - 1)) ? 0 : 1;			 
	 
				// computing cost for each transformation							   
				int cost_replace = cost[i - 1] + match;								 
				int cost_insert  = cost[i] + 1;										 
				int cost_delete  = newcost[i - 1] + 1;								  
	 
				// keep minimum cost													
				newcost[i] = Math.min(Math.min(cost_insert, cost_delete), cost_replace);
			}																		   
	 
			// swap cost/newcost arrays												 
			int[] swap = cost; cost = newcost; newcost = swap;						  
		}																			   
	 
		// the distance is the cost for transforming all letters in both strings		
		return cost[len0 - 1];														  
	}

	@Override
	protected void runBenchmark() {

		int res = 0;
		// omp parallel threadNum(!threadNum!) schedule(!schedule!)
		{

			// omp single
			{
				res = computeLD(strA, strB);
			}
		}
	}

	@Override
	protected void runReference() {
		computeLD(strA, strB);
	}

	@Override
	protected void warmup() {
		computeLD(strA, strB);
	}


}
