//
//  RootViewController.m
//  OCProject
//
//  Created by chen on 7/3/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "LayoutViewController.h"
#import "RView.h"
#import "UIColor+Extension.h"
#import "RView1.h"
#import "ImageViewTest.h"
@interface LayoutViewController ()

@end

@implementation LayoutViewController

/* xib 加载 view 不会调用 init 方法 */
- (instancetype)init {
    self = [super init];
    NSLog(@"%s", __func__);
    return self;
}

/* xib 中加载 view 会调用：
 -[RootViewController initWithCoder:]
 -[RootViewController awakeFromNib]
 
 UIViewController 默认是遵守了 NSCoding 协议，否则也不会有下面这个方法。
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __func__);
    return [super initWithCoder:aDecoder];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"%s", __func__);
}

- (void)loadView {
    NSLog(@"%s", __func__);
    [super loadView];
}
static RView *rv;
- (void)testRview {
    BOOL temp = YES;
    if (temp) {
        /* init 会调用 initWithFrame：， initWithFrame 内部不调用 init */
        rv = [RView.alloc initWithFrame:CGRectMake(20, 200, 100, 200);
        rv.backgroundColor = kRandomColor;
    } else {
        /* 跟 storyboard 一样调用 initWithCoder & awakeFromNib */
        rv = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(RView.class) owner:nil options:nil].firstObject;
    }
    /* 归档调用 encodeWithCoder， 接档调用 initWithCoder */
    [self.view addSubview:rv];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self testSetNeedsLayout];
//    [self testSetNeedsDisplay];
    
    
}

- (void)testDrawRect {
    RView1 *view = [[RView1 alloc] initWithFrame:CGRectMake(200, 300, 100, 100);
    view.backgroundColor = kRandomColor;
    [self.view addSubview:view];
}

- (void)testSetNeedsLayout {
    /*
     这个会调用 -[RView layoutSubviews] 但是不是同步的，会在下一次 runloop 才会调用
     类似于 tableView 的 reloadData 方法，也不是同步的，在调用之后再获取 contentSize 是不准确的。
     */
    rv.count = 0;
    [rv setNeedsLayout];
    NSLog(@"%d", rv.count);
    /* 加上下面这个方法可以保证同步 */
    [rv layoutIfNeeded];
    NSLog(@"%d", rv.count);
    
    /*
     应用 tableView 做到立即同步:
     UITableView *table = [UITableView alloc].init;
     [table reloadData];
     [table layoutIfNeeded];
     */
}

- (void)testSetNeedsDisplay {
    /* 这里没有提供同步的方法，只能延时执行，会调用 drawRect */
    [rv setNeedsDisplay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testDrawRect];
//    [self testRview];
    [ImageViewTest test];
    
    /* viewDidLoad 方法里下面的都是 null，这是不安全布局,而且如果用了xib，在这里再创建控件frame依赖xib的frame会出错，因为这里可能xib的frame还没有确定。
     */
    NSLog(@"%@", self.view.superview);
    NSLog(@"%@", self.view.window);
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
    [super viewWillAppear:animated];
}

- (void)updateViewConstraints {
    NSLog(@"%s", __func__);
    [super updateViewConstraints];
}

- (void)viewWillLayoutSubviews {
    NSLog(@"%s", __func__);
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    NSLog(@"%s", __func__);
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%s", __func__);
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%s", __func__);
    [super viewDidDisappear:animated];
}

@end
