//
//  VerificationViewController.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "VerificationViewController.h"
#import "UIController.h"
#import "CarDetailsViewController.h"

@interface VerificationViewController ()

@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:5.0f toView:self.resendButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headerView updateViewIndicator:1];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.firstTxtFld becomeFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)resendButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)secondButtonAction:(UIButton *)sender {
}
- (IBAction)submitButtonAction:(UIButton *)sender{
//    if (self.firstTxtFld.text.length != 1 || self.secTxtFld.text.length != 1 || self.thirdTxtFld.text.length != 1 || self.fourthTxtFld.text.length != 1 || self.fifthTxtFld.text.length != 1 || self.sixTxtFld.text.length != 1) {
//        return;
//    }
//    NSString *code = [NSString stringWithFormat:@"%@%@%@%@%@%@",self.firstTxtFld.text,self.secTxtFld.text,self.thirdTxtFld.text,self.fourthTxtFld.text,self.fifthTxtFld.text,self.sixTxtFld.text];
//    NSLog(@"Code = %@", code);
    [self gotoCarDetailsController];
}
#pragma mark -
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    [self addInputAccessoryView:textField];
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location>0 ) {
        UITextField *nextFld = [self.backCodeView viewWithTag:textField.tag + 1];
        if (nextFld != nil) {
            nextFld.text = string;
            [nextFld becomeFirstResponder];
        }
        return NO;
    }
    if ( range.location==0 && range.length == 1) {
        UITextField *nextFld = [self.backCodeView viewWithTag:textField.tag - 1];
        textField.text = @"";
        [nextFld becomeFirstResponder];
        return NO;
    }
    
    textField.text = string;
    UITextField *nextFld = [self.backCodeView viewWithTag:textField.tag + 1];
    if (nextFld != nil) {
       [nextFld becomeFirstResponder]; 
    }
    
    return NO;
}
//-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
//    if (textField.text.length >= 1) {
//        return YES;
//    }
//    return NO;
//}

-(void) addInputAccessoryView:(UITextField *)textField{
    if (!self.accessoryViewBtn) {
        self.accessoryViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.accessoryViewBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        self.accessoryViewBtn.backgroundColor = [UIColor blackColor];
        [self.accessoryViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.accessoryViewBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.accessoryViewBtn setTitle:@"SUBMIT VERIFICATION CODE" forState:UIControlStateNormal];
        [self.accessoryViewBtn addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    textField.inputAccessoryView = self.accessoryViewBtn;
}
-(void) gotoCarDetailsController{
    CarDetailsViewController *carDetailsController = [[CarDetailsViewController alloc] initWithNibName:@"CarDetailsViewController" bundle:nil];
    [self.navigationController pushViewController:carDetailsController animated:YES];
}
@end
