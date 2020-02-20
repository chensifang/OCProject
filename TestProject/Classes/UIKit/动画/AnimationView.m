//
//  AnimationView.m
//  TestProject
//
//  Created by chen on 8/9/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView

#pragma mark - ---- 动画相关
/** 这个方法会多次调用，遍历可动画属性是否有动画 */
/** 可动画键值：
_uikit_viewPointer - <null> .
bounds - <null> .
opaque - <null> .
position - <null> .
backgroundColor - <null> .
opaque - <null> .
onOrderIn - <null> .
position - <_UIViewAdditiveAnimationAction: 0x60000376c9a0> .
*/
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    
    id obj = [super actionForLayer:layer forKey:event];
    /**
     1. layer 有 view，这个方法返回 NSNull 对象，没有动画。
     2. layer 没有 view，self.delegate = nil，会走 layer 自己的隐式动画。
     3. 这个方法返回一个 id<CAAction> ， 系统根据这个 id 生成一个 CABasicAnimation 调用 addAnimation 方法加到 layer 上。
     */
    NSLog(@"return：key：%@ - %@ ", event, obj);
    return obj;
}

@end
