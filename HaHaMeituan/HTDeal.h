//
//  HTDeal.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/5.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTRestrictions;

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

@property (nonatomic, copy) NSString *deal_h5_url;

@property (nonatomic, copy) NSString *purchase_deadline;

@property (nonatomic, strong) HTRestrictions *restrictions;

@property (nonatomic, assign, getter=isEditting) BOOL editing;

@property (nonatomic, assign, getter=isChecking) BOOL checking;

@property (nonatomic, strong) NSArray *businesses;

@property (nonatomic, strong) NSArray *categories;
@end
