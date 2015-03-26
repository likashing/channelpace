//
//  AboutViewController.h
//  ChannelPace
//
//  Created by Eagle on 11/30/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIButton *toggleBtn;
    IBOutlet UILabel *labelURL;
    IBOutlet UITextView *textURL;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)linkToSite:(id)sender;

@end
