#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "Samples.h"

// Map Demos
#import "BasicMapViewController.h"
#import "CustomIndoorViewController.h"
#import "DoubleMapViewController.h"
#import "GestureControlViewController.h"
#import "IndoorMuseumNavigationViewController.h"
#import "IndoorViewController.h"
#import "MapTypesViewController.h"
#import "MapZoomViewController.h"
#import "MyLocationViewController.h"
#import "TrafficMapViewController.h"
#import "VisibleRegionViewController.h"

// Panorama Demos
#import "FixedPanoramaViewController.h"
#import "PanoramaViewController.h"

// Overlay Demos
#import "AnimatedCurrentLocationViewController.h"
#import "CustomMarkersViewController.h"
#import "GradientPolylinesViewController.h"
#import "GroundOverlayViewController.h"
#import "MarkerEventsViewController.h"
#import "MarkerInfoWindowViewController.h"
#import "MarkerLayerViewController.h"
#import "MarkersViewController.h"
#import "PolygonsViewController.h"
#import "PolylinesViewController.h"
#import "TileLayerViewController.h"

// Camera Demos
#import "CameraViewController.h"
#import "FitBoundsViewController.h"
#import "MapLayerViewController.h"

// Services
#import "GeocoderViewController.h"
#import "StructuredGeocoderViewController.h"

@implementation Samples

+ (NSArray *)loadSections {
  return @[ @"Map", @"Panorama", @"Overlays", @"Camera", @"Services" ];
}

+ (NSArray *)loadDemos {
  NSArray *mapDemos =
  @[[self newDemo:[BasicMapViewController class]
        withTitle:@"Basic Map"
   andDescription:nil],
    [self newDemo:[MapTypesViewController class]
        withTitle:@"Map Types"
   andDescription:nil],
    [self newDemo:[TrafficMapViewController class]
        withTitle:@"Traffic Layer"
   andDescription:nil],
    [self newDemo:[MyLocationViewController class]
        withTitle:@"My Location"
   andDescription:nil],
    [self newDemo:[IndoorViewController class]
        withTitle:@"Indoor"
   andDescription:nil],
    [self newDemo:[CustomIndoorViewController class]
        withTitle:@"Indoor with Custom Level Select"
   andDescription:nil],
    [self newDemo:[IndoorMuseumNavigationViewController class]
        withTitle:@"Indoor Museum Navigator"
   andDescription:nil],
    [self newDemo:[GestureControlViewController class]
        withTitle:@"Gesture Control"
   andDescription:nil],
    [self newDemo:[DoubleMapViewController class]
        withTitle:@"Two Maps"
   andDescription:nil],
    [self newDemo:[VisibleRegionViewController class]
        withTitle:@"Visible Regions"
   andDescription:nil],
    [self newDemo:[MapZoomViewController class]
        withTitle:@"Min/Max Zoom"
   andDescription:nil],
  ];

  NSArray *panoramaDemos =
  @[[self newDemo:[PanoramaViewController class]
        withTitle:@"Street View"
   andDescription:nil],
    [self newDemo:[FixedPanoramaViewController class]
        withTitle:@"Fixed Street View"
   andDescription:nil]];

  NSArray *overlayDemos =
  @[[self newDemo:[MarkersViewController class]
        withTitle:@"Markers"
   andDescription:nil],
    [self newDemo:[CustomMarkersViewController class]
        withTitle:@"Custom Markers"
   andDescription:nil],
    [self newDemo:[MarkerEventsViewController class]
        withTitle:@"Marker Events"
   andDescription:nil],
    [self newDemo:[MarkerLayerViewController class]
        withTitle:@"Marker Layer"
   andDescription:nil],
    [self newDemo:[MarkerInfoWindowViewController class]
        withTitle:@"Custom Info Windows"
   andDescription:nil],
    [self newDemo:[PolygonsViewController class]
        withTitle:@"Polygons"
   andDescription:nil],
    [self newDemo:[PolylinesViewController class]
        withTitle:@"Polylines"
   andDescription:nil],
    [self newDemo:[GroundOverlayViewController class]
        withTitle:@"Ground Overlays"
   andDescription:nil],
    [self newDemo:[TileLayerViewController class]
        withTitle:@"Tile Layers"
   andDescription:nil],
    [self newDemo:[AnimatedCurrentLocationViewController class]
        withTitle:@"Animated Current Location"
   andDescription:nil],
    [self newDemo:[GradientPolylinesViewController class]
        withTitle:@"Gradient Polylines"
   andDescription:nil]];

  NSArray *cameraDemos =
  @[[self newDemo:[FitBoundsViewController class]
        withTitle:@"Fit Bounds"
   andDescription:nil],
    [self newDemo:[CameraViewController class]
        withTitle:@"Camera Animation"
   andDescription:nil],
    [self newDemo:[MapLayerViewController class]
        withTitle:@"Map Layer"
   andDescription:nil]];

  NSArray *servicesDemos =
  @[[self newDemo:[GeocoderViewController class]
        withTitle:@"Geocoder"
   andDescription:nil],
    [self newDemo:[StructuredGeocoderViewController class]
        withTitle:@"Structured Geocoder"
   andDescription:nil],
  ];

  return @[mapDemos, panoramaDemos, overlayDemos, cameraDemos, servicesDemos];
}

+ (NSDictionary *)newDemo:(Class) class
                withTitle:(NSString *)title
           andDescription:(NSString *)description {
  return [[NSDictionary alloc] initWithObjectsAndKeys:class, @"controller",
          title, @"title", description, @"description", nil];
}
@end
