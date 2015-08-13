//
//  HTHomeDealCell.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/5.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTDeal, HTHomeDealCell;

@protocol HTHomeDealCellDelegate <NSObject>

@optional
- (void)dealCellCheckingStateDidChange:(HTHomeDealCell *)dealCell;

@end

@interface HTHomeDealCell : UICollectionViewCell

@property (nonatomic, strong) HTDeal *deal;

@property (nonatomic, weak) id<HTHomeDealCellDelegate> delegate;

+ (CGSize)cellSize;

@end
