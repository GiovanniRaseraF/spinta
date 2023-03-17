#pragma once
#include <algorithm>
#include <iostream>

namespace spinta{
namespace sequential{
    /*for each sequential*/
    template <typename InputIterator, typename UnaryFunction>
    void for_each(
        InputIterator first, InputIterator last, 
        UnaryFunction unifunc)
    {
        std::for_each(first, last, unifunc);
    }
}; // sequential

namespace parallel{
    /*for each kernel executed by device*/
    template <typename InputIterator, typename UnaryFunction>
    __global__
    void for_each_kernel(
        InputIterator first, InputIterator last,
        UnaryFunction unifunc)
    {
        const int grid_size = blockDim.x * gridDim.x;

        first += blockIdx.x * blockDim.x + threadIdx.x;

        while (first < last)
        {
            unifunc(*first);
            first += grid_size;
        }
    }

    /*for each called by host*/
    template <typename InputIterator, typename UnaryFunction>
    void for_each(
        InputIterator first, InputIterator last, 
        UnaryFunction unifunc)
    {
        if (first >= last)
            return;

        const std::size_t BLOCK_SIZE = 256;
        const size_t MAX_BLOCKS = 1024;
        const size_t NUM_BLOCKS = std::min(MAX_BLOCKS, ((last - first) + (BLOCK_SIZE - 1)) / BLOCK_SIZE);

        for_each_kernel<<<NUM_BLOCKS, BLOCK_SIZE>>>(first, last, unifunc);
    }
}; // parallel
}; // spinta