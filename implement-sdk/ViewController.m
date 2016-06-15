//
//  ViewController.m
//  implement-sdk
//
//  Created by IHsan HUsnul on 6/14/16.
//  Copyright © 2016 Doku. All rights reserved.
//

#import "ViewController.h"
#import <DokuPay/DokuPay.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface ViewController () <DokuPayDelegate>
{
    DKLayout *dokuLayout;
}
@end

@implementation ViewController

#pragma mark - dokupay static variable's
#define MerchantSharedKey @"aKh4dSX72d6C"
#define MerchantSharedMallID @"1"
#define MerchantPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1K7HIqij8KbWNjDscMAfCnwKEr1pK8bdBQhGzRedBCBJ03ux+pZZulMq9BEREA/p2xWpMKAmSghhErGl//T1U6/0Ejvk1GOfmKqoG/az0bbdV0FRkUKxiNpaViTHz0DRe44SYE2oinl6WVQaHeYueA4PK11aynjWdmt+ZZiYYHeyOLhFxjcNb90uQBghv/kY5gnXeXMr/fUSVkMfrGvjZMyZLUmWgicWaECvH88OrtpMDQRc+jK3D+huTMqBLcotxYKEed6T8YciNTxc/JR3Y6IgFJC874/ob5XWmB+BMKTopaGPz+a+WVllbcaYbVbsZ+XwbY1Z7hG/qmmyZ1AhdQIDAQAB"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup DKLayout
    dokuLayout = [[DKLayout alloc] init];
    dokuLayout.toolbarColor = [UIColor redColor];
    dokuLayout.toolbarTextColor = [UIColor greenColor];
    dokuLayout.toolbarTintColor = [UIColor whiteColor];
    dokuLayout.fieldTextColor = [UIColor blueColor];
    dokuLayout.labelTextColor = [UIColor orangeColor];
    dokuLayout.BGColor = [UIColor lightGrayColor];
    dokuLayout.buttonTextColor = [UIColor yellowColor];
    dokuLayout.buttonBGColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapCC:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    [[DokuPay sharedInstance] setLayout:dokuLayout];
    [[DokuPay sharedInstance] setPaymentItem:paymentItem];
    [[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeCC];
    [[DokuPay sharedInstance] setDelegate:self];
    [[DokuPay sharedInstance] presentPayment];
}

- (IBAction)tapVA:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    [[DokuPay sharedInstance] setLayout:dokuLayout];
    [[DokuPay sharedInstance] setPaymentItem:paymentItem];
    [[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeVirtualAccount];
    [[DokuPay sharedInstance] setDelegate:self];
    [[DokuPay sharedInstance] presentPayment];
}

- (IBAction)tapVAMini:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    [[DokuPay sharedInstance] setLayout:dokuLayout];
    [[DokuPay sharedInstance] setPaymentItem:paymentItem];
    [[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeVirtualMini];
    [[DokuPay sharedInstance] setDelegate:self];
    [[DokuPay sharedInstance] presentPayment];
}

- (IBAction)tapMandiri:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    [[DokuPay sharedInstance] setLayout:dokuLayout];
    [[DokuPay sharedInstance] setPaymentItem:paymentItem];
    [[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeMandiriClickPay];
    [[DokuPay sharedInstance] setDelegate:self];
    [[DokuPay sharedInstance] presentPayment];
}

- (IBAction)tapWallet:(id)sender
{
    DKPaymentItem *paymentItem = [self getPaymentItem];
    [[DokuPay sharedInstance] setLayout:dokuLayout];
    [[DokuPay sharedInstance] setPaymentItem:paymentItem];
    [[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeWallet];
    [[DokuPay sharedInstance] setDelegate:self];
    [[DokuPay sharedInstance] presentPayment];
}



#pragma mark - utility for dokupay
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

-(NSString*)getMyUUID
{
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
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


#pragma mark - DokuPay delegate
-(void)onDokuPaySuccess:(NSDictionary *)dictData
{
    NSLog(@"catch Success delegate : %@", dictData);
}

-(void)onDokuPayError:(NSError *)error
{
    NSLog(@"catch Error delegate : %@", error);
}

-(void)onDokuMandiriPaySuccess:(NSDictionary*)response
{
    NSURL *URL = [NSURL URLWithString:@"http://crm.doku.com/doku-library-staging/example-payment-mobile/merchant-mandiri-example.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSString *params = [NSString stringWithFormat:@"data={\"req_payment_channel\":\"02\",\"req_device_id\":\"%@\",\"req_challenge_code_2\":\"%@\",\"req_response_token\":\"%@\",\"req_challenge_code_1\":\"%@\",\"req_transaction_id\":\"%@\",\"req_card_number\":\"%@\",\"req_challenge_code_3\":\"%@\"}",
                        [self getMyUUID],
                        [response objectForKey:@"challenge2"],
                        [response objectForKey:@"responseValue"],
                        [response objectForKey:@"challenge1"],
                        [self getRandomPINString:10],
                        [response objectForKey:@"debitCard"],
                        [response objectForKey:@"challenge3"]];
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"catch mandiri delegate: %@", responseObject);
    }];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"Mohon Tunggu..."];
    [task resume];
}

@end
