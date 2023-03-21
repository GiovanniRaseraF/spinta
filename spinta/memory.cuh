#pragma once

#include <cuda_runtime_api.h>

namespace spinta{
namespace sequential{
    
}; // sequential

namespace parallel{
    // template <typename T>
    // T * malloc(unsigned int size){
    //     T *ptr = nullptr;

    //     auto ret = cudaMalloc(
    //         (void **)&ptr, 
    //         size);

    //     return static_cast<T *> ptr;
    // }

    // template <typename T>
    // void free(T *ptr){
    //     cudaFree(ptr);
    // }
}; // parallel
}; // spinta