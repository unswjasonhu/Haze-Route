//
//  MapWhileLoading.m
//  Haze Route
//
//  Created by Pyay Han on 24/08/2015.
//

#import "MapWhileLoading.h"
#import "MapForTextController.h"
#import "GCGeocodingService.h"
#import "MDDirectionService.h"
#import "MKPolyline+GMEncodedString.h"
#import "MKPolyline+countPoints.h"


@interface MapWhileLoading () {
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    
    double originLat;
    double originLng;
    double destLat;
    double destLng;
}

@end

@implementation MapWhileLoading
@synthesize gs;

- (void)loadView {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.917
                                                            longitude:151.231
                                                                 zoom:11];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.917
                                                            longitude:151.231
                                                                 zoom:11];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    
}

@end
