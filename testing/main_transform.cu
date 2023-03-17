#include <transform.cuh>
#include <cuda.h>
#include <thrust/device_vector.h>

template <typename T>
class mark
{
    public:
    __host__ __device__ T operator()(T x){return x+1;}
};

int main(){
    std::vector<int> hh{10, 11, 12};

    thrust::device_vector<int> test{hh.begin(), hh.end()};
    mark<int> s;
    spinta::parallel::transform(test.begin(), test.end(), s);

    cudaDeviceSynchronize();
}