//
//  RACViewController.m
//  TestProject
//
//  Created by chen on 2019/12/24.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "RACViewController.h"
#import <ReactiveObjC.h>

@interface RACViewController ()

@property (nonatomic, strong) RACSignal *signal;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) RACCommand *executeSearch;

@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    ADD_CELL(@"count++", addCount);
    ADD_CELL(@"testCommand", testCommand);
//    self.signal = [RACObserve(self, count) ]
}

- (void)setup {
    /**
     👇的代码使用 RACObserve 宏来从 ViewModel 的 searchText 属性创建一个信号。map 操作将文本转化为一个true或false值的流。最后，distinctUntilChanges 确保信号只有在状态改变时才发出值
     */
    self.signal = [[RACObserve(self, count) map:^id _Nullable(id  _Nullable value) {
        return @([value intValue] > 3);
    }] distinctUntilChanged];
    
    [self.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"self.signal subscribeNext");
    }];
}

- (RACSignal *)executeSearchSignal
{
    return [[[[RACSignal empty] logAll] delay:2.0] logAll];
}

- (void)testCommand {
    self.executeSearch = [[RACCommand alloc] initWithEnabled:self.signal
    signalBlock:^RACSignal *(id input) {
        return [self executeSearchSignal];
    }];
}

- (void)addCount {
    self.count++;
}


@end
