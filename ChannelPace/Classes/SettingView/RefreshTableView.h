//
//  RefreshTableView.h
//  ChannelPace
//
//  Created by eagle on 24/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshTableView : UITableViewController
{
    NSArray *refreshArray;
}

@property (strong, nonatomic) IBOutlet UILabel *daily;
@property (strong, nonatomic) IBOutlet UILabel *through;
@property (strong, nonatomic) IBOutlet UILabel *manually;




- (IBAction)onBackBtn:(id)sender;

@end
