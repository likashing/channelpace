//
//  MZCache.m
//  ApplicationLoader
//
//  Created by Wang Xue on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//
#import <CommonCrypto/CommonDigest.h>
#import "MZCache.h"

static MZCache* instance = nil;

@implementation MZCache

+ (MZCache*)sharedCache {
    
    if (instance == nil) {
        instance = [[MZCache alloc] init];
    }
    return instance;
}

+ (NSString*)md5:(NSString*) str {
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat: 
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1],
			result[2], result[3],
			result[4], result[5],
			result[6], result[7],
			result[8], result[9],
			result[10], result[11],
			result[12], result[13],
			result[14], result[15]];
}

+ (void) initialize {
    
    [super initialize];
    
    if (YES) {
        
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) objectAtIndex:0];
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[self cachePathFor:IMAGE] withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:[self cachePathFor:DATA] withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:[self cachePathFor:STRING] withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:[self cachePathFor:PDF] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
	return;
}



+ (void)removeAllCachedData {

	[[NSFileManager defaultManager] removeItemAtPath:[self cachePathFor:IMAGE] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[self cachePathFor:DATA] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[self cachePathFor:STRING] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[self cachePathFor:PDF] error:nil];
}

+ (NSString*) cachePathFor:(CacheType)type {
 
    NSString* subDir = nil;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) objectAtIndex:0];
    
    switch (type) {
        case IMAGE:
            subDir = @"Image";
            break;
            
        case DATA:
            subDir = @"Data";
            break;
            
        case STRING:
            subDir = @"String";
            
        case PDF:
            subDir = @"PDF";
            break;
    }
    
    return [rootPath stringByAppendingPathComponent:subDir];
}

+ (void)saveImageWithURL:(NSString*)url image:(NSData*)imageData {

	if (imageData == nil)
		return;
	
	NSString* fileName = [[self cachePathFor:IMAGE] stringByAppendingPathComponent:[MZCache md5:url]];    
	if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
		return;
	
	if (![[NSFileManager defaultManager] createFileAtPath:fileName contents:imageData attributes:nil]) {  
	}
	else {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:YES] forKey:@"Cache"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    
}

+ (UIImage*)imageForURL:(NSString*)url {

	NSString* fileName = [[self cachePathFor:IMAGE] stringByAppendingPathComponent:[MZCache md5:url]];    
	NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:fileName];
	
	if (fh) {
		NSData* data = [fh readDataToEndOfFile];
		[fh closeFile];
		
        return [UIImage imageWithData:data];
	}
	
	return nil;
}


+ (void)saveDataWithURL:(NSString*)url data:(NSData*)data modifyDate:(NSDate*)modifiedDate {
	
	if (data == nil)
		return;
	
	NSString* fileName = [[self cachePathFor:DATA] stringByAppendingPathComponent:[MZCache md5:url]];    
	if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
		return;
	
	if (![[NSFileManager defaultManager] createFileAtPath:fileName contents:data attributes:nil]) {  
	}
	else {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:YES] forKey:@"Cache"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (NSData*)readDataWithURL:(NSString*)url lastModifyDate:(NSDate**)modifiedDate {
	
	NSData *ret = nil;
	NSError *error = nil; 
	
	NSString* fileName = [[self cachePathFor:DATA] stringByAppendingPathComponent:[MZCache md5:url]];    
	if (modifiedDate)
		*modifiedDate = nil;
	
    ret = [NSData dataWithContentsOfFile:fileName];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:&error];  
    if (error) {
        NSLog(@"Error reading file attributes for: %@ - %@", url, [error localizedDescription]);
    }
    
    if (modifiedDate) {
        *modifiedDate = [fileAttributes fileModificationDate];
        NSLog(@"lastModifiedLocal : %@", *modifiedDate);
    }
	
	return ret;
}

