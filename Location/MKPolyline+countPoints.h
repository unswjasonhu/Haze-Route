//
//  MKPolyline+countPoints.h
//  Location
//
//  Created by Pyay Han on 12/05/2015.
//  Copyright (c) 2015 PJ Vea. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKPolyline (countPoints)

+ (NSUInteger)count:(NSString *)encodedString;

@end