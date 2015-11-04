//
//  MapWhileLoading.h
//  Haze Route
//
//  Created by Pyay Han on 24/08/2015.
//

#import <UIKit/UIKit.h>
#import "GCGeocodingService.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapWhileLoading : UIViewController <GMSMapViewDelegate>

@property NSString* origin;
@property NSString*  destination;
@property BOOL selectShortestPath;
@property BOOL selectLowestExposure;
@property BOOL selectPointsPerMinute;

//@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (strong,nonatomic) GCGeocodingService *gs;

@end
