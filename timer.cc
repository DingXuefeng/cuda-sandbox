#include <sys/time.h>
#include <sys/times.h>
#include <iostream>
#include <functional>
extern int _M;
void test(std::function<void()> t,int N,int M) {
  clock_t startCPU, stopCPU;
  timeval startTime, stopTime, totalTime;
//  tms startProc, stopProc;
  gettimeofday(&startTime, NULL);
//  startCPU = times(&startProc);

  for(int i = 0 ;i<N;++i) {
    _M = M;
    t();
  }

//  stopCPU = times(&stopProc);
  gettimeofday(&stopTime, NULL);
//  double myCPU = stopCPU - startCPU;
//  double totalCPU = myCPU;
  timersub(&stopTime, &startTime, &totalTime);
  std::cout << "Wallclock time  : " << totalTime.tv_sec + totalTime.tv_usec/1000000.0 << " seconds."<<std::endl;
//  std::cout << "CPU time: " << (myCPU / CLOCKS_PER_SEC) << std::endl;
//  std::cout << "Total CPU time: " << (totalCPU / CLOCKS_PER_SEC) << std::endl;
//  myCPU = stopProc.tms_utime - startProc.tms_utime;
//  std::cout << "Processor time: " << (myCPU / CLOCKS_PER_SEC) << std::endl;
}
void logLL();
void RPF();
void MVLL20();
void MVLL50();
void MVLL70();
int main(int argc,char *argv[]) {
  if(argc!=3) { std::cout<<"usage: "<<argv[0]<<" <N> <M> where M is the scale of the test, N is the number of tests to be performed"<<std::endl; return 0; }
  int N = atoi(argv[1]);
  int M = atoi(argv[2]);
  test(logLL,10,1024);
//  test(logLL,N,M);
//  test(RPF,N,M);
  test(MVLL20,N,M);
//  test(MVLL50,N);
//  test(MVLL70,N);
  return 0;
}

