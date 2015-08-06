//
//  HTHomeTopItem.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTHomeTopItem : UIView

+ (instancetype)item;

- (void)addTarget:(id)target action:(SEL)action;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subTitle;
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;
@end
