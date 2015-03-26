//
//  UserSetting.h
//  MySportalent
//
//  Created by Mountain on 6/4/13.
//  Copyright (c) 2013 Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSetting : NSObject

@property (nonatomic, readwrite) NSString      *user_id;

@property (nonatomic, strong) NSString          *sortName;
@property (nonatomic, strong) NSString          *orderName;
@property (nonatomic, strong) NSString          *refreshTime;
@property (nonatomic, strong) NSString          *mapping;

@property (nonatomic, readwrite) BOOL           bAssociate;
@property (nonatomic, readwrite) BOOL           bSyncAddress;





@end
