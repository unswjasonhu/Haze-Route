//
//  HistoryView.m
//  Haze Route
//
//  Created by Pyay Han on 13/10/2015.
//  Copyright © 2015 PJ Vea. All rights reserved.
//

#import "HistoryView.h"

@interface HistoryView ()

@end

@implementation HistoryView 

@synthesize origin;
@synthesize destination;
@synthesize origin0, origin1, origin2, origin3, origin4;
@synthesize origin5, origin6, origin7, origin8, origin9;
@synthesize dest0, dest1, dest2, dest3, dest4;
@synthesize dest5, dest6, dest7, dest8, dest9;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[nameEntered setDelegate:self];
    //[homePhone setDelegate:self];
    //[workPhone setDelegate:self];
    //[cellPhone setDelegate:self];
    
    // Data.plist code
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"History.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"History" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property liost into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    // assign values
    
    self.origin = [temp objectForKey:@"origin"];
    self.destination = [NSMutableArray arrayWithArray:[temp objectForKey:@"destination"]];
    // display values
    
    origin0.text = [origin objectAtIndex:0];
    
    origin1.text = [origin objectAtIndex:1];
    origin2.text = [origin objectAtIndex:2];
    origin3.text = [origin objectAtIndex:3];
    origin4.text = [origin objectAtIndex:4];
    origin5.text = [origin objectAtIndex:5];
    origin6.text = [origin objectAtIndex:6];
    origin7.text = [origin objectAtIndex:7];
    origin8.text = [origin objectAtIndex:8];
    origin9.text = [origin objectAtIndex:9];
    
    dest0.text = [destination objectAtIndex:0];
    dest1.text = [destination objectAtIndex:1];
    dest2.text = [destination objectAtIndex:2];
    dest3.text = [destination objectAtIndex:3];
    dest4.text = [destination objectAtIndex:4];
    dest5.text = [destination objectAtIndex:5];
    dest6.text = [destination objectAtIndex:6];
    dest7.text = [destination objectAtIndex:7];
    dest8.text = [destination objectAtIndex:8];
    dest9.text = [destination objectAtIndex:9];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
