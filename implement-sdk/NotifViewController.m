//
//  NotifViewController.m
//  ios-sdk
//
//  Created by IHsan HUsnul on 6/12/16.
//  Copyright © 2016 Doku. All rights reserved.
//

#import "NotifViewController.h"
#import "ViewController.h"

@interface NotifViewController ()

@end

@implementation NotifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [ViewController barButtonBack:self selector:@selector(back) withTintColor:self.navigationController.navigationBar.tintColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    NSString *plString = @"";
    UIImage *img = nil;
    
    if ([[_response objectForKey:@"res_response_code"] isEqualToString:@"0000"])
    {
        plString = @"Payment Successful";
        
        img = [UIImage imageNamed:@"ico_payment_success"];
    }
    else
    {
        plString = @"Payment Failed";
        img = [UIImage imageNamed:@"ico_payment_failed"];
    }
    
    _paymentLabel.text = plString;
    [_imageView setImage:img];
    
    _finishBtn.layer.cornerRadius = 5;
    _finishBtn.layer.borderWidth = 1;
    _finishBtn.layer.masksToBounds = YES;
    _finishBtn.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"error: %@", _error);
    
    BOOL isError = NO;
    
    NSString *titleCode;
    
    if (_error)
    {
        isError = YES;
        
        titleCode = [NSString stringWithFormat:@"%ld", (long)_error.code];
    }
    else if (_response && ![[_response objectForKey:@"res_response_code"] isEqualToString:@"0000"])
    {
        NSString *msg = @"Failed";
        msg = _response[@"res_response_msg"] ? _response[@"res_response_msg"] : _response[@"res_message"];
        
        _error = [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                    code:0
                                                userInfo:@{NSLocalizedDescriptionKey: msg}];
        titleCode = [_response objectForKey:@"res_response_code"];
        
        isError = YES;
    }
    
    if (isError)
    {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil // titleCode
                                                                              message:_error.localizedDescription
                                                                       preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [alertControl dismissViewControllerAnimated:YES completion:nil];
                                                         }];
        [alertControl addAction:okAction];
        
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

- (IBAction)tapFinish:(id)sender
{
    [self back];
}

-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
