//
//  ViewController.m
//  ios-sdk
//
//  Created by IHsan HUsnul on 4/27/16.
//  Copyright © 2016 Doku. All rights reserved.
//

#import "ViewController.h"
#import <DokuPay/DokuPay.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "NotifViewController.h"

@interface ViewController ()
{
    DKLayout *dokuLayout;
}
@end

@implementation ViewController

#define URL_CHARGING_DOKU_DAN_CC @"http://crm.doku.com/doku-library-staging/example-payment-mobile/merchant-example.php"
#define URL_CHARGING_MANDIRI_CLICKPAY @"http://crm.doku.com/doku-library-staging/example-payment-mobile/merchant-mandiri-example.php"

// production
/*
 #define MerchantSharedKey @"5TgcF43EdsX3"
 #define MerchantSharedMallID @"59"
 #define MerchantPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiZjidFNbzn+1C7vZG0j1oRjnKYwBjOAFs/D7yYSQ/NzkXpThYI8DcIoSXZfMRuU81uuh5Tan2WrjmXcIaJjr509vX2xAP/x7rPfgWwrlXRlC/02bH2wqULxw/hrW3GXNFA9a/OwpfKVbj5GJ3JoyBzp247mBfs38iIXNZ1NjzKhs7G42hZ88f5FNKRjQnHKOe7JjcW31oEn4WnkWfZDsdAux3cPpWw3C4FT3Ny4j/VXwcuSAnccjerkXVLK2zOncbG6abCJ74/MP5KEOnbP6nLgYJT5wsANz/Apx3mZOJj5RbX9OTz3w+p8AexScRkApVifDOnLZNHwv48aua5G6rQIDAQAB"
 //#define DokuPayTokenPayment @"9133428f7966395ee657e0a51c1c92dcd9bcd52f"
 #define DokuPayCustomerID @"69800071"
 */

// staging
#define MerchantSharedKey @"Kk45Ul2vMVn1"
#define MerchantSharedMallID @"3347"
#define MerchantPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAje9PLL115EfEa55U0hAVaRSSvSaJPZkM54DRMofUSiWmLIROvusSLoSyJssRkyhmfxrqgM5N5Z6X/68AOw+jkX3azlhJzw3/RCaSFGLzKwy0IO3ICZzBHOn43scTWGIftifAVO+40LPhZV0wPsfdxY/0oUwCYc+tCGP7oiZ0kOSQkXP7KqkLEmncGlRIv9qwFdXaSx2vDvZrfulNPFuRsz2Mb56IrGLw9oG0nSBfydTuIcav9KyyENU49I4z+UzKkDw8/oQ4FkLuXaTHKFSUcW+nIKqXuKGOjHq4uzaR+b3oC+S9Xm95ylbU29aKXYaNoJer/4ezUdBuJ069q7AclwIDAQAB"
//#define DokuPayTokenPayment @"9133428f7966395ee657e0a51c1c92dcd9bcd52f"
#define DokuPayCustomerID @"69800071"


#define PRICE @"15.000"
#define QTY 1



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    _priceLabel.text = [NSString stringWithFormat:@"Price : %@ IDR", PRICE];
    
    _qtyLabel.text = [NSString stringWithFormat:@"QTY : %d", QTY];
    
    [self roundBorderButton:_ccBtn withIcon:@"ico_pc_cc" withSelector:@selector(tapCCBtn:)];
    [self roundBorderButton:_firstTokenBtn withIcon:@"ico_pc_cc.png" withSelector:@selector(tapFirstTokenization:)];
    [self roundBorderButton:_secondTokenBtn withIcon:@"ico_pc_cc.png" withSelector:@selector(tapSecondTokenization:)];
    [self roundBorderButton:_walletBtn withIcon:@"ico_pc_doku.png" withSelector:@selector(tapWalletBtn:)];
    [self roundBorderButton:_mandiriClickPayBtn withIcon:@"ico_pc_mandiriclickpay.png" withSelector:@selector(tapMandiriClickPayBtn:)];
    [self roundBorderButton:_virtualBtn withIcon:@"ico_pc_va.png" withSelector:@selector(tapVirtualBtn:)];
    [self roundBorderButton:_virtualMiniBtn withIcon:@"ico_pc_va_merchant.png" withSelector:@selector(tapVirtualMiniBtn:)];
    
    // setup DKLayout
    dokuLayout = [[DKLayout alloc] init];
    // dokuLayout.toolbarColor = [UIColor redColor];
    // dokuLayout.toolbarTextColor = [UIColor greenColor];
    // dokuLayout.toolbarTintColor = [UIColor whiteColor];
    // dokuLayout.fieldTextColor = [UIColor blueColor];
    // dokuLayout.labelTextColor = [UIColor orangeColor];
    // dokuLayout.BGColor = [UIColor lightGrayColor];
    // dokuLayout.buttonTextColor = [UIColor yellowColor];
    // dokuLayout.buttonBGColor = [UIColor darkGrayColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)roundBorderButton:(UIView*)btn withIcon:(NSString*)imgString withSelector:(SEL)selector
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [btn addGestureRecognizer:tap];
    
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (IBAction)tapCCBtn:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    
    DokuPay *doku = [DokuPay sharedInstance];
    doku.paymentItem = paymentItem;
    doku.paymentChannel = DokuPaymentChannelTypeCC;
    doku.delegate = self;
    doku.layout = dokuLayout;
    [doku presentPayment];
}

