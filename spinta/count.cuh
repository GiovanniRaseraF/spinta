#pragma once
#include <algorithm>
#include <iostream>
#include <numeric>
#include <transform.cuh>
#include <reduce.cuh>

/*
count is a particular transform_reduce 
*/

namespace spinta{
namespace sequential{
    /*for each sequential*/
    template <typename InputIterator>
    int count(
        InputIterator first, InputIterator last, typename InputIterator::value_type value)
    {
        return std::count(first, last, value);
    }
}; // sequential

namespace parallel{

    template <typename T>
    struct trasform_1{
        public:
        __host__ __device__ trasform_1(const T _v) : value{_v}{}
        __device__ T operator()(T x){
            return x == value ? 1 : 0;
        }

        const T value;
    };

    template <typename T>
    class sums_1
    {
        public:
        __host__ __device__ T operator()(T a, T b){ return a + b;}
    };

    /*for each kernel executed by device*/
    template <typename InputIterator>
    int count(
        InputIterator first, InputIterator last, typename InputIterator::value_type value)
    {
        trasform_1<typename InputIterator::value_type> one(value);
        sums_1<typename InputIterator::value_type>s;

        auto tr = spinta::parallel::transform(first, last, one);
        int ccc = spinta::parallel::reduce(tr.begin(), tr.end(), 0, s);

        return ccc;
    }

}; // parallel
}; // spinta