+ (void)saveStringWithURL:(NSString*)url string:(NSString*)string modifyDate:(NSDate*)modifiedDate {
	
	if (string == nil)
		return;
	
	NSString* fileName = [[self cachePathFor:STRING] stringByAppendingPathComponent:[MZCache md5:url]];    
	if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
		return;
	
	if (![string writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil]) {  
	}
	else {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:YES] forKey:@"Cache"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (NSString*)readStringWithURL:(NSString*)url lastModifyDate:(NSDate**)modifiedDate {
	
	NSString *ret = nil;
	NSError *error = nil; 
	
	NSString* fileName = [[self cachePathFor:STRING] stringByAppendingPathComponent:[MZCache md5:url]]; 
	if (modifiedDate)
		*modifiedDate = nil;
	
    ret = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:&error];  
    
    if (error) {
        NSLog(@"Error reading file attributes for: %@ - %@", url, [error localizedDescription]);
    }
    
    if (modifiedDate) {
        *modifiedDate = [fileAttributes fileModificationDate];
        NSLog(@"lastModifiedLocal : %@", *modifiedDate);
    }
    return ret;
}

+ (NSString*) isCachedForURL:(NSString*)url withType:(int)type {
    
    if (type == PDF)
        url = [url stringByReplacingOccurrencesOfString:@"grid.mzine.my" withString:@"cdn.mzine.my"];

    NSString* fileName = [[self cachePathFor:type] stringByAppendingPathComponent:[MZCache md5:url]];    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
        return fileName;
    
    return nil;
}

+ (NSString*) cachePathForURL:(NSString*)url withType:(int)type {
    
    if (type == PDF)
        url = [url stringByReplacingOccurrencesOfString:@"grid.mzine.my" withString:@"cdn.mzine.my"];
    
    return [[self cachePathFor:type] stringByAppendingPathComponent:[MZCache md5:url]];
}

+ (BOOL) IsAlreadyCahedData {
	
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Cache"] intValue]) {
		return YES;
	}
	return NO;
}


+ (NSDate*) getModiftyDateIfUpdatedWithRequest:(NSMutableURLRequest*)request url:(NSString*)urlString error:(NSError**)error {

    NSFileManager *fileManager = [NSFileManager defaultManager];  
    NSString *lastModifiedString = nil;
	
	[request setHTTPMethod:@"HEAD"];
	
    NSHTTPURLResponse *response = nil;  
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: nil];  
    if ([response respondsToSelector:@selector(allHeaderFields)]) {  
        lastModifiedString = [[response allHeaderFields] objectForKey:@"Last-Modified"];  
    }
	else if (response == nil) {
		
		if (error != nil)
			*error = [NSError errorWithDomain:@"connection" code:0 userInfo:nil];
		return nil;
	}

	
    NSDate *lastModifiedServerDate = nil;
    @try {  
        NSDateFormatter *df = [[NSDateFormatter alloc] init];  
        df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";  
        df.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];  
        df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];  
        lastModifiedServerDate = [df dateFromString:lastModifiedString];  
		[df release];
    }  
    @catch (NSException * e) {  
        NSLog(@"Error parsing last modified date: %@ - %@", lastModifiedString, [e description]);  
    }  
    NSLog(@"lastModifiedServer: %@", lastModifiedServerDate);  
	
	NSString* fileName = [self md5:urlString];
    NSDate *lastModifiedLocalDate = nil;  
    if ([fileManager fileExistsAtPath:fileName]) {  
        NSError *error = nil;
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fileName error:&error];  
        if (error) {
            NSLog(@"Error reading file attributes for: %@ - %@", urlString, [error localizedDescription]);  
        }
		
        lastModifiedLocalDate = [fileAttributes fileModificationDate];  
        NSLog(@"lastModifiedLocal : %@", lastModifiedLocalDate);  
    }
	
    if (!lastModifiedLocalDate) {  
        return lastModifiedServerDate;
    }  

    if ([lastModifiedLocalDate laterDate:lastModifiedServerDate] == lastModifiedServerDate) {  
        return lastModifiedServerDate; 
    }
	
	return nil;
}


+ (NSDate*) getModiftyDateIfUpdated:(NSString*)urlString error:(NSError**)error{
	
    NSLog(@"Downloading HTTP header from: %@", urlString);  
    NSURL *url = [NSURL URLWithString:urlString];  
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];  
	
	return [self getModiftyDateIfUpdatedWithRequest:request url:urlString error:error];

}  

@end
