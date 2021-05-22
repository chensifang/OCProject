//
//  AlgorithmViewController.m
//  OCProject
//
//  Created by chensifang on 2018/6/28.
//  Copyright © 2018 fourye. All rights reserved.
//

#import "AlgorithmViewController.h"

@interface AlgorithmViewController ()
@end

const uint length = 999;
@implementation AlgorithmViewController

static int arr[length];

- (void)reset {
    [self setup:arr];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

void checkSort() {
    for (int i = 0; i < length - 1; i++) {
        if (arr[i] > arr[i + 1]) {
            NSLog(@"无序");
            return;
        }
    }
    NSLog(@"有序");
}

void print() {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<length; i++) {
        [array addObject:@(arr[i])];
    }
    NSLog(@"%@", array);
}

- (void)setup:(int [])arr {
    for (int i = 0; i < length; i++) {
        arr[i] = arc4random()%(length*10);
    }
}

void swap(int *a,int *b) {
    if (a == b) {
        return;
    }
    *a = *a + *b;
    *b = *a - *b;
    *a = *a - *b;
}

/*
 算法3大原则:
 1. 有穷性
 2. 确定性
 3. 可行性
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reset];
    [self addCellWithTitle:@"检测顺序" func:checkSort];
    ADD_CELL(@"二叉树", bianli);
    ADD_SECTION(@"排序");
    [self addCellWithTitle:@"冒泡" func:maopao_sort];
    [self addCellWithTitle:@"冒泡2" func:maopao_sort2];
    [self addCellWithTitle:@"快排" func:orgin_fast_sort];
    [self addCellWithTitle:@"快排2" func:fast_sort];
    [self addCellWithTitle:@"插入排" func:insert_sort];
    [self addCellWithTitle:@"" func:empty];
    [self addCellWithTitle:@"选择排" func:select_sort];
    [self addCellWithTitle:@"选择排2" func:select_sort2];
    [self addCellWithTitle:@"希尔排序" func:shell_sort];
    ADD_SECTION(@"查找");
    [self addCellWithTitle:@"二分查找(递归)" func:erfenFindRecursive];
    [self addCellWithTitle:@"二分查找(非递归)" func:erfenFindNoRecursive];
//    [self swap:(arr+9) other:(arr+10)];
}

#pragma mark - ---- 二叉树的遍历
- (void)bianli {
    [self logView:self.view];
}
- (void)logView:(UIView *)view {
    NSLog(@"%@",view);
    if (view.subviews.count > 0) {
        
        [self logView:[view.subviews objectAtIndex:0]];
    }
    if (view.subviews.count > 1) {
        [self logView:[view.subviews objectAtIndex:1]];
    }
}

#pragma mark - ---- 排序
#pragma mark -- 选择排序
void select_sort() {
    checkSort();
    for (int i = 0; i < length; i++) {
        for (int j = i + 1; j < length; j++) {
            if (arr[j] < arr[i]) {
                swap(arr + j, arr + i);
            }
        }
    }
    checkSort();
}

void select_sort2() {
    checkSort();
    for (int i = 0; i < length; i++) {
        int index = -1;
        int min = arr[i];
        for (int j = i + 1; j < length; j++) {
            if (arr[j] < min) {
                min = arr[j];
                index = j;
            }
        }
        if (index != -1) {
            swap(arr + i, arr + index);
        }
    }
    checkSort();
}

#pragma mark - ---- 插入排序
/**
 内层循环：j 之前的序列已经排好序了，从 j 开始向前找到 j 应该在的位置插入。
 */
void insert_sort() {
    checkSort();
    for (int i = 0; i < length; i ++) {
        for (int j = i; j > 0; j--) {
            if (arr[j] < arr[j - 1]) {
                swap(arr + j, arr + j- 1);
            } else {
                break;
            }
        }
    }
    checkSort();
}

#pragma mark - ---- 冒泡
/**
 内层循环,每次把最大值放到最后面.
 时间复杂度： 平均：O(n²) 最坏：O(n²) 最好：O(n)
 空间复杂度：O(1)
 */
void maopao_sort() {
    checkSort();
    int c = 0;
    
    for (int i = 0; i < length - 1; i++) {
        
        BOOL need = NO;
        for (int j = 0; j < length - 1 - i; j++) { // 内层循环,每次把最大值放到最后面.
            if (*(arr+j) > *(arr+j+1)) {
                swap(arr+j, arr+j+1);
                need = YES;
            }
            c++;
        }
        /**
         时间复杂度 O(n^2);
         need 的作用就是在走了一次冒泡之后发现没有需要交换的其实就说明已经有序了,不用继续走了.
         如果一个数组中只需要交换一次,这样可以大量减少循环次数:[1,2,3,4,6,5,7],交换了6和5之后,下一次循环 need=NO,可以 break 了.
         所以当一个有序数组进行冒泡排序时,其实时间复杂度就是O(n),所以最佳时间复杂度为O(n);
         */
        if (need == NO) {
            break;
        }
    }
    NSLog(@"循环次数: %d", c);
    checkSort();
}

