//
//  OfflineViewController.m
//  ChannelPace
//
//  Created by Eagle on 12/11/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "OfflineViewController.h"



@interface OfflineViewController ()

@end

@implementation OfflineViewController

@synthesize btnCancel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view bringSubviewToFront:btnCancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    


- (IBAction)onCancelBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}



@end
