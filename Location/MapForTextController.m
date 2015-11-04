//
//  MapForTextController.m
//  Location
//
//  Created by Pyay Han on 28/04/2015.
//

#import "MapForTextController.h"
#import "GCGeocodingService.h"
#import "MDDirectionService.h"
#import "MKPolyline+GMEncodedString.h"
#import "MKPolyline+countPoints.h"

static NSString * const BaseURLString = @"http://www.hazewatch.unsw.edu.au/get-data.php";
static float NUMBER_OF_CO_POINTS = 10.0;
static NSUInteger ROUTE_1 = 0;
static NSUInteger ROUTE_2 = 1;
static NSUInteger ROUTE_3 = 2;
static float lengthA;
static float lengthB;
static float lengthC;
static float RIDICULOUSLY_HIGH_CO = 999999;
static float RIDICULOUSLY_LONG_DISTANCE = 999999;
static float RIDICULOUSLY_LONG_TIME = 3600000000000;
static float distanceForRouteA;
static float distanceForRouteB;
static float distanceForRouteC;
static float timeForRouteA;
static float timeForRouteB;
static float timeForRouteC;
static float shortestDistance;
static float shortestTime;
static float distanceOfHealthyRoute;
static float timeOfHealthyRoute;
static float shortestDistanceExposure;
static float healthyRouteExposure;
static int   progressCount;

float totalCoA;
float totalCoB;
float totalCoC;
float exposureA;
float exposureB;
float exposureC;

static NSString *infoMessage = @"No info.";

@interface MapForTextController () {
GMSMapView *mapView_;
GMSPolyline *polylineA;
GMSPolyline *polylineB;
GMSPolyline *polylineC;
NSMutableArray *waypoints_;
NSMutableArray *waypointStrings_;
    
double originLat;
double originLng;
double destLat;
double destLng;
}
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation MapForTextController
@synthesize gs;


