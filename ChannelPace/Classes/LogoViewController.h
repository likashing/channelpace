//
//  LogoViewController.h
//  ChannelPace
//
//  Created by Eagle on 11/30/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBHandler.h"

@interface LogoViewController : UIViewController

@property (nonatomic, strong) DBHandler      *dbhandler;
@property (nonatomic, strong) NSMutableArray *dictArray;

@end
