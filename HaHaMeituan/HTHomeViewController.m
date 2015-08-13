//
//  HTHomeViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTHomeViewController.h"
#import "HTHomeTopItem.h"
#import "HTCategoryViewController.h"
#import "HTDistrictViewController.h"
#import "HTCity.h"
#import "HTSort.h"
#import "HTRegion.h"
#import "HTCategory.h"
#import "HTMetaData.h"
#import "HTSortViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"
#import "HTSearchViewController.h"
#import "AwesomeMenu.h"
#import "HTCollectViewController.h"
#import "HTScantionViewController.h"
#import "HTMapDealViewController.h"

typedef NS_ENUM(NSInteger, AwesomeCategory)
{
    AwesomeMenuMine = 0,
    AwesomeMenuCollect,
    AwesomeMenuScan,
    AwesomeMenuMore
};

@interface HTHomeViewController () <AwesomeMenuDelegate>

@property (nonatomic, weak) UIBarButtonItem *categoryItem;

@property (nonatomic, weak) UIBarButtonItem *districtItem;

@property (nonatomic, weak) UIBarButtonItem *sortItem;

@property (nonatomic, copy) NSString *selectCityName;

@property (nonatomic, copy) NSString *selectCategoryName;

@property (nonatomic, copy) NSString *selectRegionName;

@property (nonatomic, strong) HTSort *sort;


@end

@implementation HTHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNotification];
    [self setupLeftNav];
    [self setupRightNav];
    [self setupAwesomeMenu];
    
    [self.collectionView.header beginRefreshing];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCategory:) name:HTCategoryDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity:) name:HTCityDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRegion:) name:HTRegionDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSort:) name:HTSortDidChangeNotification object:nil];
}

- (void)setupLeftNav
{
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    HTHomeTopItem *categoryTopItem = [HTHomeTopItem item];
    [categoryTopItem setTitle:@"全部分类"];
    [categoryTopItem setSubtitle:@"全部"];
    [categoryTopItem setIcon:@"icon_category_-1" highIcon:@"icon_category_highlighted_-1"];
    [categoryTopItem addTarget:self action:@selector(categoryItemClick:)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
 
    HTHomeTopItem *districtTopItem = [HTHomeTopItem item];
    self.selectCityName = @"北京";
    [districtTopItem setTitle:[NSString stringWithFormat:@"%@ - 全部", self.selectCityName]];
    [districtTopItem setSubtitle:nil];
    [districtTopItem addTarget:self action:@selector(districtItemClick:)];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtTopItem];
    self.districtItem = districtItem;
    
    HTHomeTopItem *sortTopItem = [HTHomeTopItem item];
    [sortTopItem setTitle:@"排序"];
    [sortTopItem setSubtitle:@"默认排序"];
    [sortTopItem setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    [sortTopItem addTarget:self action:@selector(sortItemClick:)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortItem];
}

- (void)setupRightNav
{
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithIcon:@"icon_map" highIcon:@"icon_map_highlighted" target:self action:@selector(mapDeal)];
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithIcon:@"icon_search" highIcon:@"icon_search_highlighted" target:self action:@selector(search)];
    searchItem.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

- (void)setupAwesomeMenu
{
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageWithName:@"icon_pathMenu_background_normal"] highlightedImage:nil ContentImage:[UIImage imageWithName:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:nil];
   
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageWithName:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageWithName:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageWithName:@"icon_pathMenu_mine_highlighted"]];

    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageWithName:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageWithName:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageWithName:@"icon_pathMenu_collect_highlighted"]];

    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageWithName:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageWithName:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageWithName:@"icon_pathMenu_scan_highlighted"]];
    
    AwesomeMenuItem *item4 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageWithName:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageWithName:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageWithName:@"icon_pathMenu_more_highlighted"]];
    
    NSArray *menuItems = @[item1, item2, item3, item4];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:menuItems];
    [self.view addSubview:menu];
    menu.startPoint = CGPointMake(50, 150);
    menu.rotateAddButton = NO;
    menu.menuWholeAngle = M_PI_2;
    menu.delegate = self;
    menu.alpha = 0.5;
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [menu autoSetDimensionsToSize:CGSizeMake(200, 200)];
}

