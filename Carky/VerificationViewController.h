//
//  VerificationViewController.h
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "CustomTextField.h"

@interface VerificationViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *backCodeView;;
@property (weak, nonatomic) IBOutlet CustomTextField *firstTxtFld;
@property (weak, nonatomic) IBOutlet CustomTextField *secTxtFld;
@property (weak, nonatomic) IBOutlet CustomTextField *thirdTxtFld;
@property (weak, nonatomic) IBOutlet CustomTextField *fourthTxtFld;
@property (weak, nonatomic) IBOutlet CustomTextField *fifthTxtFld;
@property (weak, nonatomic) IBOutlet CustomTextField *sixTxtFld;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (nonatomic, weak) IBOutlet HeaderView *headerView;
@property (nonatomic, strong) IBOutlet UIButton *accessoryViewBtn;
- (IBAction)resendButtonAction:(UIButton *)sender;
- (IBAction)secondButtonAction:(UIButton *)sender;
- (IBAction)submitButtonAction:(UIButton *)sender;
@end
