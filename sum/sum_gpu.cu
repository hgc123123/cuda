//
// Created by Administrator on 2022/3/8 0008.
//

#include"cuda_runtime.h"
#include<iostream>
#include<stdlib.h>
#include<sys/time.h>
using namespace std;

__global__ void Plus(float A[],float B[],float C[],int n){
    int i=blockDim.x*blockIdx.x+threadIdx.x;
    C[i]=A[i]+B[i];
}

int main(){
    struct timeval start,end;
    gettimeofday(&start,NULL);
    float *A,*B,*C,*Ad,*Bd,*Cd;
    int n=1024*1024;
    int size=n*sizeof(float);
    A=(float*)malloc(size);
    B=(float*)malloc(size);
    C=(float*)malloc(size);
    for(int i=0;i<n;i++){
        A[i]=10.0;
        B[i]=90.0;
    }
    cudaMalloc((void **)&Ad,size);
    cudaMalloc((void **)&Bd,size);
    cudaMalloc((void **)&Cd,size);

    cudaMemcpy(Ad,A,size,cudaMemcpyHostToDevice);
    cudaMemcpy(Bd,B,size,cudaMemcpyHostToDevice);
    //cudaMemcpy(Cd,C,size,cudaMemcpyHostToDevice);

    dim3 dimBlock(1024);
    dim3 dimGrid(n/1024);
    Plus<<<dimGrid,dimBlock>>>(Ad,Bd,Cd,n);

    cudaMemcpy(C,Cd,size,cudaMemcpyDeviceToHost);
    float max_error=0.0;
    for(int i=0;i<n;i++){
        max_error+=fabs(100.0-C[i]);
    }
    cout<<"max error is: "<<max_error<<endl;
    free(A);
    free(B);
    free(C);
    cudaFree(Ad);
    cudaFree(Bd);
    cudaFree(Cd);
    gettimeofday(&end,NULL);
    int timeuse=1000000*(end.tv_sec-start.tv_sec)+end.tv_usec-start.tv_usec;
    cout<<"Total time is: "<<timeuse/1000<<"ms"<<endl;
    return 0;
}





