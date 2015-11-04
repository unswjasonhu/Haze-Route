//
//  AppDelegate.m
//  Location
//
//  Created by Pyay Han

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Add in your API key here:
    [GMSServices provideAPIKey:@"AIzaSyAOWus2173awc0JeRUUSkxfhEtOKQIbriE"];
    
    return YES;
    
}

@end



