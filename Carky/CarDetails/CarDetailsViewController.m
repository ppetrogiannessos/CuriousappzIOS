//
//  CarDetailsViewController.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "CarDetailsViewController.h"
#import "UIController.h"
#import "UploadCarAvtarViewController.h"

@interface CarDetailsViewController ()

@end

@implementation CarDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.makeImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.modelImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.transmissionImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.fuelImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.registationImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.kmImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.carAddressImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.yearImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headerView updateViewIndicator:2];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)nextButtonAction:(UIButton *)sender{
    [self gotoCarAvtarUploadController];
}
-(void) gotoCarAvtarUploadController{
    UploadCarAvtarViewController *avtarController = [[UploadCarAvtarViewController alloc] initWithNibName:@"UploadCarAvtarViewController" bundle:nil];
    [self.navigationController pushViewController:avtarController animated:YES];
}
@end
