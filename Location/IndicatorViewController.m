//
//  IndicatorViewController.m
//  Haze Route
//
//  Created by Pyay Han on 4/08/2015.
//  Copyright (c) 2015 PJ Vea. All rights reserved.
//

#import "IndicatorViewController.h"

@interface IndicatorViewController ()

@end

@implementation IndicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(mymethod) withObject:nil afterDelay:5.0];
}

- (void) mymethod {
    label.text = @"App loaded";
    
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
