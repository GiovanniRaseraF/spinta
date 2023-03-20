#include <transform.cuh>
#include <for_each.cuh>
#include <cuda.h>
#include <thrust/device_vector.h>

template <typename T>
class mark
{
    public:
    __host__ __device__ T operator()(T x){return x*x;}
};

template <typename T>
struct pres{
    public:
    __device__ void operator()(T x){printf("%d\n", x);}
};

int main(){
    std::vector<int> hh{10, 11, 12};

    thrust::device_vector<int> test{hh.begin(), hh.end()};
    mark<int> s;

    thrust::device_vector<int> res = spinta::parallel::transform(test.begin(), test.end(), s);
    spinta::parallel::for_each(res.begin(), res.end(), pres<int>());

    cudaDeviceSynchronize();
}