- (IBAction)InfoButton:(id)sender {
    UIAlertView *info = [[UIAlertView alloc] initWithTitle:@"Route Information" message:infoMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [info show];
}



- (void)addDirections:(NSDictionary *)json {
    
    //[self.activityIndicatorView startAnimating];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd%20HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"date: %@", dateString);
    
    NSLog(@"\n\n\n\n\n\nCurrent time is: %@\n\n\n\n", dateString);
    
    
    NSUInteger numberOfRoutes = [[json objectForKey:@"routes"] count];
    
    
    //Shit. We need to redefine the allocation of these.
    float *coA = (float*) malloc(sizeof(float)*NUMBER_OF_CO_POINTS);
    NSLog(@"Size of coA alloc is: %lu\n", sizeof(*coA));
    
    float *coB = (float*) malloc(sizeof(float)*NUMBER_OF_CO_POINTS);
    float *coC = (float*) malloc(sizeof(float)*NUMBER_OF_CO_POINTS);
    *coA = RIDICULOUSLY_HIGH_CO;
    *coB = RIDICULOUSLY_HIGH_CO;
    *coC = RIDICULOUSLY_HIGH_CO;
    
    NSLog(@"*coA first element is: %f\n", *coA);
    
    NSDictionary *routesA = [json objectForKey:@"routes"][0];
    NSDictionary *routeA = [routesA objectForKey:@"overview_polyline"];
    NSString *overview_routeA = [routeA objectForKey:@"points"];
    NSArray *stepsForA = json[@"routes"][ROUTE_1][@"legs"][0][@"steps"];
    NSUInteger numberOfStepsForA = [stepsForA count];
    distanceForRouteA = 0;
    timeForRouteA = 0;
    totalCoA = 0;
    
    for(int i=0; i< numberOfStepsForA; i++) {
        distanceForRouteA += [stepsForA[i][@"distance"][@"value"] floatValue];
        
        timeForRouteA += [stepsForA[i][@"duration"][@"value"] floatValue];
        }
    shortestTime = timeForRouteA;
    
    float *allPoints = [MKPolyline polylineWithGMEncodedString:overview_routeA];
    lengthA = [MKPolyline count:overview_routeA];
    
    

    //Need to reallocate coA for these.
    NSUInteger pointFactor = (lengthA*2)/NUMBER_OF_CO_POINTS;
    int timeForRouteAminutes = (int) (timeForRouteA/60 + 0.5);
    
    if (_selectPointsPerMinute) {
        pointFactor = (lengthA*2)/timeForRouteAminutes;
        coA = realloc(coA, sizeof(float)*timeForRouteAminutes);
        NSLog(@"Size of coA realloc is: %lu\n", sizeof(*coA));
        
    }
    
    
    NSLog(@"pointFactor A = %tu\n", pointFactor);
    NSLog(@"length A = %f\n", lengthA);
    
    
    if(pointFactor %2 != 0)
        pointFactor--;
    int coIndex = 0;
    if(_selectLowestExposure){
    for(int i=0; i<lengthA*2;i=i+2){
        if(i%pointFactor ==0 && i !=0){
            NSString *stringPollution = [NSString stringWithFormat:@"%@?latitudes=%f&longitudes=%f&datetimes=%@&pollutants=co",BaseURLString, allPoints[i], allPoints[i+1], @"2015-10-22%2019:17:28"];
            NSURL *urlPollution = [NSURL URLWithString:stringPollution];
            NSData *pollutionData = [NSData dataWithContentsOfURL:urlPollution];
        
            NSString *myString = [[NSString alloc] initWithData:pollutionData
                                                   encoding:NSUTF8StringEncoding];
        
            NSString *valueString = [myString componentsSeparatedByString:@"="][1];
            float co = [valueString floatValue];
            coA[coIndex++] = co;
            NSLog(@"CoA = %f\n", co);
        }
    }
    }
    
    GMSPath *pathA = [GMSPath pathFromEncodedPath:overview_routeA];
    polylineA = [GMSPolyline polylineWithPath:pathA];
    
    for(int i = 0; i < NUMBER_OF_CO_POINTS; i++) {
        totalCoA += coA[i];
    }

    
    if (ROUTE_2 < numberOfRoutes){
        NSDictionary *routesB = [json objectForKey:@"routes"][1];
        NSDictionary *routeB = [routesB objectForKey:@"overview_polyline"];
        NSString *overview_routeB = [routeB objectForKey:@"points"];
        NSArray *stepsForB = json[@"routes"][ROUTE_2][@"legs"][0][@"steps"];
        NSUInteger numberOfStepsForB = [stepsForB count];
        distanceForRouteB = 0;
        timeForRouteB = 0;
        totalCoB = 0;
        
        for(int i=0; i< numberOfStepsForB; i++) {
            distanceForRouteB += [stepsForB[i][@"distance"][@"value"] floatValue];
            
            timeForRouteB += [stepsForB[i][@"duration"][@"value"] floatValue];
            
        }
        
        if(timeForRouteB < shortestTime)
            shortestTime = timeForRouteB;
        
        
    
        float *allPointsB = [MKPolyline polylineWithGMEncodedString:overview_routeB];
        lengthB = (float)[MKPolyline count:overview_routeB];
    
        NSUInteger pointFactorB = (NSUInteger)((lengthB*2)/NUMBER_OF_CO_POINTS)*(shortestTime/timeForRouteB);
        
        int timeForRouteBminutes = (int) (timeForRouteB/60 +0.5);
        if (_selectPointsPerMinute) {
            pointFactorB = (int)(lengthB*2)/timeForRouteBminutes;
            coB = realloc(coB, sizeof(float)*timeForRouteBminutes);
        }
        
        NSLog(@"shortestTime/timeForRouteB: %f\n", shortestTime/timeForRouteB);
        
        NSLog(@"length B = %f\n", lengthB);
        NSLog(@"pointFactor B = %tu\n", pointFactorB);
        
        if(pointFactorB %2 != 0)
            pointFactorB--;
        int coIndexB = 0;
        if(_selectLowestExposure){
            for(int i=0; i<lengthB*2;i=i+2){
                
                if(i%pointFactorB ==0 && i !=0){
                    NSString *stringPollution = [NSString stringWithFormat:@"%@?latitudes=%f&longitudes=%f&datetimes=%@&pollutants=co",BaseURLString, allPointsB[i], allPointsB[i+1],@"2015-10-22%2019:17:28"];
                    
                    NSLog(@"POLLUTION STRING: %@", stringPollution);
                    NSURL *urlPollution = [NSURL URLWithString:stringPollution];
                    NSData *pollutionData = [NSData dataWithContentsOfURL:urlPollution];
            
                    NSString *myString = [[NSString alloc] initWithData:pollutionData
                                                       encoding:NSUTF8StringEncoding];
            
                    NSString *valueString = [myString componentsSeparatedByString:@"="][1];
                    float coValue = [valueString floatValue];
                    coB[coIndexB++] = coValue;
                    NSLog(@"CoB = %f\n", coValue);
                }
            }
        }
    
    
    GMSPath *pathB = [GMSPath pathFromEncodedPath:overview_routeB];
    polylineB = [GMSPolyline polylineWithPath:pathB];
        
        
    for(int i = 0; i < (int)NUMBER_OF_CO_POINTS*(timeForRouteB/shortestTime); i++) {
        totalCoB += coB[i];
    }
        
    } else {
        distanceForRouteB = RIDICULOUSLY_LONG_DISTANCE;
        timeForRouteB = RIDICULOUSLY_LONG_TIME;
        totalCoB = RIDICULOUSLY_HIGH_CO;
    }
    
    if (ROUTE_3 < numberOfRoutes) {
        NSDictionary *routesC = [json objectForKey:@"routes"][2];
        NSDictionary *routeC = [routesC objectForKey:@"overview_polyline"];
        NSString *overview_routeC = [routeC objectForKey:@"points"];
        
        NSArray *stepsForC = json[@"routes"][ROUTE_3][@"legs"][0][@"steps"];
        NSUInteger numberOfStepsForC = [stepsForC count];
        distanceForRouteC = 0;
        timeForRouteC = 0;
        totalCoC = 0;
        
        for(int i=0; i< numberOfStepsForC; i++) {
            distanceForRouteC += [stepsForC[i][@"distance"][@"value"] floatValue];
            
            timeForRouteC += [stepsForC[i][@"duration"][@"value"] floatValue];
            
        }
        
        if(timeForRouteC < shortestTime)
            shortestTime = timeForRouteC;
    
        float *allPointsC = [MKPolyline polylineWithGMEncodedString:overview_routeC];
        lengthC = [MKPolyline count:overview_routeC];
        
        //float *coC = (float*) malloc(sizeof(float)*NUMBER_OF_CO_POINTS);
        NSUInteger pointFactorC = (NSUInteger)((lengthC*2)/NUMBER_OF_CO_POINTS)*(shortestTime/timeForRouteC);
        
        int timeForRouteCminutes = (int) (timeForRouteC/60 + 0.5);
        if (_selectPointsPerMinute) {
            pointFactorC = (lengthC*2)/timeForRouteCminutes;
            coC = realloc(coC, sizeof(float)*timeForRouteCminutes);
        }
        

        NSLog(@"shortestTime/timeForRouteC: %f\n", shortestTime/timeForRouteC);
        NSLog(@"length C = %f\n", lengthC);
        NSLog(@"pointFactor C = %tu\n", pointFactorC);
        if(pointFactorC %2 != 0)
            pointFactorC--;
        int coIndexC = 0;
        if(_selectLowestExposure){
            for(int i=0; i<lengthC*2;i=i+2){
                if(i%pointFactorC ==0 && i !=0){
                    NSString *stringPollution = [NSString stringWithFormat:@"%@?latitudes=%f&longitudes=%f&datetimes=%@&pollutants=co",BaseURLString, allPointsC[i], allPointsC[i+1], @"2015-10-22%2019:17:28"];
                    NSURL *urlPollution = [NSURL URLWithString:stringPollution];
                    NSData *pollutionData = [NSData dataWithContentsOfURL:urlPollution];
            
                    NSString *myString = [[NSString alloc] initWithData:pollutionData
                                                       encoding:NSUTF8StringEncoding];
            
                    NSString *valueString = [myString componentsSeparatedByString:@"="][1];
                    float coValue = [valueString floatValue];
                    coC[coIndexC++] = coValue;
                    NSLog(@"CoC = %f\n", coValue);
                }
            }
        }
    
    GMSPath *pathC = [GMSPath pathFromEncodedPath:overview_routeC];
    polylineC = [GMSPolyline polylineWithPath:pathC];

        
    for(int i = 0; i < (int)NUMBER_OF_CO_POINTS*(timeForRouteC/shortestTime); i++) {
        totalCoC += coC[i];
    }
        
    } else {
        distanceForRouteC = RIDICULOUSLY_LONG_DISTANCE;
        timeForRouteC = RIDICULOUSLY_LONG_TIME;
        totalCoC = RIDICULOUSLY_HIGH_CO;
    }
    


    exposureA = totalCoA * 1.145*12;
    exposureB = totalCoB * 1.145*12;
    exposureC = totalCoC * 1.145*12;
    
    
    polylineA.strokeColor = [UIColor yellowColor];
    polylineA.map = mapView_;
    polylineB.strokeColor = [UIColor yellowColor];
    polylineB.map = mapView_;
    polylineC.strokeColor = [UIColor yellowColor];
    polylineC.map = mapView_;
    
    
    NSLog(@"\n\n\n\n\n");
    NSLog(@"Time For Route A: %f\n", timeForRouteA);
    NSLog(@"Time For Route B: %f\n", timeForRouteB);
    NSLog(@"Time For Route C: %f\n", timeForRouteC);
    NSLog(@"\n\n\n\n\n");
    
    //Draw FASTEST path
    if(_selectShortestPath) {
        if (timeForRouteA < timeForRouteB && timeForRouteA < timeForRouteC){
            polylineA.strokeColor = [UIColor redColor];
            polylineA.strokeWidth = 5.f;
            polylineA.map = mapView_;
            shortestDistance = distanceForRouteA;
            shortestTime = timeForRouteA;
            shortestDistanceExposure = exposureA;
        } else if (timeForRouteB < timeForRouteA && timeForRouteB < timeForRouteC){
            polylineB.strokeColor = [UIColor redColor];
            polylineB.strokeWidth = 5.f;
            polylineB.map = mapView_;
            shortestDistance = distanceForRouteB;
            shortestTime = timeForRouteB;
            shortestDistanceExposure = exposureB;
        } else if (timeForRouteC < timeForRouteA && timeForRouteC < timeForRouteB){
            polylineC.strokeColor = [UIColor redColor];
            polylineC.strokeWidth = 5.f;
            polylineC.map = mapView_;
            shortestDistance = distanceForRouteC;
            shortestTime = timeForRouteC;
            shortestDistanceExposure = exposureC;
        }
    }
    
    
    
    //Draw least pollution exposure path
    if (_selectLowestExposure){
        if (exposureA < exposureB && exposureA < exposureC){
            polylineA.strokeColor = [UIColor greenColor];
            polylineA.strokeWidth = 4.f;
            polylineA.map = mapView_;
            distanceOfHealthyRoute = distanceForRouteA;
            timeOfHealthyRoute = timeForRouteA;
            healthyRouteExposure = exposureA;
        } else if (exposureB < exposureA && exposureB < exposureC){
            polylineB.strokeColor = [UIColor greenColor];
            polylineB.strokeWidth = 4.f;
            polylineB.map = mapView_;
            distanceOfHealthyRoute = distanceForRouteB;
            timeOfHealthyRoute = timeForRouteB;
            healthyRouteExposure = exposureB;
        } else if (exposureC < exposureA && exposureC < exposureB){
            polylineC.strokeColor = [UIColor greenColor];
            polylineC.strokeWidth = 4.f;
            polylineC.map = mapView_;
            distanceOfHealthyRoute = distanceForRouteC;
            timeOfHealthyRoute = timeForRouteC;
            healthyRouteExposure = exposureC;
        }
    }
    

    NSLog(@"TotalCoA = %f\n", totalCoA);
    NSLog(@"TotalCoB = %f\n", totalCoB);
    NSLog(@"TotalCoC = %f\n", totalCoC);
    NSLog(@"lengthA = %lu\n", (unsigned long)lengthA);
    NSLog(@"lengthB = %lu\n", (unsigned long)lengthB);
    NSLog(@"lengthC = %lu\n", (unsigned long)lengthC);
    NSLog(@"Distance of A = %.2f m\n", distanceForRouteA);
    NSLog(@"Distance of B = %.2f m\n", distanceForRouteB);
    NSLog(@"Distance of C = %.2f m\n", distanceForRouteC);
    NSLog(@"healthy Route Exposure: %f\n",healthyRouteExposure);
    NSLog(@"shortest Distance Exposure: %f\n", shortestDistanceExposure);
    float percentLessExposure = (1 - healthyRouteExposure/shortestDistanceExposure)*100;
    /*infoMessage = [NSString stringWithFormat:@"Shortest path (red) \n %.2f km\n\nHealth Optimal Route (green)\n%.2f km longer\n %.2f %% less pollution exposure", shortestDistance, (distanceOfHealthyRoute - shortestDistance), percentMoreExposure];*/
    
    
    infoMessage = [NSString stringWithFormat:@"Lowest Exposure Route (Green Curve)\nDistance: %.2f km\nTravel Time: %.1f mins\nExposure: %.2f %% less than fastest route\n\nFastest Route (Red Curve)\nDistance: %.2f km\nTravel Time: %.1f mins", distanceOfHealthyRoute/1000.0, timeOfHealthyRoute/60.0, percentLessExposure, shortestDistance/1000.0, shortestTime/60.0];
}


- (void)loadView {
    [super loadView];
    
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.917
                                                            longitude:151.231
                                                                 zoom:11];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    
    gs = [[GCGeocodingService alloc] init];
    SEL sel = @selector(addMarker);
    [gs geocodeAddress:_origin withCallback:@selector(addMarkerOrigin) withDelegate:self];
    [gs geocodeAddress:_destination withCallback:@selector(addMarkerDest) withDelegate:self];
    
    CGRect frame = CGRectMake (120.0, 185.0, 80, 80);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [self.activityIndicatorView setColor:[UIColor colorWithRed:1 green:0.0 blue:0.0 alpha:1.0]];
    self.activityIndicatorView.transform = CGAffineTransformMakeScale(2, 2);
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    NSLog(@"LOADview");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    /*
    CGRect frame = CGRectMake (120.0, 185.0, 80, 80);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [self.activityIndicatorView setColor:[UIColor colorWithRed:1 green:0.0 blue:0.0 alpha:1.0]];
    self.activityIndicatorView.transform = CGAffineTransformMakeScale(2, 2);
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    */
    
    self.title = @"Map View";

    /*
    gs = [[GCGeocodingService alloc] init];
    
    SEL sel = @selector(addMarker);
    
    NSLog(@"viewDIDload");
    [gs geocodeAddress:_origin withCallback:@selector(addMarkerOrigin) withDelegate:self];
    
    [gs geocodeAddress:_destination withCallback:@selector(addMarkerDest) withDelegate:self];
    */
}