- (IBAction)tapFirstTokenization:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    paymentItem.customerID = DokuPayCustomerID;
    
    DokuPay *doku = [DokuPay sharedInstance];
    doku.paymentItem = paymentItem;
    doku.paymentChannel = DokuPaymentChannelTypeCCFirst;
    doku.delegate = self;
    doku.layout = dokuLayout;
    [doku presentPayment];
}

- (IBAction)tapSecondTokenization:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    paymentItem.customerID = DokuPayCustomerID;
    paymentItem.tokenPayment = [self getTokenPayment];
    
    DokuPay *doku = [DokuPay sharedInstance];
    doku.paymentItem = paymentItem;
    doku.paymentChannel = DokuPaymentChannelTypeCCSecond;
    doku.delegate = self;
    doku.layout = dokuLayout;
    [doku presentPayment];
}

- (IBAction)tapWalletBtn:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    
    DokuPay *doku = [DokuPay sharedInstance];
    doku.paymentItem = paymentItem;
    doku.paymentChannel = DokuPaymentChannelTypeWallet;
    doku.delegate = self;
    doku.layout = dokuLayout;
    [doku presentPayment];
}

- (IBAction)tapMandiriClickPayBtn:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    
    DokuPay *doku = [DokuPay sharedInstance];
    doku.paymentItem = paymentItem;
    doku.paymentChannel = DokuPaymentChannelTypeMandiriClickPay;
    doku.delegate = self;
    doku.layout = dokuLayout;
    [doku presentPayment];
}

- (IBAction)tapVirtualBtn:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    
    DokuPay *doku = [DokuPay sharedInstance];
    doku.paymentItem = paymentItem;
    doku.paymentChannel = DokuPaymentChannelTypeVirtualAccount;
    doku.delegate = self;
    doku.layout = dokuLayout;
    [doku presentPayment];
}

- (IBAction)tapVirtualMiniBtn:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    
    DokuPay *doku = [DokuPay sharedInstance];
    doku.paymentItem = paymentItem;
    doku.paymentChannel = DokuPaymentChannelTypeVirtualMini;
    doku.delegate = self;
    doku.layout = dokuLayout;
    [doku presentPayment];
}

-(DKPaymentItem*)getPaymentItem
{
    DKPaymentItem *paymentItem = [[DKPaymentItem alloc] init];
    NSArray *basket = @[@{@"name":@"sayur",@"amount":@"10000.00",@"quantity":@"1",@"subtotal":@"10000.00"},
                        @{@"name":@"buah",@"amount":@"10000.00",@"quantity":@"1",@"subtotal":@"10000.00"}];
    
    paymentItem.dataAmount = @"15000.00";
    paymentItem.dataBasket = basket;
    paymentItem.dataImei = [self getMyUUID];
    paymentItem.dataCurrency = @"360";
    paymentItem.dataMerchantChain = @"NA";
    paymentItem.dataSessionID = [self getRandomPINString:9];
    paymentItem.dataTransactionID = [self getRandomPINString:10];
    paymentItem.isProduction = false;
    paymentItem.dataMerchantCode = MerchantSharedMallID;
    paymentItem.publicKey = MerchantPublicKey;
    paymentItem.sharedKey = MerchantSharedKey;
    paymentItem.dataWords = [paymentItem generateWords];
    paymentItem.mobilePhone = @"";
    
    return paymentItem;
}


