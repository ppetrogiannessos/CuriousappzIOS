//
//  UIController.h
//  eDuru
//
//  Created by Avinash Kashyap on 10/17/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIController : NSObject
+(UIController *)sharedInstance;
-(void) addBackroundGradienLayerToView:(UIView *)subView;
-(void) addBorderWithWidth:(CGFloat)width withColor:(UIColor *)color withCornerRadious:(CGFloat)radious toView:(UIView *)view;
-(void) addLeftPaddingtoTextField:(UITextField *)textField withFrame:(CGRect)frame withBackgroundColor:(UIColor *)color withImage:(NSString *)imageName;
@end
