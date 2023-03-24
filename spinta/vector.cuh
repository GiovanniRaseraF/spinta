#pragma once

#include <iostream>
#include <vector>

namespace spinta{
namespace sequential{
    
}; // sequential

namespace parallel{
    template <typename T>
    class vector {
        T *device_ptr = nullptr;
        T *host_ptr = nullptr;
        std::size_t size;

        public:
        vector(std::size_t _s) : size{_s}{
            auto ret = cudaMalloc(
                (void **)&device_ptr,
                size*sizeof(T)
            );

            std::cout << "spinta vector allocated" << std::endl;
        }

        ~vector(){
            auto ret = cudaFree(device_ptr);

            std::cout << "spinta vector distructor" << std::endl;
        }

        T* gpu_ptr(){
            return this->device_ptr;
        }

        std::vector<T> std_vector(){
            std::cout << "TODO: implement std_vector" << std::endl;
        }

    };
}; // parallel
}; // spinta