//
//  ViewController.h
//  Location
//
//  Created by Pyay Han

#import <UIKit/UIKit.h>
#import "MapController.h"

@interface ViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

- (IBAction) saveHistory;

@property (nonatomic, retain)	NSMutableArray	*origins;
@property (nonatomic, retain)	NSMutableArray	*destinations;

@end
