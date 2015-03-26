//
//  ServerCall.m
//  photolab
//
//  Created by Mountain on 4/11/13.
//  Copyright (c) 2013 Mountain. All rights reserved.
//

#import "ServerCall.h"
#import "SVProgressHUD.h"
#import "Utilities.h"
#import "Macro.h"
#import "Global.h"
#import "OfflineViewController.h"


@implementation ServerCall

@synthesize delegate;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    
    }
    
    return self;
}

- (void) uploadPhoto: (NSString*)strUrl data:(NSDictionary*) dictInfo dataMedia:(NSData*)dataMedia photoName:(NSString*)strName {
    
    //    NSData *dataImg = [NSData dataWithContentsOfFile:strImgPath];
    NSLog(@"Param=%@,", dictInfo);
    
    [SVProgressHUD show];
    
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    NSArray *arrKey = (NSArray*)[dictInfo allKeys];
    for (int i=0; i<arrKey.count; i++) {
        [request setPostValue:[dictInfo objectForKey:[arrKey objectAtIndex:i]] forKey:[arrKey objectAtIndex:i]];
    }
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
 
    [request addData:dataMedia withFileName:strName andContentType:contentType forKey:@"avatar"];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setTimeOutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) uploadVideo: (NSString*)strUrl data:(NSDictionary*) dictInfo dataMedia:(NSData*)dataMedia {


    NSLog(@"Param=%@,", dictInfo);
    
    [SVProgressHUD show];
    
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    NSArray *arrKey = (NSArray*)[dictInfo allKeys];
    for (int i=0; i<arrKey.count; i++) {
        [request setPostValue:[dictInfo objectForKey:[arrKey objectAtIndex:i]] forKey:[arrKey objectAtIndex:i]];
    }
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    dataImg = UIImageJPEGRepresentation([UIImage imageNamed:@"button-main-camera@2x.png"], 1.0);
    [request addData:dataMedia withFileName:@"video.mov" andContentType:contentType forKey:@"video"];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setTimeOutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) requestServer:(NSDictionary *) dict url:(NSString *)url {
   
    localDict = dict;
    apiURL = url;
    
    NSString *strdata = [dict JSONFragment];
    NSLog(@"%@", strdata);
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", SERVER_URL, url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSLog(@"Server URL : %@", [NSString stringWithFormat:@"%@%@", SERVER_URL, url]);
    
    NSData *data = [strdata dataUsingEncoding:NSUTF8StringEncoding];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setPostBody:[data mutableCopy]];
    
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    
    if ([url isEqualToString:@"sevice"]) {
        [request setTimeOutSeconds:60];
    } else {
        [request setTimeOutSeconds: 20];
    }
    
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) requestServerOnPost:(NSString*) strUrl data:(NSDictionary*) dictInfo {
    
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    NSArray *arrKey = (NSArray*)[dictInfo allKeys];
    for (int i=0; i<arrKey.count; i++) {
        [request setPostValue:[dictInfo objectForKey:[arrKey objectAtIndex:i]] forKey:[arrKey objectAtIndex:i]];
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setTimeOutSeconds:20];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void)requestDone:(ASIFormDataRequest*)request {
    
    NSLog(@"%@", [request responseString] );
    NSString* response = [request responseString];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [SVProgressHUD dismiss];
    NSInteger status = [[(NSDictionary*)[response JSONValue] objectForKey:@"status"] integerValue];
    
    if (status == 200)
    {
        NSDictionary *dict = (NSDictionary*)[response JSONValue];
        [self.delegate OnReceived:dict];
    }
    else if (status == 404)
    {
        [Utilities showMsg:@"User not found."];
    }
    else if (status == 500)
    {
        [Utilities showMsg:@"Server Error."];
    }
    else if (status == 503)
    {
        [self.delegate OnOffline];
    }
    else {
       
        [self.delegate OnConnectFail];
    }
}

- (void)requestFailed:(ASIFormDataRequest*)request {
    
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"offlineupdate" object:nil];
    [self.delegate OnConnectFail];

}



- (void) CallApi {

    [delegate OnReceived:[[NSDictionary alloc] initWithObjectsAndKeys:@"test", @"test", nil]];
}

@end
