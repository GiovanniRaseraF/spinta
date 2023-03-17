#pragma once

namespace spinta{
namespace sequential{

};

namespace parallel{
    template<class InputIt, class UnaryOperation>
    __global__
    void transform_kernel(InputIt first, InputIt last, UnaryOperation unary_op)
    {
        const int grid_size = blockDim.x * gridDim.x;

        first += blockIdx.x * blockDim.x + threadIdx.x;

        while (first < last)
        {
            // NOT CORRECT
            *first = unary_op(*first);
            // DEVICE MEMORY
            first += grid_size;
        } 
    }

    template<class InputIt, class UnaryOperation>
    void transform(InputIt first, InputIt last, UnaryOperation unary_op)
    {
        if (first >= last)
            return;

        const std::size_t BLOCK_SIZE = 256;
        const size_t MAX_BLOCKS = 1024;
        const size_t NUM_BLOCKS = std::min(MAX_BLOCKS, ((last - first) + (BLOCK_SIZE - 1)) / BLOCK_SIZE);
        
        transform_kernel<<<NUM_BLOCKS, BLOCK_SIZE>>>(first, last, unary_op);
    }
};
};