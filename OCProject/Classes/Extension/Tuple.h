//
//  Tuple.h
//  OCProject
//
//  Created by chen on 7/31/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tuple : NSObject
@property (nonatomic,strong) id first;
@property (nonatomic,strong) id second;
@property (nonatomic,strong) id third;
@property (nonatomic,strong) id fourth;
@property (nonatomic,strong) id fifth;
@property (nonatomic,strong) id last;

@property (nonatomic,strong) NSArray *args;
- (instancetype)initWithArgs:(NSArray *)args;
@end

NS_ASSUME_NONNULL_END
