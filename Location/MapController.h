//
//  MapController.h
//  Location
//
//  Created by Pyay Han on 2/04/2015.


#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapController : UIViewController <GMSMapViewDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *labelLongitude;

@property double latitude;
@property double  longitude;
@end

