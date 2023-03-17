#pragma once

// funny to use thrust to build an alternative to thrust !!!!
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/device_ptr.h>
#include <thrust/device_malloc.h>
#include <thrust/memory.h>
// !!!!

#include <numeric>
#include <iostream>

namespace spinta{
namespace sequential{
    /*reduce sequential*/
    template< class InputIt, class T, class BinaryOp >
    T reduce( InputIt first, InputIt last, T init, BinaryOp binary_op )
    {
        return std::reduce(first, last, init, binary_op);
    }
}; // sequential

namespace parallel{
    template< class InputIt, class T, class BinaryOp>
    __global__
    void reduce_kernel( InputIt first, InputIt last, int n, T *results, BinaryOp binary_op)
    {
        __shared__ T sdata_workaround[
            256 * sizeof(T)
        ];

        const unsigned int grid_size = blockDim.x * gridDim.x;
        unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;

        T accum = *(first + i);
        i+= grid_size;

        while(i < n){
            accum = binary_op(accum, *(first + i));
            i+=grid_size;
        }

        sdata_workaround[threadIdx.x] = accum;

        __syncthreads();

        if(threadIdx.x == 0)
            results[blockIdx.x] = sdata_workaround[threadIdx.x];
    }

    template< class InputIt, class T, class BinaryOp >
    T reduce( InputIt first, InputIt last, T init, BinaryOp binary_op )
    {
        if(first >= last) return init;

        const int n = std::distance(first, last);

        const std::size_t BLOCK_SIZE    = 256; // BLOCK_SIZE must be a power of 2
        const std::size_t MAX_BLOCKS    = 256;

        unsigned int GRID_SIZE;
        if (n < BLOCK_SIZE)
            GRID_SIZE = 1;
        else
            GRID_SIZE = std::min((n / BLOCK_SIZE), MAX_BLOCKS);

        thrust::device_ptr<T> block_results = thrust::device_malloc<T>(GRID_SIZE);

        // call kernel
        reduce_kernel<InputIt, T, BinaryOp><<<GRID_SIZE, BLOCK_SIZE>>>(first, last, n, block_results.get(), binary_op);

        // attention using WRONG parameters, NEED to use block_results 
        thrust::host_vector<T> host_results(block_results, block_results+GRID_SIZE);

        return sequential::reduce(first, last, init, binary_op);
    }
}; // parallel
}; // spinta
