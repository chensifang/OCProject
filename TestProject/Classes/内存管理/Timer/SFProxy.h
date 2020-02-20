//
//  SFProxy.h
//  TestProject
//
//  Created by chen on 6/24/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFProxy : NSProxy
@property (nonatomic, weak) id target;
@end

NS_ASSUME_NONNULL_END
