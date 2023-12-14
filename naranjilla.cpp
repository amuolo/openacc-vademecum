#include <iostream>
#include <any>
#include <armadillo>

#include <omp.h>
#include <openblas/cblas.h>


using namespace std;


int main()
{
  cout << "!!! I am Naranjilla - Hello World!!!" << endl;
  cout << openblas_get_config() << endl << endl;

  omp_set_num_threads(1);
  openblas_set_num_threads(1);

  const int N=30;

  arma::mat eigvec, Arand = arma::randu<arma::mat>(N,N), Asym = Arand+Arand.st();
  arma::vec eigval;

  arma::eig_sym(eigval,eigvec,Asym,"dc");

  arma::mat Ainv=arma::inv(Asym);

  /*
   *  -ta=tesla compiler option (ta means target accelerator and tesla targets NVIDIA Tesla GPUs)
   *  -Minfo=accel compiler flag to tell the compiler to provide feedback about the code it generates.
   */

  arma::mat A (N, N, arma::fill::zeros);
  arma::mat B (N, N, arma::fill::zeros);
  arma::mat C (N, N, arma::fill::zeros);

  double* XA = A.memptr();
  double* XB = B.memptr();
  double* XC = C.memptr();

  #pragma acc data copy(XA) copy(XB) copy(XC)

  #pragma acc kernels
  {
    for(int a=0; a<N; a++)
      for(int b=0; b<N; b++)
	for(int i=0; i<N; i++)
	  XC[a+N*b] += XA[a+N*b]*XB[i+N*b];
  }

  return 0;
}






