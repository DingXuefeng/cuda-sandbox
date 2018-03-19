#include <sys/time.h>
#include <sys/times.h>
#include <iostream>
#include <functional>
void test(std::function<void()> t,int N) {
  clock_t startCPU, stopCPU;
  timeval startTime, stopTime, totalTime;
  tms startProc, stopProc;
  gettimeofday(&startTime, NULL);
  startCPU = times(&startProc);

  for(int i = 0 ;i<N;++i) {
    t();
  }

  stopCPU = times(&stopProc);
  gettimeofday(&stopTime, NULL);
  double myCPU = stopCPU - startCPU;
  double totalCPU = myCPU;
  timersub(&stopTime, &startTime, &totalTime);
  std::cout << "Wallclock time  : " << totalTime.tv_sec + totalTime.tv_usec/1000000.0 << " seconds."<<std::endl;
  std::cout << "CPU time: " << (myCPU / CLOCKS_PER_SEC) << std::endl;
  std::cout << "Total CPU time: " << (totalCPU / CLOCKS_PER_SEC) << std::endl;
  myCPU = stopProc.tms_utime - startProc.tms_utime;
  std::cout << "Processor time: " << (myCPU / CLOCKS_PER_SEC) << std::endl;
}
void logLL();
void RPF();
void MVLL();
int main(int argc,char *argv[]) {
  if(argc==1) std::cout<<argv[0]<<std::endl;
  test(logLL,10);
  test(logLL,10000);
  test(RPF,10000);
  test(MVLL,10000);
  return 0;
}

