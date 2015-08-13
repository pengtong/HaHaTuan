//
//  HTHomeDealCell.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/5.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTHomeDealCell.h"
#import "HTDeal.h"
#import "UIImageView+WebCache.h"
#import "NString+Extend.h"

static CGFloat CellWH = 305;

@interface HTHomeDealCell ()
@property (weak, nonatomic) IBOutlet UIImageView *dealImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dealNewImage;

@property (weak, nonatomic) IBOutlet UIButton *cover;
- (IBAction)coverClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *checkView;
@end

@implementation HTHomeDealCell

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}

+ (CGSize)cellSize
{
    return CGSizeMake(CellWH, CellWH);
}

- (void)setDeal:(HTDeal *)deal
{
    _deal = deal;
    
    [self.dealImage sd_setImageWithURL:[NSURL URLWithString:deal.s_image_url] placeholderImage:[UIImage imageWithName:@"placeholder_deal"]];
    self.titleLabel.text = deal.title;
    self.descLabel.text = deal.desc;
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售 %d", deal.purchase_count];
    
    self.currentPriceLabel.text =[ NSString stringWithFormat:@"¥ %@", deal.current_price];
    self.currentPriceLabel.text = [NSString twoDecimalWithString:self.currentPriceLabel.text];
    
    self.listPriceLabel.text = [NSString stringWithFormat:@"¥ %@", deal.list_price];
    self.listPriceLabel.text = [NSString twoDecimalWithString:self.listPriceLabel.text];
    

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat= @"yyyy-MM-dd";
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    self.dealNewImage.hidden = ([deal.publish_date compare:nowStr] == NSOrderedAscending);
    
    self.cover.hidden = !self.deal.editing;
    self.checkView.hidden = !self.deal.checking;
    
}

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageWithName:@"bg_dealcell"] drawInRect:rect];
}

- (IBAction)coverClick:(UIButton *)sender
{
    self.deal.checking = !self.deal.isChecking;
    self.checkView.hidden = !self.checkView.isHidden;
    
    if ([self.delegate respondsToSelector:@selector(dealCellCheckingStateDidChange:)])
    {
        [self.delegate dealCellCheckingStateDidChange:self];
    }
}
@end
