//
//  PINEnterController.h
//  ChannelPace
//
//  Created by Eagle on 11/24/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCall.h"


@interface PINEnterController : UIViewController<ServerCallDelegate, UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *txtPIN;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


- (IBAction)onClickGo:(id)sender;
- (IBAction)tapGesture:(id)sender;

@end
