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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
    [textField resignFirstResponder];
    if (textField.tag != 7) {
        UITextField *nextTxtFld = [self.scrollView viewWithTag:textField.tag+1];
        [nextTxtFld becomeFirstResponder];
    }
    return YES;
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
#pragma mark - IBAction
- (IBAction)nextButtonAction:(UIButton *)sender {
    [self displayVerficationController];
    return;
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
    NSDictionary *postDict = @{@"FirstName":self.nameTxtFld.text, @"Surname":self.surnameTxtFld.text, @"Address":self.addressTxtFld.text, @"Email":self.emailTxtFld.text, @"PhoneNumber":self.mobileNumberTxtFld.text, @"Password":self.passwordTxtFld.text, @"ConfirmPassword":self.confirmPasswordTxtFld.text};
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    [networkHandler makePostRequestWithUri:userRegistration parameters:postDict withCompletion:^(id response,NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            return ;
        }
        if (urlResponse.statusCode == 200) {
            NSLog(@"Send phone number verification request");
        }
        else{
            NSLog(@"Display error message");
        }
    } withNetworkFailureBlock:^(NSString *message) {
        NSLog(@"Network not available");
    }];
}
-(void) sendPhoneNumberVerificationRequest:(NetworkHandler *)networkHandler{
    [networkHandler makePostRequestWithUri:phoneNumberVerification parameters:@{@"PhoneNumber":self.mobileNumberTxtFld.text} withCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            return ;
        }
        if (urlResponse.statusCode == 200) {
            [self displayVerficationController];
        }
        else{
            NSLog(@"Display error message");
        }
    } withNetworkFailureBlock:^(NSString *message) {
        
    }];
}
#pragma mark -
-(void) displayAlertWithTitle:(NSString *)title withMessage:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -
-(void) displayVerficationController{
    VerificationViewController *verificationController = [[VerificationViewController alloc] initWithNibName:@"VerificationViewController" bundle:nil];
    [self.navigationController pushViewController:verificationController animated:YES];
}
@end
