//
//  ViewController.m
//  Location
//
//  Created by Pyay Han


#import "ViewController.h"
#import "MapForTextController.h"
#import "MapWhileLoading.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

static NSString *originCopy1;
static NSString *originCopy2;
static NSString *originCopy3;
static NSString *originCopy4;
static NSString *originCopy5;
static NSString *originCopy6;
static NSString *originCopy7;
static NSString *originCopy8;
static NSString *originCopy9;
static NSString *destCopy1;
static NSString *destCopy2;
static NSString *destCopy3;
static NSString *destCopy4;
static NSString *destCopy5;
static NSString *destCopy6;
static NSString *destCopy7;
static NSString *destCopy8;
static NSString *destCopy9;


@interface ViewController () <CLLocationManagerDelegate>

@property double latitude;
@property double longitude;
@property (weak, nonatomic) IBOutlet UITextField *startText;
@property (weak, nonatomic) IBOutlet UITextField *destText;
@property (weak, nonatomic) IBOutlet UISwitch *lowestExposureSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shortestPathSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *timeSwitch;

@end


@implementation ViewController {
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@synthesize origins;
@synthesize destinations;


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //*********** Plist Coding *******
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
    
    self.origins = [temp objectForKey:@"origin"];
    self.destinations = [NSMutableArray arrayWithArray:[temp objectForKey:@"destination"]];
    //display values

    originCopy1 = [origins objectAtIndex:0];
    originCopy2 = [origins objectAtIndex:1];
    originCopy3 = [origins objectAtIndex:2];
    originCopy4 = [origins objectAtIndex:3];
    originCopy5 = [origins objectAtIndex:4];
    originCopy6 = [origins objectAtIndex:5];
    originCopy7 = [origins objectAtIndex:6];
    originCopy8 = [origins objectAtIndex:7];
    originCopy9 = [origins objectAtIndex:8];
    
    destCopy1 = [destinations objectAtIndex:0];
    destCopy2 = [destinations objectAtIndex:1];
    destCopy3 = [destinations objectAtIndex:2];
    destCopy4 = [destinations objectAtIndex:3];
    destCopy5 = [destinations objectAtIndex:4];
    destCopy6 = [destinations objectAtIndex:5];
    destCopy7 = [destinations objectAtIndex:6];
    destCopy8 = [destinations objectAtIndex:7];
    destCopy9 = [destinations objectAtIndex:8];
    
    //********************* Plist loading ********
    
    self.title = @"Haze Route";
    locationManager = [[CLLocationManager alloc] init];
    
    //text delegate
    [_startText setDelegate:self];
    [_destText setDelegate:self];
    _startText.autocorrectionType = UITextAutocorrectionTypeNo;
    _destText.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //Background
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    if (self.view.frame.size.width == 768 && self.view.frame.size.height == 1024)
        imageView.image = [UIImage imageNamed:@"bg768x1024_1.png"];
    else
        imageView.image = [UIImage imageNamed:@"bg640x1136_1.png"];
    // Push background image to the back
    
    //imageView.alpha = 0.2;
    [self.view insertSubview:imageView atIndex:0];
    
    
    locationManager.delegate = self;
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.longitude = currentLocation.coordinate.longitude;
        self.latitude =  currentLocation.coordinate.latitude;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"TapView"]) {
        
        MapController * mc = [segue destinationViewController];
    
        mc.longitude = _longitude;
        mc.latitude = _latitude;
    
    }
    else if([segue.identifier isEqualToString:@"TextView"]) {
        MapWhileLoading * textC = [segue destinationViewController];
        textC.origin = _startText.text;
        textC.destination = _destText.text;
        textC.selectLowestExposure = [_lowestExposureSwitch isOn];
        textC.selectShortestPath = [_shortestPathSwitch isOn];
        textC.selectPointsPerMinute = [_timeSwitch isOn];
    }
        
}


- (IBAction) saveHistory
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"History.plist"];
    
    NSString *nullString = @"HELLO";
    // set the variables to the values in the text fields
    self.origins = [[NSMutableArray alloc] initWithCapacity:10];
    [self.origins addObject:_startText.text];
    [self.origins addObject:originCopy1];
    [self.origins addObject:originCopy2];
    [self.origins addObject:originCopy3];
    [self.origins addObject:originCopy4];
    [self.origins addObject:originCopy5];
    [self.origins addObject:originCopy6];
    [self.origins addObject:originCopy7];
    [self.origins addObject:originCopy8];
    [self.origins addObject:originCopy9];
    
    /*
    [self.origins addObject:_startText.text];
    [self.origins addObject:_startText.text];
    [self.origins addObject:_startText.text];
    [self.origins addObject:_startText.text];
    [self.origins addObject:_startText.text];
    [self.origins addObject:_startText.text];
    [self.origins addObject:_startText.text];
    [self.origins addObject:_startText.text];*/
    
    self.destinations = [[NSMutableArray alloc] initWithCapacity:10];
    [self.destinations addObject:_destText.text];
    [self.destinations addObject:destCopy1];
    [self.destinations addObject:destCopy2];
    [self.destinations addObject:destCopy3];
    [self.destinations addObject:destCopy4];
    [self.destinations addObject:destCopy5];
    [self.destinations addObject:destCopy6];
    [self.destinations addObject:destCopy7];
    [self.destinations addObject:destCopy8];
    [self.destinations addObject:destCopy9];

    
    // create dictionary with values in UITextFields
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: origins, destinations, nil] forKeys:[NSArray arrayWithObjects: @"origin", @"destination", nil]];
    
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our History.plist file
        [plistData writeToFile:plistPath atomically:YES];
        NSLog(@"History successfully saved!");
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
        //[error release];
    }
}



@end
