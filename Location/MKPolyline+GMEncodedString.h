//
//  MKPolyline+GMEncodedString.h
//  Location
//
//  Created by Pyay Han on 10/05/2015.
//  Copyright (c) 2015 PJ Vea. All rights reserved.
//
/*
#import <Foundation/Foundation.h>

@interface MKPolyline_GMEncodedString : NSObject

@end
*/
#import <MapKit/MapKit.h>

@interface MKPolyline (GMEncodedString)

//+ (MKPolyline *)polylineWithGMEncodedString:(NSString *)encodedString;
+ (float *)polylineWithGMEncodedString:(NSString *)encodedString;
@end