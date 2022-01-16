//
//  FishhookViewController.m
//  OCProject
//
//  Created by chen on 2019/11/13.
//  Copyright © 2019 fourye. All rights reserved.
//

#import "FishhookViewController.h"
#import <fishhook.h>
#import "Object1.h"
#import "NSObject+AOP.h"

@interface FishhookViewController ()

@end

@implementation FishhookViewController

+ (void)load {
//    rebind_symbols((struct rebinding[1]){{"NSLog", new_NSLog, (void *)&orig_NSLog}}, 1);
}

static void (*orig_NSLog)(NSString *format, ...);
void(new_NSLog)(NSString *format, ...) {
    va_list args;
    if(format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
//        [[logInWindowManager share] addPrintWithMessage:message needReturn:true];
        orig_NSLog(@"%@", message);
        va_end(args);
    }
}
// 初始化方法里进行替换
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"xxxx");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
