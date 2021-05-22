//
//  Tuple.m
//  OCProject
//
//  Created by chen on 7/31/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "Tuple.h"

@implementation Tuple
- (instancetype)initWithArgs:(NSArray *)args {
    self = [super init];
    self.args = args;
    [args enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                self.first = obj;
                break;
            case 1:
                self.second = obj;
                break;
            case 2:
                self.third = obj;
                break;
            case 3:
                self.fourth = obj;
                break;
            case 4:
                self.fifth = obj;
                break;
            case 5:
                self.last = obj;
                break;
            default:
                break;
        }
    }];
    if (args.count > 0) {
        self.last = args[args.count - 1];
    }
    return self;
}
@end
