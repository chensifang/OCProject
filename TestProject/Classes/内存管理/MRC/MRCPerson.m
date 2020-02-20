//
//  MRCPerson.m
//  TestProject
//
//  Created by chensifang on 2018/7/10.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "MRCPerson.h"

@implementation MRCPerson
- (id)copyWithZone:(NSZone *)zone {
    return [[[MRCPerson alloc] init] autorelease];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [super dealloc];
}
+ (instancetype)newPerson{
    MRCPerson *person = [[MRCPerson alloc]init];
    return person;
    /*
     这个方法以new开头，那么不需要retain、release和autorelease了。
     */
}

+ (instancetype)somePerson{
    MRCPerson *person = [[MRCPerson alloc]init];
    
    return [person autorelease];
    /*
     这个方法以new、alloc等这些拥有“对象”的词语开头，在MRC中这里的代码相当于 return [person autorelease]。
     */
}

@end
