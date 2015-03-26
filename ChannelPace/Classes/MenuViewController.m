//
//  MenuViewController.m
//  ChannelPace
//
//  Created by Eagle on 11/26/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "MenuViewController.h"
#import "MyContactsViewController.h"
#import "MenuItemCell.h"


@interface MenuViewController ()
{
    UITableViewCell *cellLastSelected;
    
}

@end

@implementation MenuViewController


- (void)viewDidLoad {
  
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg.png"]];
    [self.tableView setBackgroundView:bg];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cellLastSelected = cell;
    switch ( indexPath.row )
    {
        case 0:
            [self performSegueWithIdentifier:@"go0" sender:nil];
            break;
            
        case 1:
            [self performSegueWithIdentifier:@"go1" sender:nil];
            break;
            
        case 2:
            [self performSegueWithIdentifier:@"go2" sender:nil];
            break;
            
        case 3:
            [self performSegueWithIdentifier:@"go3" sender:nil];
            break;
            
        case 4:
            [self openAboutView];
            break;
            
        case 5:
            [self performSegueWithIdentifier:@"go5" sender:nil];
            break;
    }


}

- (void) openAboutView{
    NSString *siteurl = @"http://www.channelpace.com/appabout";
    NSURL *url = [[NSURL alloc] initWithString:siteurl];
    [[UIApplication sharedApplication] openURL:url];

}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCell *cell = (MenuItemCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [cell setHighlighted:NO];
    [self.tableView deselectRowAtIndexPath:[self.tableView
                                            indexPathForSelectedRow] animated: YES];
    
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuItem";
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    if (!cell)
        cell = [[MenuItemCell alloc] init];
    
    
    switch ( indexPath.row )
    {
        case 0:
            [cell setTableCell:@"MyContacts"];
            break;
            
        case 1:
            [cell setTableCell:@"Association Requests"];
            break;
            
        case 2:
            [cell setTableCell:@"Settings"];
            break;
            
        case 3:
            [cell setTableCell:@"MyDetails"];
            break;
            
        case 4:
            [cell setTableCell:@"About"];
            break;
            
        case 5:
            [cell setTableCell:@"Support"];
            break;
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}


@end