// 感觉这种好理解一点
void maopao_sort2() {
    checkSort();
    int c = 0;
    
    for (int i = length - 1; i >= 0; i--) {
        
        BOOL need = NO;
        for (int j = 0; j < i; j++) { // 内层循环,每次把最大值放到最后面.
            if (*(arr+j) > *(arr+j+1)) {
                swap(arr+j, arr+j+1);
                need = YES;
            }
            c++;
        }
        /**
         时间复杂度 O(n^2);
         need 的作用就是在走了一次冒泡之后发现没有需要交换的其实就说明已经有序了,不用继续走了.
         如果一个数组中只需要交换一次,这样可以大量减少循环次数:[1,2,3,4,6,5,7],交换了6和5之后,下一次循环 need=NO,可以 break 了.
         所以当一个有序数组进行冒泡排序时,其实时间复杂度就是O(n),所以最佳时间复杂度为O(n);
         */
        if (need == NO) {
            break;
        }
    }
    NSLog(@"循环次数: %d", c);
    checkSort();
}

#pragma mark - ---- 二分查找
// 递归
void erfenFindRecursive() {
    maopao_sort();
    print();
    int target = *(arr+14);
    int index = erfenFindWithTarget(target, 0, length - 1);
    NSLog(@"find index:%d", index);
}


#pragma mark -- 递归
int erfenFindWithTarget(int target, int start, int end) {
    int middle = (start + end) / 2;
    int mValue = arr[middle];
    if (start == end && mValue != target) {
        return -1;
    }
    
    NSLog(@"start: %d, end: %d", start, end);
    if (mValue == target) {
        return middle;
    } else if (mValue > target) {
        // 从左边找, -1/+1 不要忘了,否则可能出现 start=97 end=98, =>middle=97 (start == end && mValue != target)这个条件永远不进去,永远不能 return.
        return erfenFindWithTarget(target, start, middle - 1);
    } else {
        // 从右边找
        return erfenFindWithTarget(target, middle + 1, end);
    }
}

// 非递归
/* 时间复杂度: O(log2n) */
void erfenFindNoRecursive() {
    maopao_sort();
    print();
    int target = *(arr+41);
    int index = erfenFind2WithTarget(target);
    NSLog(@"find index:%d", index);
}

#pragma mark -- 非递归
int erfenFind2WithTarget(int target) {
    int start = 0;
    int end = length-1;
    int middle = (start + end) / 2;
    int mValue = arr[middle];
    BOOL ok = YES;
    while (mValue != target) {
        middle = (start + end) / 2;
        mValue = arr[middle];
        NSLog(@"start: %d, end: %d", start, end);
        if (start == end && mValue != target) {
            ok = NO;
            break;
        }
        if (mValue > target) {
            end = middle - 1;
        } else {
            start = middle + 1;
        }
    }
    if (ok == NO) {
        return -1;
    } else {
        return middle;
    }
}

#pragma mark - ---- 快速排序
#pragma mark -- 优化版
/**
 时间复杂度： 平均：O(n²) 最坏：O(n²) 最好：O(n)
 空间复杂度：O(1)
 */
void fast_sort() {
    fastSortStart(0, length - 1);
    checkSort();
}
// 未完待续...
void fastSortStart(int start, int end) {
    if (start >= end) {
        return;
    }
    int low = start;
    int high = end;
    int keyIndex = start;
    
    while (low < high) {
        while (arr[high] >= arr[keyIndex] && high > keyIndex) {
            high--;
        }
        if (arr[high] < arr[keyIndex]) {
            swap(&arr[high], &arr[keyIndex]);
            keyIndex = high;
        }
        while (arr[low] <= arr[keyIndex] && low < keyIndex) {
            low++;
        }
        
        if (arr[low] > arr[keyIndex]) {
            swap(&arr[low], &arr[keyIndex]);
            keyIndex = low;
        }
    }
    
    if (low == high) {
        fastSortStart(start, keyIndex - 1);
        fastSortStart(keyIndex + 1, end);
    } else {
        NSLog(@"不可能进来");
    }
}

#pragma mark-- 原版
void orgin_fast_sort() {
    checkSort();
    orginFastSortStart(0, length - 1);
    checkSort();
}

void orginFastSortStart(int _low, int _high) {
    if (_low >= _high) {
        return;
    }
    int low = _low;
    int high = _high;
    int keyValue = arr[_low];
    while (low < high) {
        while (arr[high] >= keyValue && high > low) {
            high--;
        }
        
        while (keyValue >= arr[low] && high > low) {
            low++;
        }
        
        if (high > low) {
            // 到这一步找到了左边比 key 位置大的数 arr[low]
            swap(&arr[low], &arr[high]);
        } else {
            // 重叠了
            swap(&arr[_low], &arr[high]);
        }
    }
    orginFastSortStart(_low, low - 1);
    orginFastSortStart(low + 1, _high);
}

#pragma mark -- 希尔排序
void shell_sort() {
    
}



@end
