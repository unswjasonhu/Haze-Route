//
//  MapForTextController.h
//  Location
//
//  Created by Pyay Han on 28/04/2015.


#import <UIKit/UIKit.h>
#import "GCGeocodingService.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapForTextController : UIViewController <GMSMapViewDelegate>

@property NSString* origin;
@property NSString*  destination;
@property BOOL selectShortestPath;
@property BOOL selectLowestExposure;
@property BOOL selectPointsPerMinute;


@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
//@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *myTimer;
@property (strong,nonatomic) GCGeocodingService *gs;


@end

