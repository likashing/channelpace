//
//  ContentsModel.h
//  SentisApp
//
//  Created by IThelp on 11/1/12.
//  Copyright (c) 2012 IThelp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBHandler : NSObject

@property (nonatomic,retain) NSMutableArray * contents;

- (void) insertMyContactsList: (NSMutableArray *) list;
- (NSMutableArray *) getMyContactsList: (NSMutableArray *)array orderby: (NSString *) orderby;
- (NSMutableArray *)searchMyContactsList:(NSMutableArray *)array keyword:(NSString *)keyword;
- (void) searchMyContactsListByCharacter:(NSMutableArray *)array keyword:(NSString *)keyword type:(BOOL)bFirstNameSearch keyvalue:(NSString *)keyvalue;

- (void) deleteAllMyContactsList;

@end
