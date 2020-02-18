//
//  main.m
//  Objective-C的本质
//
//  Created by 赵鹏 on 2019/4/21.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 1、平时在项目中写的OC代码在编译的时候都会转化为C\C++代码，然后再转化为更为低级的汇编语言，最后再转化为0，1的机器语言；
 2、OC的对象、类主要是基于C\C++的结构体来实现的，因为只有结构体才能够容纳不同的类型，所以说OC的对象和类的本质就是一个结构体；
 3、在终端中利用命令行的方式把main.m文件编译成C++文件(main-arm64.cpp)之后再进行编译会报错，这是因为在main-arm64.cpp文件和main.m文件中都包含main函数。解决办法是在TARGETS中的Compile Sources中把main-arm64.cpp文件删掉就可以了。
 4、lldb的常用指令：
（1）print/p + 指针名称（犹如下面的obj）：打印指针里面存储的地址值（指针指向的对象的内存地址值）；
（2）po + 指针名称：打印对象；
（3）memory read/x + 地址值：读取这个地址值开始的一段连续的内存。
 */
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

//从main-arm64.cpp文件中复制过来的，它表示NSObject类的底层实现。
struct NSObject_IMPL {
    Class isa;  //Class就是一个指针，在64位环境下占8个字节的内存空间，在32位环境下占4个字节的内存空间。
};

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        /**
         因为NSObject的底层就是一个结构体，所以alloc的作用就是给这个结构体分配一个存储空间，这个存储空间中就只有一个成员变量isa。然后把这个新分配的存储空间的地址值赋值给obj指针，所以obj指针就指向了这个只有一个成员变量isa的结构体对象了。
         */
        NSObject *obj = [[NSObject alloc] init];
        
        /**
         ·class_getInstanceSize函数是用来获取后面括号中的传进来的类的实例对象的大小；
         ·通过查看苹果的源码可以看出这个函数只能获取括号内的类的实例对象中的所有成员变量的大小，并不能真实地获取到系统分配给这个实例对象的内存空间的大小；
         ·NSObject对象内只有一个isa成员变量，在64位环境下，这个成员变量只占8个字节的内存空间，所以打印的结果是8。
         */
        NSLog(@"%zd", class_getInstanceSize([NSObject class]));
        
        /**
         ·malloc_size函数用来获取后面括号中的传进来的指针所指向的那块内存区域的大小；
         ·在64位环境下，系统分配了16个字节的内存空间给NSObject对象，但NSObject对象内部只使用了8个字节的内存空间，这8个字节的内存空间用来放置一开始撰写的NSObject_IMPL结构体，即用来放置这个结构体内部的成员变量Class isa的，剩余的8个字节的内存空间则闲置着，所以打印的结果是16；
         ·所以一个NSObject对象占用了16个字节的内存空间，但NSObject对象内部只使用了8个字节的内存空间。
         */
        NSLog(@"%zd", malloc_size((__bridge const void *)(obj)));
    }
    return 0;
}
