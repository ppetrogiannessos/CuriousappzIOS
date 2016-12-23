//
//  TermsConditionViewController.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "TermsConditionViewController.h"
#import "CAActivityIndicatorView.h"
#import "NetworkHandler.h"

@interface TermsConditionViewController ()
{
    CAActivityIndicatorView *caActivityIndicator;
}
@end

@implementation TermsConditionViewController

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
    [self.headerView updateViewIndicator:4];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getTermsAndCondition];
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
#pragma mark -
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
-(void) getTermsAndCondition{
    [self displayActivityIndicator];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    [networkHandler makePostRequestWithUri:fetchTerms parameters:@{@"Culture": @"string"} withCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self hideActivityIndicator];
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            return ;
        }
        if (urlResponse.statusCode == 200) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivityIndicator];
                if ([response isKindOfClass:[NSArray class]]){
                    
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
    } withNetworkFailureBlock:^(NSString *message) {
        [self displayAlertWithTitle:@"Error" withMessage:message];
    }];
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
#pragma mark -
-(IBAction)checkMarkButtonAction:(CheckMarkButton *)sender{
    sender.isSelected = !sender.isSelected;
}
-(IBAction)nextButtonAction:(UIButton *)sender{
    if (self.checkMarkBtn.isSelected == NO) {
        return;
    }
}
#pragma mark - Keyboard Appearance Notification Observer
-(void) handleKeyboardChangeFrameNotification:(NSNotification *)notify{
    NSDictionary* notificationInfo = [notify userInfo];
    CGRect keyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self updateTopLayoutConstraint:keyboardFrame.size.height-100];
}
-(void) handleKeyboardWillHideNotification:(NSNotification *)notify{
    [self updateTopLayoutConstraint:10];
}
#pragma mark -
-(void) updateTopLayoutConstraint:(NSInteger)constValue{
    self.bottomLayoutConstraint.constant = constValue;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
