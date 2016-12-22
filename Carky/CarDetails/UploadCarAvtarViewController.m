//
//  UploadCarAvtarViewController.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "UploadCarAvtarViewController.h"

@interface UploadCarAvtarViewController ()

@end

@implementation UploadCarAvtarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headerView updateViewIndicator:3];
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
