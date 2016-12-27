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
-(void) uploadCarImages:(NSArray *)imageList{
   // NSArray *imageList = @[[UIImage imageNamed:@"side.png"],[UIImage imageNamed:@"FrontSide.png"],[UIImage imageNamed:@"ThreeQuaters.png"],[UIImage imageNamed:@"Interior.png"]];
    NetworkHandler *handler = [[NetworkHandler alloc] init];
    [handler makeRquestForUploadImages:imageList withUri:[NSString stringWithFormat:@"%@?carId=%@",uploadCarPhotos, self.carId] postData:@{@"carId":self.carId} withCompletionHandler:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"resonse = %@", response);
        NSLog(@"Error = %@", error);
    } withNetworkFailureBlock:^(NSString *message) {
        NSLog(@"network error");
    }];
}
-(void) makeHttpRequestForUploadCarImages:(NSArray *)carImageList{
    [self displayActivityIndicator];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    NSString *uri = [NSString stringWithFormat:@"%@?carId=%@",uploadCarPhotos,self.carId];
    [networkHandler addCar:uri withImages:carImageList postData:@{} withCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self hideActivityIndicator];
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            return ;
        }
        if (urlResponse.statusCode == 200) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivityIndicator];
                [self gotoTermsConditionController];
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
    } withNetworkFailureBlock:^(NSString *message) {
        [self hideActivityIndicator];
        [self displayAlertWithTitle:@"No internet connection" withMessage:@"Please check internet connection and try again"];
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
//    if (self.sideBtn.tag == 0 || self.frontSideBtn.tag == 0 || self.threeQuarterBtn.tag == 0 || self.interiorBtn == 0) {
//        [self displayAlertWithTitle:@"" withMessage:@"Upload image for all sections"];
//        return;
//    }
//    [self uploadCarImages:@[self.sideBtn.currentBackgroundImage, self.frontSideBtn.currentBackgroundImage, self.threeQuarterBtn.currentBackgroundImage, self.interiorBtn.currentBackgroundImage]];
    
    UIImage *image = [UIImage imageNamed:@"model_icon_test.png"];
   [self makeHttpRequestForUploadCarImages:@[image, image, image, image]];
   // [self uploadCarImages:@[image, image, image, image]];
    
    //[self makeHttpRequestForUploadCarImages:@[self.sideBtn.currentBackgroundImage, self.frontSideBtn.currentBackgroundImage, self.threeQuarterBtn.currentBackgroundImage, self.interiorBtn.currentBackgroundImage]];
    //[self gotoTermsConditionController];
   // [self uploadImages];
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
-(void) uploadImages{
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",@"authorization": [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:KAppAuthenticationToken]],@"cache-control": @"no-cache",@"postman-token": @"18484b99-1932-6a8f-e6e7-7f6b8e64e1f9" };
    NSArray *parameters = @[ @{ @"name": @"sidepic", @"fileName": @"model_icon_test.png" },@{ @"name": @"frontpic", @"fileName": @"model_icon_test.png" },@{ @"name": @"outsidepic", @"fileName": @"model_icon_test.png" },@{ @"name": @"insidepic", @"fileName": @"model_icon_test.png" } ];
   
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    NSError *error;
    NSMutableString *body = [NSMutableString string];
   // NSString *s = [[NSBundle mainBundle] pathForResource:@"model_icon_test" ofType:@"png"];
    NSURL * l = [[NSBundle mainBundle] URLForResource:@"model_icon_test" withExtension:@"png"];
    for (NSDictionary *param in parameters) {
        [body appendFormat:@"--%@\r\n", boundary];
        if (param[@"fileName"]) {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
            [body appendFormat:@"Content-Type: %@\r\n\r\n", headers[@"content-type"]];
            //[body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
            //[body appendFormat:@"%@", [NSString stringWithContentsOfFile:s encoding:NSUTF8StringEncoding error:&error]];
            [body appendFormat:@"%@", [NSString stringWithContentsOfURL:l encoding:NSUTF8StringEncoding error:&error]];
            if (error) {
                NSLog(@"error = %@", error);
            }
        } else {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
            [body appendFormat:@"%@", param[@"value"]];
        }
    }
    [body appendFormat:@"\r\n--%@--\r\n", boundary];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://carky-app.azurewebsites.net/api/CarOwner/UploadCarPhotos?carId=%@",self.carId]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"%@", httpResponse);
        }
    }];
    [dataTask resume];
}
@end
