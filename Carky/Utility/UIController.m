//
//  UIController.m
//  eDuru
//
//  Created by Avinash Kashyap on 10/17/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "UIController.h"

static UIController *sharedInstance;

@implementation UIController

+(UIController *)sharedInstance{
    @synchronized (self) {
        if (!sharedInstance) {
            sharedInstance = [[UIController alloc] init];
        }
    }
    
    return sharedInstance;
}


-(void) addBackroundGradienLayerToView:(UIView *)subView{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = [UIScreen mainScreen].bounds;
    UIColor *firstColor = [UIColor colorWithRed:(CGFloat)85/255 green:(CGFloat)230/255 blue:(CGFloat)239/255 alpha:1.0];
    UIColor *secondColor = [UIColor colorWithRed:(CGFloat)15/255 green:(CGFloat)181/255 blue:(CGFloat)221/255 alpha:1.0];
    gradientLayer.colors = @[(id)firstColor.CGColor, (id)secondColor.CGColor];
    [subView.layer insertSublayer:gradientLayer atIndex:0];
    
}
-(void) addBorderWithWidth:(CGFloat)width withColor:(UIColor *)color withCornerRadious:(CGFloat)radious toView:(UIView *)view{
    
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = width;
    if (radious != 0) {
        view.layer.cornerRadius = radious;
        view.clipsToBounds = YES;
    }
}
-(void) addLeftPaddingtoTextField:(UITextField *)textField withFrame:(CGRect)frame withBackgroundColor:(UIColor *)color withImage:(NSString *)imageName{
    
    if (imageName == nil) {
        NSLog(@"Add uiview");
    }
    else{
        UIView *aview = [[UIView alloc] initWithFrame:frame];
        aview.backgroundColor = [UIColor clearColor];
        //NSLog(@"Add UIImage View");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-10, frame.size.height)];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [aview addSubview:imageView];
        textField.leftView = aview;
    }
    textField.leftViewMode = UITextFieldViewModeAlways;
}
@end
