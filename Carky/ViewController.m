//
//  ViewController.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "ViewController.h"
#import "Utility.h"
#import "VerificationViewController.h"
#import "NetworkHandler.h"
#import "CAActivityIndicatorView.h"
#import "UIController.h"

@interface ViewController ()
{
    CAActivityIndicatorView *caActivityIndicator;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[UIController sharedInstance] addLeftPaddingtoTextField:self.mobileNumberTxtFld withFrame:CGRectMake(0, 0, 35, 30) withBackgroundColor:[UIColor clearColor] withImage:@"phoneicon.png"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headerView updateViewIndicator:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];

}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark -
-(void) updateTopLayoutConstraint:(NSInteger)constValue{
    self.topLayoutConstraint.constant = constValue;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - TextFieldDelegate
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    //    NSLog(@"frame = %@", NSStringFromCGRect(textField.frame));
    //    [self updateTopLayoutConstraint:-textField.frame.origin.y+120 - 70];
    currentSelectedTxtFld = textField;
    if (textField.keyboardType == UIKeyboardTypePhonePad) {
        [self addAccessoryViewtoTextField:textField];
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag != 7) {
        UITextField *nextTxtFld = [self.scrollView viewWithTag:textField.tag+1];
        [self performSelector:@selector(respondToNextField:) withObject:nextTxtFld afterDelay:0.1];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
-(void)respondToNextField:(UITextField *)nextTxtFld{
    [nextTxtFld becomeFirstResponder];
}
#pragma mark -
-(void) addAccessoryViewtoTextField:(UITextField *)textField{
    if (!toolBar) {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 44)];
        toolBar.barStyle = UIBarStyleBlack;
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toolbarDoneButtonAction)];
        toolBar.items = @[barButton];
    }
    textField.inputAccessoryView = toolBar;
}
-(void) toolbarDoneButtonAction{
    [self.view endEditing:YES];
}
#pragma mark - Keyboard Appearance Notification Observer
-(void) handleKeyboardChangeFrameNotification:(NSNotification *)notify{
    NSDictionary* notificationInfo = [notify userInfo];
    CGRect keyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = currentSelectedTxtFld.frame;
    
    CGFloat y = frame.origin.y + 220;
    if (currentSelectedTxtFld.tag == 7) {
        y = y - 50;
    }
    
    CGFloat v  = self.view.frame.size.height-keyboardFrame.size.height;
    if (y > v) {
        [self updateTopLayoutConstraint:-(y - v)];
    }
    else{
        [self updateTopLayoutConstraint:0];
    }
}
-(void) handleKeyboardWillHideNotification:(NSNotification *)notify{
    currentSelectedTxtFld = nil;
    [self updateTopLayoutConstraint:0];
}
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
#pragma mark - IBAction
- (IBAction)nextButtonAction:(UIButton *)sender {
//       self.emailTxtFld.text = @"avinash@gmail.com";
//        self.passwordTxtFld.text = @"qwerty";
////      // [self displayVerficationControllerWithCode:@""];
  //  [self getAuthenticationToken:[[NetworkHandler alloc] init]];
//       return;
    if (self.nameTxtFld.text.length<1 || self.surnameTxtFld.text.length<1 || self.addressTxtFld.text.length < 1 || self.emailTxtFld.text.length < 1 || self.passwordTxtFld.text.length < 1 || self.confirmPasswordTxtFld.text.length < 1 || self.mobileNumberTxtFld.text.length < 1) {
        [self displayAlertWithTitle:@"" withMessage:@"All fields are mandatory"];
        return;
    }
    if (![self.passwordTxtFld.text isEqualToString:self.confirmPasswordTxtFld.text]) {
        [self displayAlertWithTitle:@"" withMessage:@"Password and confirm password must be same"];
        return;
    }
    if ([Utility validateEmail:self.emailTxtFld.text] == NO) {
        [self displayAlertWithTitle:@"" withMessage:@"Please enter a valid email address"];
        return;
    }
    //[self displayVerficationController];
    [self registerUser];
}
-(void) registerUser{
    [self displayActivityIndicator];
    NSDictionary *postDict = @{@"FirstName":self.nameTxtFld.text, @"Surname":self.surnameTxtFld.text, @"Address":self.addressTxtFld.text, @"Email":self.emailTxtFld.text, @"PhoneNumber":self.mobileNumberTxtFld.text, @"Password":self.passwordTxtFld.text, @"ConfirmPassword":self.confirmPasswordTxtFld.text};
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    [networkHandler makePostRequestWithUri:userRegistration parameters:postDict withCompletion:^(id response,NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            [self hideActivityIndicator];
            return ;
        }
        if (urlResponse.statusCode == 200) {
            NSLog(@"Send phone number verification request");
            //[self performSelector:@selector(getAuthenticationToken:) withObject:networkHandler afterDelay:1.0];
            [self getAuthenticationToken:networkHandler];
        }
        else{
            [self hideActivityIndicator];
            if([response isKindOfClass:[NSDictionary class]]){
                if (response[@"Message"]) {
                    [self displayAlertWithTitle:@"Error" withMessage:response[@"Message"]];
                }
            }
            else{
                [self displayAlertWithTitle:@"Error" withMessage:@"Please try again"];
            }
            
            NSLog(@"Display error message");
        }
    } withNetworkFailureBlock:^(NSString *message) {
        NSLog(@"Network not available");
        [self hideActivityIndicator];
        [self displayAlertWithTitle:@"No internet connection" withMessage:@"Please check internet connection and try again"];
    }];
}
-(void) getAuthenticationToken:(NetworkHandler *)networkHandler{
    
    [networkHandler makeunlencodedPostRequestwith:getToken parameters:[NSString stringWithFormat:@"grant_type=password&username=%@&password=%@",self.emailTxtFld.text, self.passwordTxtFld.text] withCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self hideActivityIndicator];
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            return ;
        }
        if (urlResponse.statusCode == 200) {
            [self hideActivityIndicator];
            if([response isKindOfClass:[NSDictionary class]]){
                NSString *accessToken = [NSString stringWithFormat:@"%@",response[@"access_token"]];
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:KAppAuthenticationToken];
                NSLog(@"access_token -  %@",accessToken);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self displayVerficationControllerWithCode:@""];
