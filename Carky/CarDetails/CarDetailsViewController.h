//
//  CarDetailsViewController.h
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
@interface CarDetailsViewController : UIViewController
@property (nonatomic, weak) IBOutlet HeaderView *headerView;
@property (nonatomic, weak) IBOutlet UIImageView *makeImageView;
@property (nonatomic, weak) IBOutlet UIImageView *modelImageView;
@property (nonatomic, weak) IBOutlet UIImageView *transmissionImageView;
@property (nonatomic, weak) IBOutlet UIImageView *yearImageView;
@property (nonatomic, weak) IBOutlet UIImageView *fuelImageView;
@property (nonatomic, weak) IBOutlet UIImageView *registationImageView;
@property (nonatomic, weak) IBOutlet UIImageView *kmImageView;
@property (nonatomic, weak) IBOutlet UIImageView *carAddressImageView;
- (IBAction)nextButtonAction:(UIButton *)sender;
@end
