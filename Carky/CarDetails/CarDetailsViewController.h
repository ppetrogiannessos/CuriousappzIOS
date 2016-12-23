//
//  CarDetailsViewController.h
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "CustomTextField.h"

@interface CarDetailsViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    NSArray *carDetailsArray;
    NSArray *selectionDetailsArray;
    CustomTextField *activeTxtFld;
}
@property (nonatomic, weak) IBOutlet HeaderView *headerView;
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UIImageView *makeImageView;
@property (nonatomic, weak) IBOutlet UIImageView *modelImageView;
@property (nonatomic, weak) IBOutlet UIImageView *transmissionImageView;
@property (nonatomic, weak) IBOutlet UIImageView *yearImageView;
@property (nonatomic, weak) IBOutlet UIImageView *fuelImageView;
@property (nonatomic, weak) IBOutlet UIImageView *registationImageView;
@property (nonatomic, weak) IBOutlet UIImageView *kmImageView;
@property (nonatomic, weak) IBOutlet UIImageView *carAddressImageView;

@property (nonatomic, weak) IBOutlet CustomTextField *makeTxtFld;
@property (nonatomic, weak) IBOutlet CustomTextField *modelTxtFld;
@property (nonatomic, weak) IBOutlet CustomTextField *transmissionTxtFld;
@property (nonatomic, weak) IBOutlet CustomTextField *yearTxtFld;
@property (nonatomic, weak) IBOutlet CustomTextField *fuelTxtFld;
@property (nonatomic, weak) IBOutlet CustomTextField *registrationTxtFld;
@property (nonatomic, weak) IBOutlet CustomTextField *kmTxtFld;
@property (nonatomic, weak) IBOutlet CustomTextField *carAddressTxtFld;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLayoutConstraint;

@property (nonatomic, strong)  UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *yearPicker;
@property (nonatomic, strong) IBOutlet UIToolbar *toolBar;
- (IBAction)nextButtonAction:(UIButton *)sender;
@end
