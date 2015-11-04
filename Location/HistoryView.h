//
//  HistoryView.h
//  Haze Route
//
//  Created by Pyay Han on 13/10/2015.
//  Copyright © 2015 PJ Vea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryView : UIViewController {

    IBOutlet UILabel *origin0;
    IBOutlet UILabel *origin1;
    IBOutlet UILabel *origin2;
    IBOutlet UILabel *origin3;
    IBOutlet UILabel *origin4;
    IBOutlet UILabel *origin5;
    IBOutlet UILabel *origin6;
    IBOutlet UILabel *origin7;
    IBOutlet UILabel *origin8;
    IBOutlet UILabel *origin9;
    IBOutlet UILabel *dest0;
    IBOutlet UILabel *dest1;
    IBOutlet UILabel *dest2;
    IBOutlet UILabel *dest3;
    IBOutlet UILabel *dest4;
    IBOutlet UILabel *dest5;
    IBOutlet UILabel *dest6;
    IBOutlet UILabel *dest7;
    IBOutlet UILabel *dest8;
    IBOutlet UILabel *dest9;
    
    
    
    NSMutableArray	*origin;
    NSMutableArray *destination;
}


@property (nonatomic, retain) IBOutlet UILabel *origin0;
@property (nonatomic, retain) IBOutlet UILabel *origin1;
@property (nonatomic, retain) IBOutlet UILabel *origin2;
@property (nonatomic, retain) IBOutlet UILabel *origin3;
@property (nonatomic, retain) IBOutlet UILabel *origin4;
@property (nonatomic, retain) IBOutlet UILabel *origin5;
@property (nonatomic, retain) IBOutlet UILabel *origin6;
@property (nonatomic, retain) IBOutlet UILabel *origin7;
@property (nonatomic, retain) IBOutlet UILabel *origin8;
@property (nonatomic, retain) IBOutlet UILabel *origin9;

@property (nonatomic, retain) IBOutlet UILabel *dest0;
@property (nonatomic, retain) IBOutlet UILabel *dest1;
@property (nonatomic, retain) IBOutlet UILabel *dest2;
@property (nonatomic, retain) IBOutlet UILabel *dest3;
@property (nonatomic, retain) IBOutlet UILabel *dest4;
@property (nonatomic, retain) IBOutlet UILabel *dest5;
@property (nonatomic, retain) IBOutlet UILabel *dest6;
@property (nonatomic, retain) IBOutlet UILabel *dest7;
@property (nonatomic, retain) IBOutlet UILabel *dest8;
@property (nonatomic, retain) IBOutlet UILabel *dest9;


@property (nonatomic, retain)	NSMutableArray	*origin;
@property (nonatomic, retain)	NSMutableArray	*destination;

@end
