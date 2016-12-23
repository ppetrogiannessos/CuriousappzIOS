//
//  UploadCarAvtarViewController.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "UploadCarAvtarViewController.h"
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
     [self uploadPicService];
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

@end
