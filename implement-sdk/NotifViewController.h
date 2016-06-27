//
//  NotifViewController.h
//  ios-sdk
//
//  Created by IHsan HUsnul on 6/12/16.
//  Copyright © 2016 Doku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifViewController : UIViewController

@property (strong, nonatomic) NSError *error;
@property (nonatomic, strong) NSDictionary *response;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;

@end
