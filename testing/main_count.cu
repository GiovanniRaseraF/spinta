#include <count.cuh>
#include <for_each.cuh>

#include <vector>
#include <iostream>

template <typename T>
struct pres{
    public:
    __device__ void operator()(T x){printf("%d\n", x);}
};

int main(){
    // sequential
    std::vector<int> s(10000, 10);
    auto ret = spinta::sequential::count(s.begin(), s.end(), 10);
    std::cout << "count: "  << ret << std::endl;

    // parallel count
    thrust::device_vector<int> dvs{s.begin(), s.end()};
    auto dvres = spinta::parallel::count(dvs.begin(), dvs.end(), 10);

    std::cout << "count parallel: " << dvres << std::endl;
}