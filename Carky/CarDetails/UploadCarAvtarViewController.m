//
//  UploadCarAvtarViewController.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "UploadCarAvtarViewController.h"
#import "TermsConditionViewController.h"
#import "MediaSelectionController.h"

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
-(IBAction)nextButtonAction:(UIButton *)sender{
    [self gotoTermsConditionController];
}
-(void) gotoTermsConditionController{
    TermsConditionViewController *termsController = [[TermsConditionViewController alloc] initWithNibName:@"TermsConditionViewController" bundle:nil];
    [self.navigationController pushViewController:termsController animated:YES];
}
#pragma mark -
-(IBAction)uploadButtonAction:(UIButton *)sender{
    [self displayImagePickerOption:sender];
}
-(IBAction)skipButtonAction:(UIButton *)sender{
    [self gotoTermsConditionController];
}
-(void)displayImagePickerOption:(UIButton *)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Choose option for add new image" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraOprion = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Display camera");
        [self displayImagePickerWithSource:MediaPickerSourceImage forView:sender];
    }];
    UIAlertAction *photoOption = [UIAlertAction actionWithTitle:@"Photo/Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Display photo");
        [self displayImagePickerWithSource:MediaPickerSourcePhotoAlbum forView:sender];
    }];
    UIAlertAction *cancelOption = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    [alertController addAction:cameraOprion];
    [alertController addAction:photoOption];
    [alertController addAction:cancelOption];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        alertController.popoverPresentationController.sourceRect = CGRectZero;
        alertController.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - Display image picker
-(void) displayImagePickerWithSource:(MediaPickerSourceType)source forView:(UIButton *)sender{
    
    MediaSelectionController *mediaController = [MediaSelectionController mediaManagerWithController:self];
    [mediaController displayImagePickerWithSource:source withCompletionBlock:^(id response, NSError *error) {
        [sender setBackgroundImage:response forState:UIControlStateNormal];
    }];
}
@end
