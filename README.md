# CPython-Tutorial-zh


[中文CPython教程](https://github.com/Sean16SYSU/CPython-Tutorial-zh)


## 简述
Python有时候太慢，如果手动编译C或者是C++来写`#include<Python.h>`的文件也比较麻烦。
CPython无疑是一个比较好的选择。

> 这篇教程是基于
> * https://cython.readthedocs.io/en/latest/src/tutorial/cython_tutorial.html
> 同时也参考了 http://docs.cython.org/en/latest/
> * 但我会在这个的基础上做一些补充。
> 同样，这个项目，我会持续更新到github上
> * https://github.com/Sean16SYSU/CPython-Tutorial-zh

### 改进的理由

> 来源于link1的

1. 每一行的计算量很少，因此python解释器的开销就会变的很重要。
2. 数据的局部性原理：很可能是，当使用C的时候，更多的数据可以塞进CPU的cache中，因为Python的元素都是Object，而每个Object都是通过字典实现的，cache对这个数据不很友好。

## 项目

### Hello World项目

第一个项目是Hello world。

创建一个文件`helloworld.pyx`，内容如下：

```py
print("Hello world!")
```

保存后，创建`setup.py`文件，内容如下：

```py
from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("helloworld.pyx")
)
```

保存后，命令行进入`setup.py`所在目录，并输入`python setup.py build_ext --inplace`，如下：

```py
PS D:\Code\CPython\Test> python setup.py build_ext --inplace
Compiling helloworld.pyx because it changed.
[1/1] Cythonizing helloworld.pyx
running build_ext
building 'helloworld' extension
creating build
creating build\temp.win-amd64-3.6
creating build\temp.win-amd64-3.6\Release
C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.13.26128\bin\HostX86\x64\cl.exe /c /nologo /Ox /W3 /GL /DNDEBUG /MD -IC:\Users\lijy2\AppData\Local\Programs\Python\Python36\include -IC:\Users\lijy2\AppData\Local\Programs\Python\Python36\include "-IC:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.13.26128\ATLMFC\include" "-IC:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.13.26128\include" "-IC:\Program Files (x86)\Windows Kits\NETFXSDK\4.6.1\include\um" "-IC:\Program Files (x86)\Windows Kits\10\include\10.0.16299.0\ucrt" "-IC:\Program Files (x86)\Windows Kits\10\include\10.0.16299.0\shared" "-IC:\Program Files (x86)\Windows Kits\10\include\10.0.16299.0\um" "-IC:\Program Files (x86)\Windows Kits\10\include\10.0.16299.0\winrt" "-IC:\Program Files (x86)\Windows Kits\10\include\10.0.16299.0\cppwinrt" /Tchelloworld.c /Fobuild\temp.win-amd64-3.6\Release\helloworld.obj
helloworld.c
C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.13.26128\bin\HostX86\x64\link.exe /nologo
/INCREMENTAL:NO /LTCG /DLL /MANIFEST:EMBED,ID=2 /MANIFESTUAC:NO /LIBPATH:C:\Users\lijy2\AppData\Local\Programs\Python\Python36\libs /LIBPATH:C:\Users\lijy2\AppData\Local\Programs\Python\Python36\PCbuild\amd64 "/LIBPATH:C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.13.26128\ATLMFC\lib\x64" "/LIBPATH:C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.13.26128\lib\x64" "/LIBPATH:C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6.1\lib\um\x64" "/LIBPATH:C:\Program Files (x86)\Windows Kits\10\lib\10.0.16299.0\ucrt\x64" "/LIBPATH:C:\Program Files (x86)\Windows Kits\10\lib\10.0.16299.0\um\x64" /EXPORT:PyInit_helloworld build\temp.win-amd64-3.6\Release\helloworld.obj /OUT:D:\Code\CPython\Test\helloworld.cp36-win_amd64.pyd /IMPLIB:build\temp.win-amd64-3.6\Release\helloworld.cp36-win_amd64.lib
  正在创建库 build\temp.win-amd64-3.6\Release\helloworld.cp36-win_amd64.lib 和对象 build\temp.win-amd64-3.6\Release\helloworld.cp36-win_amd64.exp
正在生成代码
已完成代码的生成
```

在该目录下的命令行进入Python操作界面，导入包之后，就会自动输出`Hello world!`，如下：

```py
PS D:\Code\CPython\Test> python
Python 3.6.6 (v3.6.6:4cf1f54eb7, Jun 27 2018, 03:37:03) [MSC v.1900 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license" for more information.
>>> import helloworld
Hello world!
```

这就完成了一个简单的CPython的扩展书写。下面再举例子。


### Fibonacci Function项目

斐波那契数列：1, 1, 2, 3, 5,...
前两位为1，之后每个数等于前面两个数之和。

创建`fib.pyx`，内容如下：
```py
from __future__ import print_function

def fib(n):
    a, b = 0, 1
    while b < n:
        print(b, end=' ')
        a, b = b, a + b
    print()
```

创建`setup.py`文件，内容如下：
```py
from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("fib.pyx")
)
```

通过命令`python setup.py build_ext --inplace`，生成出来的文件：

```Py
import fib
fib.fib(100)
```
输出：
```py
1 1 2 3 5 8 13 21 34 55 89
```

* 但是经过测试之后，发现速度并没有很高的提升，很可能是操作本来就很简单，数值也很小，没什么优化的空间了。


### Primes项目

给一个数值n，输出前n个质数（list）。

写到`primes.pyx`中：

```py
def primes(int nb_primes):
    cdef int n, i, len_p
    cdef int p[1000]
    if nb_primes > 1000:
        nb_primes = 1000
    
    len_p = 0
    n = 2
    while len_p < nb_primes:
        for i in p[:len_p]:
            if n % i == 0:
                break
        else:
            p[len_p] = n
            len_p += 1
        n += 1
    result_as_list = [prime for prime in p[:len_p]]
    return result_as_list
```

同理，`setup.py`文件内容为：

```py
from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("primes.pyx")
)
```

在参考的link中给出了测试的案例，有些解释的不太好，我这边描述一下

* 直接使用Python实现版本，平均用时23ms
* Python版本用CPython编译(对，直接把Python文件名字像pyx一样放进去就好了)， 平均用时11ms
* pyx的CPython编译版本，平均用时1.6ms

### Stat项目

注意，这里不能直接使用stat，因为似乎是有这个库了emmmm

`stat_.pyx`:

```py
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
```

`setup.py`:

```py
from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("stat_.pyx")
)
```

命令还是一样的：`python setup.py build_ext --inplace`

测试：
```py
>>> import stat_
>>> a = [1,2,3]
>>> stat_.mean(a)
2.0
>>> stat_.std(a)
1.4142135623730951
```