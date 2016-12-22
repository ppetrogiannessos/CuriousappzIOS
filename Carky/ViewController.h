//
//  ViewController.h
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *currentSelectedTxtFld;
    UIToolbar *toolBar;
}
@property (nonatomic, weak) IBOutlet HeaderView *headerView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *surnameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *addressTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTxtFld;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLayoutConstraint;

- (IBAction)nextButtonAction:(UIButton *)sender;
@end