- (void)addMarkerOrigin {
    
    double lat = [[gs.geocode objectForKey:@"lat"] doubleValue];
    double lng = [[gs.geocode objectForKey:@"lng"] doubleValue];

    originLat = lat;
    destLat = lng;
    
    CLLocationCoordinate2D start = CLLocationCoordinate2DMake(
                                                               lat,
                                                               lng);
    GMSMarker *startMarker = [GMSMarker markerWithPosition:start];
    startMarker.map = mapView_;
    
    [waypoints_ addObject:startMarker];
    
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                lat,lng];
    [waypointStrings_ addObject:positionString];
}

- (void)addMarkerDest {
    
    double lat = [[gs.geocode objectForKey:@"lat"] doubleValue];
    double lng = [[gs.geocode objectForKey:@"lng"] doubleValue];
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                 lat,
                                                                 lng);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = mapView_;
    [waypoints_ addObject:marker];
    
    NSString *positionStringDest = [[NSString alloc] initWithFormat:@"%f,%f",
                                    lat,lng];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated{
    CGRect frame = CGRectMake (120.0, 185.0, 80, 80);
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    //self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setColor:[UIColor colorWithRed:1 green:0.0 blue:0.0 alpha:1.0]];
    self.activityIndicatorView.transform = CGAffineTransformMakeScale(2, 2);
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.activityIndicatorView stopAnimating];
}
@end
