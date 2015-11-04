//
//  GCGeocodingService.h
//  GeocodingAPISample
//
//  Created by Pyay Han

#import <Foundation/Foundation.h>

@interface GCGeocodingService : NSObject

- (id)init;
- (void)geocodeAddress:(NSString *)address
          withCallback:(SEL)callback
          withDelegate:(id)delegate;

@property (nonatomic, strong) NSDictionary *geocode;

@end
