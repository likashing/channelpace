//
//  FindCompanyViewController.m
//  ChannelPace
//
//  Created by Eagle on 12/14/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "FindCompanyViewController.h"
#import "AppDelegate.h"
#import "ContactCardViewController.h"
#import <MapKit/MapKit.h>
#import "SVAnnotation.h"
#import "SVPulsingAnnotationView.h"



@interface FindCompanyViewController ()

@end

@implementation FindCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([APPDELEGATE.userSettingObj.mapping isEqual:@"Apple"]) {
        [self initAppleMap];
    } else if ([APPDELEGATE.userSettingObj.mapping isEqual:@"Google"]) {
        [self initGoogleMap];
    }
    
}


#pragma  mark AppleMap View Proc

- (void) initAppleMap
{
    isZoom = YES;
    _mapViewApple = [[MapView alloc] initWithFrame:
                CGRectMake(0, 75, self.view.frame.size.width,self.view.frame.size.height-75)] ;
    [self.view addSubview:_mapViewApple];
    
    CLLocationCoordinate2D position = [self getLocationFromAddressString:APPDELEGATE.companyAddress];
    
    _currentPlace = [[Place alloc] init] ;
    _currentPlace.latitude = position.latitude;
    _currentPlace.longitude = position.longitude;
    
    _company = [[Place alloc] init];
    _company.name = APPDELEGATE.companyName;
    _company.description = [NSString stringWithFormat:@"%@, %@", APPDELEGATE.companyStreet, APPDELEGATE.companyAddress];
    _company.latitude = position.latitude;
    _company.longitude = position.longitude;
    
    locmanager = [[CLLocationManager alloc] init];
    locmanager.delegate = self;
    [locmanager startUpdatingLocation];
    
    [self performSelector:@selector(getRoute) withObject:nil afterDelay:0.1f];

}
- (void)getRoute
{
    [_mapViewApple showRouteFrom:_company to:_company];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _currentPlace.latitude = currentLocation.coordinate.latitude;
        _currentPlace.longitude = currentLocation.coordinate.longitude;
    }
    [locmanager stopUpdatingLocation];
}




- (IBAction)onBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//////////////////////////
/// Google Map

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}


#pragma mark GoogleMap View Proc

- (void) initGoogleMap
{
    _gmsMapView.delegate = self;
    CLLocationCoordinate2D position = [self getLocationFromAddressString:APPDELEGATE.companyAddress];
    
    _gmsMapView.camera = [GMSCameraPosition cameraWithLatitude:position.latitude longitude:position.longitude zoom:8];
    
    _gmsMapView.myLocationEnabled = YES;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(position.latitude, position.longitude);
    marker.title = APPDELEGATE.companyName;
    marker.snippet = [NSString stringWithFormat:@"%@, %@", APPDELEGATE.companyStreet, APPDELEGATE.companyAddress];
    marker.map = _gmsMapView;
    
    
}



@end
