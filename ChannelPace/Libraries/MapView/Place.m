//
//  Place.m
//  Miller
//
//  Created by kadir pekel on 2/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Place.h"


@implementation Place

@synthesize name;
@synthesize description;
@synthesize latitude;
@synthesize longitude;
@synthesize street;

- (void) dealloc
{
	[name release];
    [street release];
	[description release];
	[super dealloc];
}

@end
