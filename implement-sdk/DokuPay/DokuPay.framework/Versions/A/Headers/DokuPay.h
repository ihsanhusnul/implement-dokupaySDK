//
//  DokuPay.h
//  DokuPay
//
//  Created by IHsan HUsnul on 4/27/16.
//  Copyright © 2016 Doku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKPaymentItem.h"
#import "DKNavigationController.h"


@protocol DokuPayDelegate <NSObject>
-(void)onDokuPayError:(nonnull NSError*)error;
-(void)onDokuPaySuccess:(nonnull NSDictionary*)dictData;
-(void)onDokuMandiriPaySuccess:(nonnull NSDictionary*)dictData;
@end


@interface DokuPay : NSObject

#define DokuPaymentChannelTypeCC @"15"
#define DokuPaymentChannelTypeWallet @"04"
#define DokuPaymentChannelTypeMandiriClickPay @"3"
#define DokuPaymentChannelTypeVirtualAccount @"4"
#define DokuPaymentChannelTypeVirtualMini @"5"


@property (nonnull, nonatomic, strong) DKNavigationController *navController;
@property (nonnull, nonatomic, strong) NSString *paymentChannel;
@property (nonnull, nonatomic, strong) DKPaymentItem *paymentItem;

@property (nullable, nonatomic, weak) id<DokuPayDelegate>delegate;

-(void)presentPayment;


-(void)onSuccess:(nonnull NSDictionary*)responseDict;
-(void)onError:(nonnull NSError*)error;
-(void)onMandiriSuccess:(nonnull NSDictionary*)dictData;

-(nonnull UIActivityIndicatorView*)indicatorHUD;

+(nonnull id)sharedInstance;

@end
