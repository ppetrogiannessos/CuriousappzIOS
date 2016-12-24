//
//  UploadCarAvtarViewController.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "UploadCarAvtarViewController.h"
#import "UIController.h"
#import "TermsConditionViewController.h"
#import "MediaSelectionController.h"
#import "NetworkHandler.h"
#import "CAActivityIndicatorView.h"


@interface UploadCarAvtarViewController ()
{
     CAActivityIndicatorView *caActivityIndicator;
}
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

#pragma mark -
-(void) displayAlertWithTitle:(NSString *)title withMessage:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headerView updateViewIndicator:3];
}

-(void) displayActivityIndicator{
    if (!caActivityIndicator) {
        caActivityIndicator = [[CAActivityIndicatorView alloc] initWithFrame:self.navigationController.view.frame];
    }
    [self.navigationController.view addSubview:caActivityIndicator];
    // [caActivityIndicator setMessageText:@"Exporting video"];
    [caActivityIndicator displayActivityIndicatorView];
}
-(void) hideActivityIndicator{
    dispatch_async(dispatch_get_main_queue(), ^{
        [caActivityIndicator hideActivityIndicatorView];
    });
    
}


#pragma mark -
-(void) makeHttpRequestForUploadCarImages:(NSArray *)carImageList{
    
}
-(void) uploadPicService{
    [self displayActivityIndicator];
    // NSDictionary *postDict = @{@"Culture":@"sample string 1"};
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    [networkHandler addUserPostWithNamewithCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self hideActivityIndicator];
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            return ;
        }
        if (urlResponse.statusCode == 200) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivityIndicator];
                if ([response isKindOfClass:[NSArray class]]){
                    //carDetailsArray = [NSArray arrayWithArray:response];
                }
                else{
                    [self displayAlertWithTitle:@"Error" withMessage:@"Please try again"];
                }
            });
        }
        else{
            NSLog(@"Display error message");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivityIndicator];
                if([response isKindOfClass:[NSDictionary class]]){
                    if (response[@"Message"]) {
                        [self displayAlertWithTitle:@"Error" withMessage:response[@"Message"]];
                    }
                }
                else{
                    [self displayAlertWithTitle:@"Error" withMessage:@"Please try again"];
                }
            });
        }
        
    }];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark -
-(IBAction)nextButtonAction:(UIButton *)sender{
    if (self.sideBtn.tag == 0 || self.frontSideBtn.tag == 0 || self.threeQuarterBtn.tag == 0 || self.interiorBtn == 0) {
        [self displayAlertWithTitle:@"" withMessage:@"Upload image for all sections"];
        return;
    }
    //[self uploadPicService];
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
#pragma mark -
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
        if (sender.tag == 0) {
            sender.tag = 1;
            [[UIController sharedInstance] addBorderWithWidth:0.7 withColor:[UIColor lightGrayColor] withCornerRadious:2 toView:sender];
        }
        [sender setBackgroundImage:response forState:UIControlStateNormal];
    }];
}
#pragma mark -
@end
