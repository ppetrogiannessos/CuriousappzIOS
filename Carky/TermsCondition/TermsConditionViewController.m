//
//  TermsConditionViewController.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "TermsConditionViewController.h"

@interface TermsConditionViewController ()

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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
