//
//  AboutView.m
//  Haze Route
//
//  Created by Pyay Han on 25/08/2015.
//  Copyright (c) 2015 PJ Vea. All rights reserved.
//

#import "AboutView.h"

@interface AboutView ()

@end

@implementation AboutView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"About";
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"bg640x1136_1_backup.png"];
    // Push background image to the back
    
    //imageView.alpha = 1;
    [self.view insertSubview:imageView atIndex:0];
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
