//
//  HTDetailController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/7.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTDetailController.h"
#import "UIImageView+WebCache.h"
#import "DPAPI.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "HTRestrictions.h"
#import "HTDealDataCace.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UMSocial.h"

@interface HTDetailController () <UIWebViewDelegate, DPRequestDelegate, UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *anyTimeRefund;
@property (weak, nonatomic) IBOutlet UIButton *expiredRefund;
@property (weak, nonatomic) IBOutlet UIButton *remainDays;
@property (weak, nonatomic) IBOutlet UIButton *soldCounts;
@end

@implementation HTDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HTColor(230, 230, 230);

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    
    [self setupContent];
}

- (void)setupContent
{
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    [self.detailImage sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageWithName:@"placeholder_deal"]];
    
    self.currentPriceLabel.text =[ NSString stringWithFormat:@"¥ %@", self.deal.current_price];
    self.currentPriceLabel.text = [NSString twoDecimalWithString:self.currentPriceLabel.text];
    
    self.listPriceLabel.text = [NSString stringWithFormat:@"¥ %@", self.deal.list_price];
    self.listPriceLabel.text = [NSString twoDecimalWithString:self.listPriceLabel.text];
    
    [self.soldCounts setTitle:[NSString stringWithFormat:@"已售出 %d", self.deal.purchase_count] forState:UIControlStateNormal];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *purchaseDate = [fmt dateFromString:self.deal.purchase_deadline];
    purchaseDate = [purchaseDate dateByAddingTimeInterval:24 * 60 * 60];
    
    NSDate *now = [NSDate date];
    int unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unit fromDate:now toDate:purchaseDate options:0];
    
    if (comps.day > 365)
    {
        [self.remainDays setTitle:@"还有一年过期" forState:UIControlStateNormal];
    }
    else
    {
        [self.remainDays setTitle:[NSString stringWithFormat:@"%ld天%ld小时%ld分", (long)comps.day, (long)comps.hour, (long)comps.minute] forState:UIControlStateNormal];
    }
    
    self.collectBtn.selected = [HTDealDataCace isCollect:self.deal];
    [HTDealDataCace saveScanWithHTDeal:self.deal];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buy
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = @"";  //合作身份者id，以2088开头的16位纯数字
    order.seller = @"";    //收款支付宝账号
    order.tradeNO = self.deal.deal_id; //订单ID（由商家自行制定）
    order.productName = self.deal.title; //商品标题
    order.productDescription = self.deal.desc; //商品描述
    order.amount = [self.deal.current_price description]; //商品价格
//    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //URL types
    NSString *appScheme = @"HaHaTuan";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSString *privateKey = @"";  //商户私钥，自助生成
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
        {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
    
}

- (IBAction)collect
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[HTCollectDealKey] = self.deal;
    
    if (!self.collectBtn.selected)
    {
        [HTDealDataCace saveCollectWithHTDeal:self.deal];
        [MBProgressHUD showError:@"收藏成功!" toView:self.view];
        info[HTIsCollectKey] = @YES;
    }
    else
    {
        [HTDealDataCace removeCollectWithHTDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功!" toView:self.view];
        info[HTIsCollectKey] = @NO;
    }
    
    self.collectBtn.selected = !self.collectBtn.selected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HTCollectStateDidChangeNotification object:nil userInfo:info];
}
- (IBAction)share
{
    NSString *shareText = self.deal.desc;           //分享内嵌文字
    
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:shareText
                                     shareImage:nil
                                shareToSnsNames:nil
                                       delegate:self];
}

- (void)loadDeals
{
    DPAPI *dp = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deal_ids"] = self.deal.deal_id;
    
    [dp requestWithURL:@"v1/deal/get_batch_deals_by_id" params:params delegate:self];
}

#pragma mark --DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
//    HTLog(@"%@", [result[@"deals"] firstObject]);
    
    self.deal = [HTDeal objectWithKeyValues:[result[@"deals"] firstObject]];
    
    self.anyTimeRefund.selected = self.deal.restrictions.is_refundable;
    self.expiredRefund.selected = self.deal.restrictions.is_refundable;
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD showError:@"网络繁忙，请稍后再试!" toView:self.view];
}

#pragma mark --UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *dealID = [webView.request.URL.absoluteString substringFromIndex:[webView.request.URL.absoluteString rangeOfString:@"/deal/"].location + 6];
    
    NSString *ID = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"-"].location + 1];
    if ([dealID isEqualToString:ID])
    {
        [webView stopLoading];
        NSString *urlString = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@", ID];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }
    else
    {
        NSMutableString *js = [NSMutableString string];

        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];

        [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
        [js appendString:@"box.parentNode.removeChild(box);"];

        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        
        [js appendString:@"var footNow = document.getElementsByClassName('footer')[0];"];
        [js appendString:@"footNow.parentNode.removeChild(footNow);"];
        
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        [self loadDeals];
        
        self.webView.hidden = NO;
        
        [self.indicatorView stopAnimating];
    }
}

@end
