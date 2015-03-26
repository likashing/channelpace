//
//  SupportViewController.m
//  ChannelPace
//
//  Created by Eagle on 11/30/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "SupportViewController.h"
#import "SWRevealViewController.h"


@implementation SupportViewController



- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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


- (IBAction)linkToChannelpace:(id)sender {
    
    NSString *shareUrlString = [NSString stringWithFormat:@"http://channelpace.com/appfaq"];
    NSURL *url = [ [ NSURL alloc ] initWithString:shareUrlString ];
    [[UIApplication sharedApplication] openURL:url];

    
}

- (IBAction)linkToGoChannelpace:(id)sender {
    
    NSString *shareUrlString = [NSString stringWithFormat:@"http://channelpace.com/appsupport"];
    NSURL *url = [ [ NSURL alloc ] initWithString:shareUrlString ];
    [[UIApplication sharedApplication] openURL:url];

}



@end
