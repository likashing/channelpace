//
//  MapViewController.m
//  Miller
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapView.h"

@interface MapView()

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t ;
-(void) updateRouteView;
-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) from to: (CLLocationCoordinate2D) to;
-(void) centerMap;

@end

@implementation MapView

//@synthesize lineColor;
@synthesize mapView;
- (id) initWithFrame:(CGRect) frame
{
	self = [super initWithFrame:frame];
	if (self != nil) {
        isZoom = YES;
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		mapView.showsUserLocation = YES;
		[mapView setDelegate:self];
		[self addSubview:mapView];
		routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
		routeView.userInteractionEnabled = NO;
		[mapView addSubview:routeView];
		
//		self.lineColor = [UIColor colorWithWhite:0.2 alpha:0.5];
	}
	return self;
}

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D) t {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[[NSNumber alloc] initWithFloat:lat * 1e-5] autorelease];
		NSNumber *longitude = [[[NSNumber alloc] initWithFloat:lng * 1e-5] autorelease];
		printf("[%f,", [latitude doubleValue]);
		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] autorelease];
		[array addObject:loc];
	}
    CLLocation *first = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:f.latitude] floatValue] longitude:[[NSNumber numberWithFloat:f.longitude] floatValue] ] autorelease];
    CLLocation *end = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:t.latitude] floatValue] longitude:[[NSNumber numberWithFloat:t.longitude] floatValue] ] autorelease];
	[array insertObject:first atIndex:0];
    [array addObject:end];
	return array;
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
    
//    CLLocationCoordinate2D position = [self getLocationFromAddressString:APPDELEGATE.companyAddress];
//    f.latitude = -37.;
//    f.longitude = 145.;
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
    //saddr = [NSString stringWithFormat:@"%f,%f", -37., 145.];
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	NSLog(@"api url: %@", apiUrl);
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSUTF8StringEncoding error:nil];//[NSString stringWithContentsOfURL:apiUrl];
    
	NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
    NSLog(@"%@", [self decodePolyLine:[encodedPoints mutableCopy]:f to:t]);
	return [self decodePolyLine:[encodedPoints mutableCopy]:f to:t];
}

-(void) centerMap {

	MKCoordinateRegion region;

	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	for(int idx = 0; idx < routes.count; idx++)
	{
		CLLocation* currentLocation = [routes objectAtIndex:idx];
		if(currentLocation.coordinate.latitude > maxLat)
			maxLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.latitude < minLat)
			minLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.longitude > maxLon)
			maxLon = currentLocation.coordinate.longitude;
		if(currentLocation.coordinate.longitude < minLon)
			minLon = currentLocation.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + 0.018;
	region.span.longitudeDelta = maxLon - minLon + 0.018;

	[mapView setRegion:region animated:YES];
}

-(void) showRouteFrom: (Place*) f to:(Place*) t {
	
	if(routes) {
		[mapView removeAnnotations:[mapView annotations]];
		[routes release];
	}
    
	
	PlaceMark* from = [[[PlaceMark alloc] initWithPlace:t] autorelease];
	PlaceMark* to = [[[PlaceMark alloc] initWithPlace:t] autorelease];
	
//	[mapView addAnnotation:from];
	[mapView addAnnotation:to];
	
	routes = [[self calculateRoutesFrom:from.coordinate to:to.coordinate] retain];
	[self updateRouteView];
	[self centerMap];
}



-(void) updateRouteView {
    [mapView removeOverlays:mapView.overlays];

    CLLocationCoordinate2D pointsToUse[[routes count]];
    for (int i = 0; i < [routes count]; i++) {
        CLLocationCoordinate2D coords;
        CLLocation *loc = [routes objectAtIndex:i];
        coords.latitude = loc.coordinate.latitude;
        coords.longitude = loc.coordinate.longitude;
        pointsToUse[i] = coords;
    }
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:[routes count]];
    [mapView addOverlay:lineOne];
}

#pragma mark mapView delegate functions
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview=[[MKPolylineView alloc] initWithOverlay:overlay] ;
        
        lineview.strokeColor=[UIColor colorWithRed:69.0f/255.0f green:212.0f/255.0f blue:255.0f/255.0f alpha:0.01];
        lineview.lineWidth=1.0;
        return lineview;
    }
    return nil;
}

- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion region;
    
    region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(.9f , .9f));
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:region];
    [mapView setRegion:adjustedRegion animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = userLocation.location.coordinate.latitude;
    coordinate.longitude = userLocation.location.coordinate.longitude;
    if (isZoom) {
        [self setMapRegionWithCoordinate:coordinate];
        isZoom = NO;
    }
}

/////////////////////////////


- (void)dealloc {
	if(routes) {
		[routes release];
	}
	[mapView release];
	[routeView release];
    [super dealloc];
}

@end
