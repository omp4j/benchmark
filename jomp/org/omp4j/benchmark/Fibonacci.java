package org.omp4j.benchmark;

public class Fibonacci extends AbstractBenchmark {


	public Fibonacci(int workload) {
		super(workload);
	}

	private int fibonacci(int n) {
		if (n <= 1) return 1;
		else return fibonacci(n-1) + fibonacci(n-2);
	}

	protected void runBenchmark() {

// OMP PARALLEL BLOCK BEGINS
{
  __omp_Class0 __omp_Object0 = new __omp_Class0();
  // shared variables
  __omp_Object0.workload = workload;
  // firstprivate variables
  try {
    jomp.runtime.OMP.doParallel(__omp_Object0);
  } catch(Throwable __omp_exception) {
    System.err.println("OMP Warning: Illegal thread exception ignored!");
    System.err.println(__omp_exception);
  }
  // reduction variables
  // shared variables
  workload = __omp_Object0.workload;
}
// OMP PARALLEL BLOCK ENDS

	}

	protected void runReference() {
		for (int i = 0; i < workload; i++) {
			fibonacci(20 + i % 13);
		}
	}

// OMP PARALLEL REGION INNER CLASS DEFINITION BEGINS
private class __omp_Class0 extends jomp.runtime.BusyTask {
  // shared variables
  int workload;
  // firstprivate variables
  // variables to hold results of reduction

  public void go(int __omp_me) throws Throwable {
  // firstprivate variables + init
  // private variables
  // reduction variables, init to default
    // OMP USER CODE BEGINS

                          { // OMP FOR BLOCK BEGINS
                          // copy of firstprivate variables, initialized
                          // copy of lastprivate variables
                          // variables to hold result of reduction
                          boolean amLast=false;
                          {
                            // firstprivate variables + init
                            // [last]private variables
                            // reduction variables + init to default
                            // -------------------------------------
                            jomp.runtime.LoopData __omp_WholeData2 = new jomp.runtime.LoopData();
                            jomp.runtime.LoopData __omp_ChunkData1 = new jomp.runtime.LoopData();
                            __omp_WholeData2.start = (long)( 0);
                            __omp_WholeData2.stop = (long)( workload);
                            __omp_WholeData2.step = (long)(1);
                            __omp_WholeData2.chunkSize = 1;
                            jomp.runtime.OMP.initTicket(__omp_me, __omp_WholeData2);
                            while(!__omp_ChunkData1.isLast && jomp.runtime.OMP.getLoopDynamic(__omp_me, __omp_WholeData2, __omp_ChunkData1)) {
                              for(int i = (int)__omp_ChunkData1.start; i < __omp_ChunkData1.stop; i += __omp_ChunkData1.step) {
                                // OMP USER CODE BEGINS
 {
			fibonacci(20 + i % 13);
		}
                                // OMP USER CODE ENDS
                                if (i == (__omp_WholeData2.stop-1)) amLast = true;
                              } // of for 
                            } // of while
                            // call reducer
                            jomp.runtime.OMP.resetTicket(__omp_me);
                            jomp.runtime.OMP.doBarrier(__omp_me);
                            // copy lastprivate variables out
                            if (amLast) {
                            }
                          }
                          // set global from lastprivate variables
                          if (amLast) {
                          }
                          // set global from reduction variables
                          if (jomp.runtime.OMP.getThreadNum(__omp_me) == 0) {
                          }
                          } // OMP FOR BLOCK ENDS

    // OMP USER CODE ENDS
  // call reducer
  // output to _rd_ copy
  if (jomp.runtime.OMP.getThreadNum(__omp_me) == 0) {
  }
  }
}
// OMP PARALLEL REGION INNER CLASS DEFINITION ENDS

}

