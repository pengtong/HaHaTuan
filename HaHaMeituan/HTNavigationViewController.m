//
//  HTNavigationViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTNavigationViewController.h"

@interface HTNavigationViewController ()

@end

@implementation HTNavigationViewController

+ (void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setBackgroundImage:[UIImage imageWithName:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *buttonItem = [UIBarButtonItem appearance];
    
    [buttonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : HTColor(21, 188, 173)} forState:UIControlStateNormal];
    [buttonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateDisabled];
}

@end
