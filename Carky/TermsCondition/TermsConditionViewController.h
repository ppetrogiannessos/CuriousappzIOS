//
//  TermsConditionViewController.h
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "CheckMarkButton.h"

@interface TermsConditionViewController : UIViewController
@property (nonatomic, weak) IBOutlet HeaderView *headerView;
@property (nonatomic, weak) IBOutlet CheckMarkButton *checkMarkBtn;
@property (nonatomic, weak) IBOutlet UITextView *termsTextView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
-(IBAction)checkMarkButtonAction:(CheckMarkButton *)sender;
-(IBAction)nextButtonAction:(UIButton *)sender;
@end
