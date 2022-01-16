//
//  GCDViewController.m
//  OCProject
//
//  Created by chen on 9/9/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "GCDViewController.h"

@interface Model2 : NSObject
@property (nonatomic, strong) id value;
@end
@implementation Model2
@end

@interface GCDViewController()


@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_CELL(@"同步主队列", syncMainThread);
    ADD_CELL(@"异步主队列", asyncMainThread);
    ADD_CELL(@"异步串行（一道题）", asyncSerialTest);
    ADD_CELL(@"Apply", applyTest);
    ADD_SECTION(@"barrier");
    ADD_CELL(@"barrier_sync", testSyncBarrier);
    ADD_CELL(@"barrier_async", testAsyncBarrier);
    ADD_SECTION(@"信号量");
    ADD_CELL(@"信号量测试", semaphoreTest);
    ADD_CELL(@"atomic", testAtomic);
    ADD_CELL(@"atomic2", test7);
}

#pragma mark - ---- semaphore
#pragma mark -- 基本测试
- (void)semaphoreTest {
    // https://www.cnblogs.com/yajunLi/p/6274282.html
    // semaphore 作用是控制并发数, num == 1 就只允许 1 线程执行,其实就是同步, ==2 表示只能允许 2 个线程并发, 其中一个线程执行完了,另一个线程才能进来
    NSInteger num = 2;
    // 可以让代码一次性并发执行 num 个。设置为 1 就同步了
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(num);
    dispatch_apply(100, dispatch_get_global_queue(0, 0), ^(size_t index) {
        // 这个函数的逻辑是： 如果 semaphore = 0, 不允许向下执行, 等待 semaphore 到 >0 才能执行, 一旦向下执行,  semaphore - 1, 表明使用了一个最大并发数
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"%zu : %@", index, [NSThread currentThread]);
        sleep(2);
        // 这个函数的逻辑是：让 semaphore + 1
        dispatch_semaphore_signal(semaphore);
    });
}

#pragma mark - ---- Apply
- (void)applyTest {
    // 1. 内部并发执行，执行完了才走 end，执行顺序不定
    dispatch_apply(100, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"%zu : %@", index, [NSThread currentThread]);
    });
    NSLog(@"end");
    
    // 2. 主队列 crash
    //    dispatch_apply(100, dispatch_get_main_queue(), ^(size_t index) {
    //        NSLog(@"%zu : %@", index, [NSThread currentThread]);
    //    });
    //    NSLog(@"end");
    
    // 3. 自定义串行，顺序执行，执行完毕后走 end
    //    dispatch_apply(100, dispatch_queue_create("串行", DISPATCH_QUEUE_SERIAL), ^(size_t index) {
    //        NSLog(@"%zu : %@", index, [NSThread currentThread]);
    //    });
    //    NSLog(@"end");
    //
    //    // 4. 自定义并发队列，并发执行，执行完毕后走 end
    //    __block int i = 0;
    //    dispatch_apply(100, dispatch_queue_create("并发", DISPATCH_QUEUE_CONCURRENT), ^(size_t index) {
    //        NSLog(@"%zu : %@", index, [NSThread currentThread]);
    //        if (index != i++) {
    //            NSLog(@"");
    //        }
    //    });
    //    NSLog(@"end");
}

#pragma mark - ---- 异步串行（一道题）
// 1，3 一定先于2执行
- (void)asyncSerialTest {
    NSLog(@"begin");
    dispatch_queue_t queue = dispatch_queue_create("串行", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"test1");
        dispatch_async(queue, ^{
            NSLog(@"test2");
        });
        sleep(1);
        NSLog(@"test3");
    });
    NSLog(@"test4");
}


#pragma mark - ---- barrier
/*
 只对自己创建的并发队列有用，对于系统的 global 并发队列 & 系统的串行队列 & 自己创建的串行队列作用和 dispatch_(a)sync 一样
 */
#pragma mark -- sync
- (void)testSyncBarrier {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"test1");
    });
    dispatch_async(queue, ^{
        NSLog(@"test2");
    });
    dispatch_async(queue, ^{
        NSLog(@"test3");
    });
    
    dispatch_barrier_sync(queue, ^{
        NSLog(@"barrier1");
        sleep(1);
        NSLog(@"barrier2");
    });
    
    NSLog(@"aaa");
    dispatch_async(queue, ^{
        NSLog(@"test4");
    });
    NSLog(@"bbb");
    dispatch_async(queue, ^{
        NSLog(@"test5");
    });
}

#pragma mark -- async
- (void)testAsyncBarrier {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"test1");
    });
    dispatch_async(queue, ^{
        NSLog(@"test2");
    });
    dispatch_async(queue, ^{
        NSLog(@"test3");
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier1");
        sleep(1);
        NSLog(@"barrier2");
    });
    
    NSLog(@"aaa");
    dispatch_async(queue, ^{
        NSLog(@"test4");
    });
    NSLog(@"bbb");
    dispatch_async(queue, ^{
        NSLog(@"test5");
    });
}


#pragma mark - ---- GCD
- (void)syncMainThread {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1. %@", [NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            /**
             这里是 sync，按道理应该在 1 中的线程执行，但是主队列特殊，会在主线程执行，但是也不算新开线程，因为主线程本来就在
             */
            NSLog(@"2. %@", [NSThread currentThread]);
        });
        NSLog(@"3. %@", [NSThread currentThread]);
    });
}

- (void)asyncMainThread {
    /*
     2比3执行得晚，说明此处是异步，也说明了 sd 里写的 safeMain 宏是有道理的。
     */
    NSLog(@"1 执行");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"2执行 %@", [NSThread currentThread]);
    });
    NSLog(@"3执行");
}



- (void)testAtomic {
    self.slice = 0;
    NSLock *lock = [NSLock new];
    dispatch_queue_t queue = dispatch_queue_create("TestQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
//        [lock lock];
        for (int i=0; i<10000; i++) {
            self.slice = self.slice + 1;
            NSLog(@"%d", self.slice);
        }
//        [lock unlock];
    });
    dispatch_async(queue, ^{
//        [lock lock];
        for (int i=0; i<10000; i++) {
            self.slice = self.slice + 1;
            NSLog(@"%d", self.slice);
        }
//        [lock unlock];
    });
}

- (void)test7 {
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    Model2 *m = [Model2 new];
    SFLog(@"%@", @[@123,@123,@123,@123].class);
    for (int i = 0; i < 100000; i++) {
        dispatch_async(queue, ^{
            m.value = @[@123,@123,@123,@123];
            m.value = @[@123,@123,@123,@123];
        });
    }
}

- (void)test8 {
    Model2 *m = [Model2 new];
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);

//    for (int i = 0; i < 100000; i++) {
//        dispatch_async(queue, ^{
//            NSLog(@"%@", m.value);
//        });
//    }
    
    for (int i = 0; i < 100000; i++) {
        m.value = @[@123,@123,@123,@123];
    }
    
    
    
}


@end