//                });
                
               [self sendPhoneNumberVerificationRequest:networkHandler];
            }
        }
        else{
            NSLog(@"Display error message");
            
            [self hideActivityIndicator];
            if([response isKindOfClass:[NSDictionary class]]){
                if (response[@"Message"]) {
                    [self displayAlertWithTitle:@"Error" withMessage:response[@"Message"]];
                }
                else if (response[@"error_description"]){
                    [self displayAlertWithTitle:@"Error" withMessage:response[@"error_description"]];
                }
                else if (response[@"error"]) {
                    [self displayAlertWithTitle:@"Error" withMessage:response[@"error"]];
                }
            }
            else{
                [self displayAlertWithTitle:@"Error" withMessage:@"Please try again"];
            }
        }
    } withNetworkFailureBlock:^(NSString *message) {
        NSLog(@"Network not available");
        [self hideActivityIndicator];
        [self displayAlertWithTitle:@"No internet connection" withMessage:@"Please check internet connection and try again"];
    }];
}
#pragma mark -
-(void) sendPhoneNumberVerificationRequest:(NetworkHandler *)networkHandler{
    [networkHandler makePostRequestWithUri:phoneNumberVerification parameters:@{@"api_key":@""} withCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self hideActivityIndicator];
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            return ;
        }
        if (urlResponse.statusCode == 200) {
            [self addClientRoleWithNetworkHandler:networkHandler andCode:response];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayAlertWithTitle:@"Error" withMessage:message];
        });
    }];
}
#pragma mark -
-(void) addClientRoleWithNetworkHandler:(NetworkHandler *)networkHandler andCode:(NSString *)code{
    [networkHandler makePostRequestWithUri:addClientRole parameters:@{@"api_key":[[NSUserDefaults standardUserDefaults] objectForKey:KAppAuthenticationToken]} withCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self hideActivityIndicator];
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            return ;
        }
        if (urlResponse.statusCode == 204) {
            [self addCarOwnerRoleWithNetworkHandler:networkHandler withCode:code];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayAlertWithTitle:@"Error" withMessage:message];
        });
    }];
}
-(void)addCarOwnerRoleWithNetworkHandler:(NetworkHandler *)networkHandler withCode:(NSString *)code{
    [networkHandler makePostRequestWithUri:addCarOwnerRole parameters:@{@"api_key":[[NSUserDefaults standardUserDefaults] objectForKey:KAppAuthenticationToken]} withCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self hideActivityIndicator];
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            return ;
        }
        if (urlResponse.statusCode == 204) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([response isKindOfClass:[NSString class]]){
                    [self displayVerficationControllerWithCode:code];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayAlertWithTitle:@"Error" withMessage:message];
        });
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
-(void) displayVerficationControllerWithCode:(NSString *)code{
    VerificationViewController *verificationController = [[VerificationViewController alloc] initWithNibName:@"VerificationViewController" bundle:nil];
    verificationController.phoneNumber = self.mobileNumberTxtFld.text;
    verificationController.verificationCode = code;
    [self.navigationController pushViewController:verificationController animated:YES];
}
@end
