//
//  BaseCell.h
//  TestProject
//
//  Created by chen on 7/6/18.
//  Copyright © 2018 fourye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseCell : UICollectionViewCell
@property (nonatomic, assign) BOOL hiddenLine;
@property (nonatomic, assign) BOOL longBottomLine;
- (void)updateWithModel:(BaseCellModel *)model center:(BOOL)center;
@end

NS_ASSUME_NONNULL_END
