from libc.math cimport sqrt

def mean(list arr):
    cdef:
        int i
        int sz
        double tmp
    tmp = 0
    sz = len(arr)
    for i in range(sz):
        tmp += arr[i]
    return tmp / sz

def std(list arr):
    cdef:
        double m = mean(arr)
        int sz, i
        double tmp
    sz = len(arr)
    tmp = 0
    for i in range(sz):
        tmp += (arr[i] - m) ** 2
    return sqrt(tmp)