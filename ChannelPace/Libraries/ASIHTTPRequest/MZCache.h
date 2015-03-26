//
//  MZCache.h
//  ApplicationLoader
//
//  Created by Wang Xue on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum enumCacheType {
    
    IMAGE,
    DATA,
    STRING,
    PDF,
    
} CacheType;

@interface MZCache : NSObject {

}

+ (MZCache*)sharedCache;
+ (BOOL) IsAlreadyCahedData;
+ (NSString*) cachePathFor:(CacheType)type;
+ (void)saveDataWithURL:(NSString*)url data:(NSData*)data modifyDate:(NSDate*)modifiedDate;
+ (NSData*)readDataWithURL:(NSString*)url lastModifyDate:(NSDate**)modifiedDate;
+ (void)saveStringWithURL:(NSString*)url string:(NSString*)string modifyDate:(NSDate*)modifiedDate;
+ (NSString*)readStringWithURL:(NSString*)url lastModifyDate:(NSDate**)modifiedDate;
+ (void)saveImageWithURL:(NSString*)url image:(NSData*)imageData;
+ (UIImage*)imageForURL:(NSString*)url;

+ (NSDate*) getModiftyDateIfUpdated:(NSString*)urlString error:(NSError**)error;
+ (NSDate*) getModiftyDateIfUpdatedWithRequest:(NSMutableURLRequest*)request url:(NSString*)urlString error:(NSError**)error ;
+ (NSString*) cachePathForURL:(NSString*)url withType:(int)type;
+ (NSString*) isCachedForURL:(NSString*)url withType:(int)type;
+ (void)removeAllCachedData;

@end
