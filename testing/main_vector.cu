#include <spinta.cuh>

#include <vector>
#include <iostream>

template<typename T>
__global__ void setvalue(T* src, T* dest){
    int i = threadIdx.x;

    dest[i] = src[i];
}

int main(){
    // Testing RAII
    spinta::parallel::vector<int> myvet(10);
    spinta::parallel::vector<int> dest(10);

    setvalue<int><<<1,1>>>(myvet.gpu_ptr(), dest.gpu_ptr());

    cudaDeviceSynchronize();
}
