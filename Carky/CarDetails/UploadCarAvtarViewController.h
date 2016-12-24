//
//  UploadCarAvtarViewController.h
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
@interface UploadCarAvtarViewController : UIViewController
@property (nonatomic, weak) IBOutlet HeaderView *headerView;
@property (nonatomic, strong) NSString *carId;
@property (nonatomic, weak) IBOutlet UIView *btnBackView;
@property (nonatomic, weak) IBOutlet UIButton *sideBtn;
@property (nonatomic, weak) IBOutlet UIButton *frontSideBtn;
@property (nonatomic, weak) IBOutlet UIButton *threeQuarterBtn;
@property (nonatomic, weak) IBOutlet UIButton *interiorBtn;
-(IBAction)uploadButtonAction:(UIButton *)sender;
-(IBAction)skipButtonAction:(UIButton *)sender;
-(IBAction)nextButtonAction:(UIButton *)sender;
@end
