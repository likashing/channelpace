//
//  LogoViewController.m
//  ChannelPace
//
//  Created by Eagle on 11/30/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "LogoViewController.h"
#import "AppDelegate.h"


@implementation LogoViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    _dictArray = [[NSMutableArray alloc] init];

    
    _dbhandler = [[DBHandler alloc] init];
    [_dbhandler getMyContactsList:_dictArray orderby:APPDELEGATE.userSettingObj.sortName];
    
    if (!_dictArray || [_dictArray count] < 1) {
        
        [self performSelector:@selector(navigate) withObject:nil afterDelay:2.0];
//        APPDELEGATE.isLoggedIn = NO;
//        [APPDELEGATE saveLoginInfo];
        
    } else {
        
        [self performSegueWithIdentifier:@"refresh_controller" sender:self];
        APPDELEGATE.isLoggedIn = YES;
        [APPDELEGATE saveLoginInfo];
    }
    
    
    
}

- (void) didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void) navigate
{
    [self performSegueWithIdentifier:@"welcome_controller" sender:self];
}





@end
