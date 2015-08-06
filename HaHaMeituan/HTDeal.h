//
//  HTDeal.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/5.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTDeal : NSObject

@property (nonatomic, copy) NSString *deal_id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSNumber *list_price;

@property (nonatomic, strong) NSNumber *current_price;

@property (nonatomic, assign) int purchase_count;

@property (nonatomic, copy) NSString *image_url;

@property (nonatomic, copy) NSString *s_image_url;

@property (nonatomic, copy) NSString *publish_date;
@end
