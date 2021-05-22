//
//  Singleton.h
//  Keep
//
//  Created by chen on 5/26/19.
//  Copyright © 2019 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#define singleton_h(name) +(instancetype)shared;

#define kInstanceName _instance##name

#if __has_feature(objc_arc) // ARC

#define singleton_m(name)                               \
    static id kInstanceName;                            \
                                                        \
    +(instancetype)shared {                             \
        static dispatch_once_t onceToken;               \
        dispatch_once(&onceToken, ^{                    \
            kInstanceName = [[self alloc] init];        \
        });                                             \
        return kInstanceName;                           \
    }                                                   \

#else // 非ARC

#define singleton_m(name)                           \
    static id kInstanceName;                        \
    +(id)allocWithZone : (struct _NSZone *)zone {   \
        static dispatch_once_t onceToken;           \
        dispatch_once(&onceToken, ^{                \
            _instance = [super allocWithZone:zone]; \
        });                                         \
        return kInstanceName;                       \
    }                                               \
                                                    \
    +(instancetype)shared##name {                   \
        static dispatch_once_t onceToken;           \
        dispatch_once(&onceToken, ^{                \
            _instance = [[self alloc] init];        \
        });                                         \
        return kInstanceName;                       \
    }                                               \
                                                    \
    -(oneway void)release {}                        \
                                                    \
        - (id)autorelease {                         \
        return kInstanceName;                       \
    }                                               \
                                                    \
    -(id)retain {                                   \
        return kInstanceName;                       \
    }                                               \
                                                    \
    -(NSUInteger)retainCount {                      \
        return 1;                                   \
    }                                               \
                                                    \
    +(id)copyWithZone : (struct _NSZone *)zone {    \
        return kInstanceName;                       \
    }

#endif
