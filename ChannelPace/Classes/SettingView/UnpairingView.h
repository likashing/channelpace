//
//  UnpairingView.h
//  ChannelPace
//
//  Created by eagle on 26/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCall.h"
#import "DBHandler.h"



@interface UnpairingView : UIViewController <ServerCallDelegate>
{
}

@property (nonatomic, strong) DBHandler *dbhandler;

- (IBAction)onCancelBtn:(id)sender;
- (IBAction)onUnpairDevice:(id)sender;


@end
