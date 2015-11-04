//
//  MapController.m
//  Location
//
//  Created by Pyay Han on 2/04/2015.
//  Copyright (c) 2015. All rights reserved.
//
#import "MapController.h"
#import "MDDirectionService.h"

@interface MapController () {
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
}
@end


@implementation MapController

- (void)loadView {
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_latitude
                                                            longitude:_longitude
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    
    CLLocationCoordinate2D origin = CLLocationCoordinate2DMake(
                                                                 _latitude,
                                                                 _longitude);
    GMSMarker *startMarker = [GMSMarker markerWithPosition:origin];
    startMarker.map = mapView_;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:
(CLLocationCoordinate2D)coordinate {
    [mapView_ clear];
    
    CLLocationCoordinate2D origin = CLLocationCoordinate2DMake(
                                                               _latitude,
                                                               _longitude);
    GMSMarker *startMarker = [GMSMarker markerWithPosition:origin];
    startMarker.map = mapView_;
    [waypoints_ addObject:startMarker];
   
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                _latitude,_longitude];
    [waypointStrings_ addObject:positionString];
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                 coordinate.latitude,
                                                                 coordinate.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = mapView_;
    [waypoints_ addObject:marker];

    
    NSString *positionStringDest = [[NSString alloc] initWithFormat:@"%f,%f",
                                coordinate.latitude,coordinate.longitude];
    [waypointStrings_ addObject:positionStringDest];
    if([waypoints_ count]>1){
        NSString *sensor = @"false";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                          forKeys:keys];
        MDDirectionService *mds=[[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}
- (void)addDirections:(NSDictionary *)json {
    
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 5.f;
    polyline.map = mapView_;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Tap View";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

