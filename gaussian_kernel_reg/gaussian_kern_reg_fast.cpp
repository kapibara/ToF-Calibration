 
#include <mex.h>
#include <math.h>
#include <ctime>
#include <iostream>

inline double sqrdist2d(const double *p1, const double *p2)
{
    return (p1[0] - p2[0])*(p1[0] - p2[0]) + (p1[1] - p2[1])*(p1[1] - p2[1]);
}

inline double sqrdist3d(const double *p1, const double *p2)
{
    return (p1[0] - p2[0])*(p1[0] - p2[0]) + (p1[1] - p2[1])*(p1[1] - p2[1]) + (p1[2] - p2[2])*(p1[2] - p2[2]);  
}
 
void regress(double *result, const double *X, const double *Xpi, const double *Ypi, int dim, int XN, int XpiN, double h)
{
    double Ksum,K;
    double h2 = 2*h*h;
  
    for(int i=0; i<XN; i++)
    {
      Ksum = 0.0;
      result[i] = 0.0;
      
      for(int j=0; j< XpiN; j++)
      {
        K = expf(-sqrdist2d(X+i*dim,Xpi+j*dim)/h2);
        result[i]+=K*Ypi[j];
        Ksum += K;
      }
      result[i] /= Ksum;
    }
} 
  
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    const mxArray* X = prhs[0];
    const mxArray* Xpi = prhs[1];
    const mxArray* Ypi = prhs[2];
    const mxArray* h = prhs[3];
    
    mwSize d = mxGetM(X);
    mwSize XN = mxGetN(X);
    mwSize XpiN = mxGetN(Xpi);  
    
    double bw = *((const double*)mxGetData(h));
    
    mxArray* result = mxCreateNumericMatrix(1, XN, mxDOUBLE_CLASS, mxREAL);
    
    regress((double *)mxGetData(result),(const double *)mxGetData(X),(const double *)mxGetData(Xpi),(const double *)mxGetData(Ypi),d,XN,XpiN,bw);
    
    plhs[0] = result;
}
/*
int main(int argc, char **argv)
{
    int XN = 319, XpiN = 1997;
    double *X = new double [XN*2];
    double *Xpi = new double [XpiN*2];
    double *Y = new double [XpiN];
    double *result = new double[XN];
    double bw = 32;
    
    clock_t start = clock();
    for(int i=0; i<100*29; i++){
        regress(result,X,Xpi,Y,2,XN,XpiN,bw);
    }
    clock_t ends = clock();
    
    std::cout << "Running Time : " << (double) (ends - start) / CLOCKS_PER_SEC << std::endl;
    
    return 0;

}*/

