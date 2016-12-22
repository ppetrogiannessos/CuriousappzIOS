//
//  HeaderView.h
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *routeButton;
-(void) updateViewIndicator:(NSInteger)tagValue;
@end
