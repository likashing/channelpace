//
//  ServerCall.h
//  photolab
//
//  Created by Mountain on 4/11/13.
//  Copyright (c) 2013 Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "JSON.h"

@protocol ServerCallDelegate;
@interface ServerCall : NSObject {

    id <ServerCallDelegate> delegate;
    
    NSDictionary *localDict;
    NSString *apiURL;
}

@property (nonatomic, strong) id <ServerCallDelegate> delegate;

- (void) CallApi;
- (void) requestServer:(NSDictionary *) dict url: (NSString *)url;
- (void) uploadVideo: (NSString*)strUrl data:(NSDictionary*) dictInfo dataMedia:(NSData*)dataMedia;
- (void) uploadPhoto: (NSString*)strUrl data:(NSDictionary*) dictInfo dataMedia:(NSData*)dataMedia  photoName:(NSString*)strName;
- (void) requestServerOnPost:(NSString*) strUrl data:(NSDictionary*) dictInfo;

@end

@protocol ServerCallDelegate

- (void) OnReceived: (NSDictionary*) dictData;
- (void) OnConnectFail;
- (void) OnOffline;


@end