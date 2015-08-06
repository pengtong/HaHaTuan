//
//  HTSortViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/3.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTSortViewController.h"
#import "HTMetaData.h"
#import "HTSort.h"

@interface HTSortButton:UIButton

@property (nonatomic, strong) HTSort *sort;

@end

@implementation HTSortButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageWithName:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithName:@"btn_filter_selected"] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{}

- (void)setSort:(HTSort *)sort
{
    _sort = sort;
    
    [self setTitle:sort.label forState:UIControlStateNormal];
}

@end

@interface HTSortViewController ()
@property (nonatomic, weak) HTSortButton *selectButton;
@end

@implementation HTSortViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *sorts = [HTMetaData sorts];
    NSInteger count = sorts.count;
    
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat heigth = 0;
    for (NSInteger i=0; i<count; i++)
    {
        HTSort *sort = [HTMetaData sorts][i];
        HTSortButton *btn = [[HTSortButton alloc] init];
        btn.sort = sort;
        btn.x = 15;
        btn.y = btnStartY + i * (btnMargin + btnH);
        btn.width = btnW;
        btn.height = btnH;
        heigth = CGRectGetMaxY(btn.frame);
        [btn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btn];
        
//        if (i == 0)
//        {
//            [self sortBtnClick:btn];
//        }
    }
    heigth += btnMargin;
    self.preferredContentSize = CGSizeMake(btnW + 2 * btnX, heigth);
}

- (void)sortBtnClick:(HTSortButton *)btn
{
    self.selectButton.selected = NO;
    btn.selected = YES;
    self.selectButton = btn;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HTSortDidChangeNotification object:nil userInfo:@{HTSelectSort : btn.sort}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
