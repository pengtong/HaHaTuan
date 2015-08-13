//
//  HTRestrictions.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/8.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTRestrictions : NSObject
//restrictions.is_reservation_required	int	是否需要预约，0：不是，1：是
//restrictions.is_refundable	int	是否支持随时退款，0：不是，1：是
//restrictions.special_tips	string 特别提示(一般为团购的限制信息)

@property (nonatomic, assign) NSInteger is_reservation_required;

@property (nonatomic, assign) NSInteger is_refundable;

@property (nonatomic, copy) NSString *special_tips;
@end
