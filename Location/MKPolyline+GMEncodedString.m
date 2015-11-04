//
//  MKPolyline+GMEncodedString.m
//  Location
//
//  Created by Pyay Han on 10/05/2015.
//  Copyright (c) 2015 PJ Vea. All rights reserved.
//

#import "MKPolyline+GMEncodedString.h"

@implementation MKPolyline (GMEncodedString)

//+ (MKPolyline *)polylineWithGMEncodedString:(NSString *)encodedString {
+ (float *)polylineWithGMEncodedString:(NSString *)encodedString {
    
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    // 2d array to hold all the lat and lng.
    float *allPoints = (float*) malloc(sizeof(float)*count*2);
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        //NSLog(@"\nEncoded Polyline is:%f %f\n",finalLat, finalLon);
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        allPoints[coordIdx*2] = finalLat;
        allPoints[coordIdx*2 + 1] = finalLon;
        //NSLog(@"\nEncoded Polyline is:%f %f\n\n",allPoints[coordIdx], allPoints[coordIdx+1]);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            //reallocating for allPoints
            allPoints = realloc(allPoints, sizeof(float)*newCount*2);
            count = newCount;
        }
    }
    free(coords);

    
    return allPoints;
}

@end