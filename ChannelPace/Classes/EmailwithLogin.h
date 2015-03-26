//
//  EmailwithLogin.h
//  ChannelPace
//
//  Created by Eagle on 11/24/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EmailwithLogin : UIViewController <UITextFieldDelegate>
{
}

@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) NSString *controlAPIKey;



- (IBAction) onClickGo:(id)sender;
- (IBAction)tapGesture:(id)sender;

- (void) makeControlAPIkey;


@end
