//
//  FindCompanyViewController.h
//  ChannelPace
//
//  Created by Eagle on 12/14/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "JSONKit.h"
#import <GoogleMaps/GoogleMaps.h>



@interface FindCompanyViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, GMSMapViewDelegate>
{
    BOOL isZoom;
    CLLocationManager *locmanager;
    
}


@property (strong, nonatomic) IBOutlet GMSMapView *gmsMapView;

@property (strong, nonatomic) MapView* mapViewApple;
@property (nonatomic, strong) GMSMapView *mapViewGoogle;
@property (strong, nonatomic) Place *company;
@property (strong, nonatomic) Place *currentPlace;
@property (strong, nonatomic) NSDate  *lastPetition;

- (IBAction)onBackBtn:(id)sender;


@end
