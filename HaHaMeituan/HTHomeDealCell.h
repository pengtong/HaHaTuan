//
//  HTHomeDealCell.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/5.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTDeal;

@interface HTHomeDealCell : UICollectionViewCell

@property (nonatomic, strong) HTDeal *deal;

+ (CGSize)cellSize;

@end
