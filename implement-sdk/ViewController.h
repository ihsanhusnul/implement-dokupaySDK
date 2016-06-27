//
//  ViewController.h
//  ios-sdk
//
//  Created by IHsan HUsnul on 4/27/16.
//  Copyright © 2016 Doku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;
@property (weak, nonatomic) IBOutlet UIView *firstTokenBtn;
@property (weak, nonatomic) IBOutlet UIView *secondTokenBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *ccBtn;
@property (weak, nonatomic) IBOutlet UIView *walletBtn;
@property (weak, nonatomic) IBOutlet UIView *mandiriClickPayBtn;
@property (weak, nonatomic) IBOutlet UIView *virtualBtn;
@property (weak, nonatomic) IBOutlet UIView *virtualMiniBtn;

+(UIBarButtonItem*)barButtonBack:(id)target selector:(SEL)selector withTintColor:(UIColor*)tintColor;

@end

