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

#define URL_CHARGING_DOKU_DAN_CC @"http://crm.doku.com/doku-library/example-payment-mobile/merchant-example.php"
#define URL_CHARGING_MANDIRI_CLICKPAY @"http://crm.doku.com/doku-library/example-payment-mobile/merchant-mandiri-example.php"

#define MerchantSharedKey @"aKh4dSX72d6C"
#define MerchantSharedMallID @"1"
#define MerchantPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1K7HIqij8KbWNjDscMAfCnwKEr1pK8bdBQhGzRedBCBJ03ux+pZZulMq9BEREA/p2xWpMKAmSghhErGl//T1U6/0Ejvk1GOfmKqoG/az0bbdV0FRkUKxiNpaViTHz0DRe44SYE2oinl6WVQaHeYueA4PK11aynjWdmt+ZZiYYHeyOLhFxjcNb90uQBghv/kY5gnXeXMr/fUSVkMfrGvjZMyZLUmWgicWaECvH88OrtpMDQRc+jK3D+huTMqBLcotxYKEed6T8YciNTxc/JR3Y6IgFJC874/ob5XWmB+BMKTopaGPz+a+WVllbcaYbVbsZ+XwbY1Z7hG/qmmyZ1AhdQIDAQAB"
#define DokuPayTokenPayment @"9133428f7966395ee657e0a51c1c92dcd9bcd52f"
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
    paymentItem.tokenPayment = DokuPayTokenPayment;
    
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
    paymentItem.mobilePhone = @"08123123112";
    
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
    
    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"response charging : %@", dictData);
        
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
    NSLog(@"URL_CHARGING_MANDIRI_CLICKPAY : --%@, %@", [URL absoluteString], params);
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"mandiri charging : %@", dict);
        
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

@end
