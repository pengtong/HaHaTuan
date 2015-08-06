//
//  HTHomeTopItem.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTHomeTopItem.h"

@interface HTHomeTopItem ()

@property (weak, nonatomic) IBOutlet UIButton *itemButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;


@end

@implementation HTHomeTopItem


+ (instancetype)item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HTHomeTopItem" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.itemButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}
- (void)setSubtitle:(NSString *)subTitle
{
    self.subTitleLabel.text = subTitle;
}
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon
{
    [self.itemButton setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [self.itemButton setImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
}
@end
