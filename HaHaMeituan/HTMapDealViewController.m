//
//  HTMapDealViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/10.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTMapDealViewController.h"
#import <MapKit/MapKit.h>
#import "HTDeal.h"
#import "DPAPI.h"
#import "MJExtension.h"
#import "HTHomeTopItem.h"
#import "HTCategoryViewController.h"
#import "HTCategory.h"
#import "HTDealAnnotation.h"
#import "HTBusinesses.h"
#import "HTMetaData.h"
#import "HTDetailController.h"

@interface HTMapDealViewController ()<MKMapViewDelegate, DPRequestDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) DPRequest *lastRequest;
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
@property (nonatomic, copy) NSString *selectCategoryName;
@end

@implementation HTMapDealViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"附近团购信息";
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithIcon:@"icon_back" highIcon:@"icon_back_highlighted" target:self action:@selector(close)];
    
    HTHomeTopItem *categoryTopItem = [HTHomeTopItem item];
    [categoryTopItem setTitle:@"全部分类"];
    [categoryTopItem setSubtitle:@"全部"];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    self.navigationItem.leftBarButtonItems = @[backItem, categoryItem];
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCategory:) name:HTCategoryDidChangeNotification object:nil];
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder)
    {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
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

    [self.mapView removeAnnotations:self.mapView.annotations];

    [self mapView:self.mapView regionDidChangeAnimated:YES];
    
    HTHomeTopItem *topItem = (HTHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubtitle:subCategorys?subCategorys:@"全部"];
}

- (void)categoryClick
{
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[[HTCategoryViewController alloc] init]];
    [popover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)update
{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}
#pragma mark--MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
//    HTDealAnnotation *annotation = (HTDealAnnotation *)view.annotation;
//    HTDetailController *detailVC = [[HTDetailController alloc] init];
//    detailVC.deal = annotation.deal;
//
//    [self presentViewController:detailVC animated:YES completion:nil];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(HTDealAnnotation *)annotation
{
    if (![annotation isKindOfClass:[HTDealAnnotation class]]) return nil;
    
    // 创建大头针控件
    static NSString *ID = @"deal";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil)
    {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annoView.canShowCallout = YES;
    }
    
    // 设置模型(位置\标题\子标题)
    annoView.annotation = annotation;
    
    // 设置图片
    if (annotation.icon)
    {
        annoView.image = [UIImage imageWithName:annotation.icon];
    }
    
    return annoView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);;
    MKCoordinateRegion reg = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    [mapView setRegion:reg];

    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (error) return;
        
        CLPlacemark *pm = [placemarks firstObject];
        HTLog(@"%@, %@",pm.addressDictionary, pm.locality);

        NSString *city = pm.addressDictionary[@"State"];
        self.city = [city substringToIndex:city.length - 1];
        
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.city == nil) return;
    
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.city;

    if (self.selectCategoryName) {
        params[@"category"] = self.selectCategoryName;
    }

    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(5000);
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --DPRequestDelegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request != self.lastRequest) return;
    
    HTLog(@"请求失败 - %@", error);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) return;
    
    NSArray *deals = [HTDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    for (HTDeal *deal in deals)
    {
        // 获得团购所属的类型
        HTCategory *category = [HTMetaData categoryWithDeal:deal];
        
        for (HTBusinesses *business in deal.businesses)
        {
            HTDealAnnotation *anno = [[HTDealAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            anno.title = business.name;
            anno.subtitle = deal.title;
            anno.icon = category.map_icon;
            anno.deal = deal;
        
            if ([self.mapView.annotations containsObject:anno]) break;
            
            [self.mapView addAnnotation:anno];
        }
    }
}
@end
