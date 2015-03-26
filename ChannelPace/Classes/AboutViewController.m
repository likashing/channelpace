//
//  AboutViewController.m
//  ChannelPace
//
//  Created by Eagle on 11/30/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"


@implementation AboutViewController

@synthesize webView;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self linkToSite];
    
    [self customSetup];
        
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [toggleBtn addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [revealViewController panGestureRecognizer];
        [revealViewController tapGestureRecognizer];
    }
}


- (void) linkToSite {
    NSString *siteurl = @"http://www.channelpace.com/appabout";
    NSURL *url = [[NSURL alloc] initWithString:siteurl];
    [[UIApplication sharedApplication] openURL:url];    
}


@end
