//
//  RefreshingViewController.m
//  ChannelPace
//
//  Created by Eagle on 11/29/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "RefreshingViewController.h"
#import "MBProgressHUD.h"
#import "NSString+md5.h"
#import "LoginSuccessfulViewController.h"



@implementation RefreshingViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [MBProgressHUD showHUDAddedTo:self.view text:@"Refreshing..." animated:YES];
    
    NSLog(@"MD5 : %@", [@"test" md5]);
    
    [self performSelector:@selector(navigate) withObject:nil afterDelay:2.0f];
    
}

- (void) refreshData
{
//    NSMutableArray * 
//    _dbhandler = [[DBHandler alloc] init];
//    _dbhandler getMyContactsList:<#(NSMutableArray *)#> orderby:<#(NSString *)#>
    
}

- (void) navigate
{

    [self performSegueWithIdentifier:@"goContacts" sender:self];

}

- (void) didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.


}



@end
