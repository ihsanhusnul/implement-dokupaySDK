//
//  DKPaymentItem.h
//  DokuPay
//
//  Created by IHsan HUsnul on 4/27/16.
//  Copyright © 2016 Doku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKPaymentItem : NSObject

@property (nonnull, nonatomic, strong) NSString *dataMerchantCode;
@property (nonnull, nonatomic, strong) NSString *dataWords;
@property (nonnull, nonatomic, strong) NSString *dataTransactionID;
@property (nonnull, nonatomic, strong) NSString *dataAmount;
@property (nonnull, nonatomic, strong) NSString *dataCurrency;
@property (nonnull, nonatomic, strong) NSString *dataMerchantChain;
@property (nonnull, nonatomic, strong) NSArray *dataBasket;
@property (nonnull, nonatomic, strong) NSString *dataSessionID;
@property (nonnull, nonatomic, strong) NSString *dataImei;
@property (nonnull, nonatomic, strong) NSString *mobilePhone;
@property (nullable, nonatomic, strong) NSDictionary *dataOptions;
@property (nonatomic, assign) BOOL isProduction;
@property (nonnull, nonatomic, strong) NSString *publicKey;
@property (nullable, nonatomic, strong) NSString *customerID;
@property (nonnull, nonatomic, strong) NSString *sharedKey;
@property (nullable, nonatomic, strong) NSString *tokenPayment;

-(nonnull NSString*)dataBasketEscape;
-(nonnull NSString*)generateWords;

+(nonnull NSString *)sha1:(nonnull NSString*)string;

@end
