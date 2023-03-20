#include <for_each.cuh>
#include <cuda.h>
#include <thrust/device_vector.h>

template <typename T>
class mark
{
    public:
    __host__ __device__ T operator()(T x){printf("%d\n", x*2);}
};

int main(){
    std::vector<int> hh{10, 11, 12};
    thrust::device_vector<int> test{hh.begin(), hh.end()};
    mark<int> s;

    spinta::parallel::for_each(test.begin(), test.end(), s);

    cudaDeviceSynchronize();
}