- (void)mapDeal
{
    HTMapDealViewController *mapDealVC = [[HTMapDealViewController alloc] init];
    HTNavigationViewController *nav = [[HTNavigationViewController alloc] initWithRootViewController:mapDealVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)search
{
    HTSearchViewController *searchVC = [[HTSearchViewController alloc] init];
    searchVC.cityName = self.selectCityName;
    HTNavigationViewController *nav = [[HTNavigationViewController alloc]initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)changeCategory:(NSNotification *)nofit
{
    HTCategory *category = nofit.userInfo[HTSelectCategory];
    NSString *subCategorys = nofit.userInfo[HTSelectSubCategories];
    
    if (subCategorys == nil || [subCategorys isEqualToString:@"全部"])
    {
        self.selectCategoryName = category.name;
    }
    else
    {
        self.selectCategoryName = subCategorys;
    }
    
    if ([self.selectCategoryName isEqualToString:@"全部分类"])
    {
        self.selectCategoryName = nil;
    }
    
    HTHomeTopItem *topItem = (HTHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubtitle:subCategorys?subCategorys:@"全部"];
    
    [self.collectionView.header beginRefreshing];
}

- (void)changeRegion:(NSNotification *)nofit
{
    HTRegion *region = nofit.userInfo[HTSelectRegion];
    NSString *subRegion = nofit.userInfo[HTSelectSubRegions];
    
    if (subRegion == nil || [subRegion isEqualToString:@"全部"])
    {
        self.selectRegionName = region.name;
    }
    else
    {
        self.selectRegionName = subRegion;
    }
    
    if ([self.selectRegionName isEqualToString:@"全部"])
    {
        self.selectRegionName = nil;
    }
    
    HTHomeTopItem *topItem = (HTHomeTopItem *)self.districtItem.customView;
    [topItem setTitle: [NSString stringWithFormat:@"%@ - %@", self.selectCityName, region.name]];
    [topItem setSubtitle:subRegion];
    
    [self.collectionView.header beginRefreshing];
}

- (void)changeCity:(NSNotification *)nofit
{
    HTHomeTopItem *topItem = (HTHomeTopItem *)self.districtItem.customView;
    self.selectCityName = [nofit.userInfo[HTSelectCityName] copy];

    if (self.selectRegionName)
    {
        self.selectRegionName = nil;
    }
    
    [topItem setTitle:[NSString stringWithFormat:@"%@ - 全部", self.selectCityName]];
    [topItem setSubtitle:@"全部"];
    
    [self.collectionView.header beginRefreshing];
}

- (void)changeSort:(NSNotification *)nofit
{
    HTHomeTopItem *topItem = (HTHomeTopItem *)self.sortItem.customView;
    self.sort = nofit.userInfo[HTSelectSort];
    [topItem setSubtitle:self.sort.label];
    
    [self.collectionView.header beginRefreshing];
}
- (void)categoryItemClick:(UIButton *)btn
{
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[[HTCategoryViewController alloc] init]];
    [popover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)districtItemClick:(UIButton *)btn
{
    HTDistrictViewController *districtVC = [[HTDistrictViewController alloc] init];
    
    if (self.selectCityName)
    {
        HTCity *city = [[[HTMetaData cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", self.selectCityName]] firstObject];
        districtVC.regions = city.regions;
    }
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:districtVC];
    [popover presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)sortItemClick:(UIButton *)btn
{
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[[HTSortViewController alloc] init]];
    
    [popover presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (void)setParams:(NSMutableDictionary *)params
{
    params[@"city"] = self.selectCityName;

    if (self.selectCategoryName)
    {
        params[@"category"] = self.selectCategoryName;
    }

    if (self.selectRegionName)
    {
        params[@"region"] = self.selectRegionName;
    }

    if (self.sort)
    {
        params[@"sort"] = @(self.sort.value);
    }
}

#pragma mark --AwesomeMenuDelegate

- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageWithName:@"icon_pathMenu_cross_normal"];
    [UIView animateWithDuration:0.2f animations:^{
        menu.alpha = 1.0;
    }];
    
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageWithName:@"icon_pathMenu_mainMine_normal"];
    [UIView animateWithDuration:0.2f animations:^{
        menu.alpha = 0.5;
    }];
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [UIView animateWithDuration:0.2f animations:^{
        menu.alpha = 0.5;
        menu.contentImage = [UIImage imageWithName:@"icon_pathMenu_mainMine_normal"];
    }];
    
    switch (idx)
    {
        case AwesomeMenuMine:
            break;
        case AwesomeMenuCollect:
            {
                HTCollectViewController *collect = [[HTCollectViewController alloc] init];
                HTNavigationViewController *nav = [[HTNavigationViewController alloc] initWithRootViewController:collect];
                [self presentViewController:nav animated:YES completion:nil];
            }
            break;
        case AwesomeMenuScan:
            {
                HTScantionViewController *scan = [[HTScantionViewController alloc] init];
                HTNavigationViewController *nav = [[HTNavigationViewController alloc] initWithRootViewController:scan];
                [self presentViewController:nav animated:YES completion:nil];
            }
            break;
        case AwesomeMenuMore:
            
            break;
        default:
            break;
    }
}
@end
