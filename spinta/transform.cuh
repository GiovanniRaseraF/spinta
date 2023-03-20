#pragma once
#include <iostream>
#include <thrust/device_ptr.h>
#include <thrust/device_malloc.h>
#include <thrust/device_allocator.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>

namespace spinta{
namespace sequential{

};

namespace parallel{
    template<class InputIt, typename T, class UnaryOperation>
    __global__
    void transform_kernel( InputIt first, InputIt last, int n, T* results, UnaryOperation unary_op)
    {
        const int grid_size = blockDim.x * gridDim.x;
        first += blockIdx.x * blockDim.x + threadIdx.x;
        int i = blockIdx.x * blockDim.x + threadIdx.x;

        while (first < last)
        {
            results[i] = unary_op(*first);
            first += grid_size;
            i += grid_size;
        }
    }

    template<class InputIt, class UnaryOperation>
    thrust::device_vector<typename InputIt::value_type> 
        transform(InputIt first, InputIt last, UnaryOperation unary_op)
    {
        if (first >= last)
            return thrust::device_vector<typename InputIt::value_type>();

        const std::size_t BLOCK_SIZE = 256;
        const size_t MAX_BLOCKS = 1024;

        int n = std::distance(first, last);

        unsigned int GRID_SIZE;
        if (n < BLOCK_SIZE)
            GRID_SIZE = 1;
        else
            GRID_SIZE = std::min((n / BLOCK_SIZE), MAX_BLOCKS);

        // device allocator to store results
        thrust::device_ptr<typename InputIt::value_type> dev_res = 
            thrust::device_malloc<typename InputIt::value_type>
                (n * sizeof(typename InputIt::value_type));

        transform_kernel<InputIt, typename InputIt::value_type, UnaryOperation>
            <<<GRID_SIZE, BLOCK_SIZE>>>(first, last, n, dev_res.get(), unary_op);

        // inefficient
        thrust::device_vector<typename InputIt::value_type> h_vet(dev_res, dev_res + n);

        return h_vet;
    }
};
};