#pragma mark - dokupay delegate
-(void)onDokuPaySuccess:(NSDictionary*)dictData
{
    NSURL *URL = [NSURL URLWithString:URL_CHARGING_DOKU_DAN_CC];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSString *params = [NSString stringWithFormat:@"data=%@", [self jsonStringWithPrettyPrint:NO fromDictionary:dictData]];
    NSLog(@"request charging : %@, %@", [URL absoluteString], params);
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                                    {
                                        NSLog(@"RESPONSE charging: %@", responseObject);
                                        [SVProgressHUD dismiss];
                                        
                                        [self popError:error withReponse:responseObject];
                                    }];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"Mohon Tunggu..."];
    [task resume];
}

- (void)onDokuPayError:(NSError *)error
{
    NSLog(@"%s Error Value %@",__PRETTY_FUNCTION__, error);
    
    [self popError:error withReponse:nil];
}

-(void)onDokuMandiriPaySuccess:(NSDictionary*)response
{
    NSLog(@"response mandiri : %@", response);
    
    NSDictionary *dict = @{@"req_challenge_code_3": [response objectForKey:@"challenge3"],
                           @"req_response_token": [response objectForKey:@"responseValue"],
                           @"req_challenge_code_2": [response objectForKey:@"challenge2"],
                           @"req_challenge_code_1": [response objectForKey:@"challenge1"],
                           @"req_card_number": [response objectForKey:@"debitCard"],
                           @"req_transaction_id": [self getRandomPINString:10],
                           @"req_payment_channel": @"02",
                           @"req_device_id": [self getMyUUID]};
    
    NSURL *URL = [NSURL URLWithString:URL_CHARGING_MANDIRI_CLICKPAY];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSString *params = [NSString stringWithFormat:@"data=%@", [self jsonStringWithPrettyPrint:NO fromDictionary:dict]];
    NSLog(@"URL_CHARGING_MANDIRI_CLICKPAY : %@, %@", [URL absoluteString], params);
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                                    {
                                        NSLog(@"mandiri charging : %@", dict);
                                        [SVProgressHUD dismiss];
                                        
                                        [self popError:error withReponse:responseObject];
                                    }];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"Mohon Tunggu..."];
    [task resume];
}

// http://stackoverflow.com/questions/6368867/generate-json-string-from-nsdictionary-in-ios
-(NSString*)jsonStringWithPrettyPrint:(BOOL)prettyPrint fromDictionary:(NSDictionary*)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

-(NSString *)getRandomPINString:(NSInteger)length
{
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    
    NSString *numbers = @"0123456789";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++)
    {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    
    return returnString;
}

-(void)pushResultPage:(NSDictionary*)response
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Success"
                                                                          message:[NSString stringWithFormat:@"%@", response]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [alertControl dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [alertControl addAction:okAction];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

-(void)popError:(NSError*)error withReponse:(NSDictionary*)responseObject
{
    [self savingTokenPayment:responseObject];
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"tabNotif"];
    NotifViewController *vc = (NotifViewController*)nav.topViewController;
    vc.error = error;
    vc.response = responseObject;
    [self presentViewController:nav animated:YES completion:nil];
}

-(NSString*)getMyUUID
{
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+(UIBarButtonItem*)barButtonBack:(id)target selector:(SEL)selector withTintColor:(UIColor*)tintColor
{
    UIImage *icon = [[UIImage imageNamed:@"DokuPay.bundle/back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:icon forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 52, 41)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -5, 10, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 1.1, 50, 40)];
    [label setTextColor:tintColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"Back"];
    [button addSubview:label];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return backItem;
}

-(void)savingTokenPayment:(NSDictionary*)responseObject
{
    if (responseObject[@"res_bundle_token"])
    {
        NSData *data = [responseObject[@"res_bundle_token"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *bundleToken = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
        
        // saving tokenPayment
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:bundleToken[@"res_token_payment"] forKey:@"tokenPayment"];
        [user synchronize];
    }
}

-(NSString*)getTokenPayment
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"tokenPayment"];
}

@end