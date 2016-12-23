//
//  CAActivityIndicatorView.m
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/20/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "CAActivityIndicatorView.h"

@implementation CAActivityIndicatorView

-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        [self initialization];
    }
    return self;
}
-(void) initialization{
    //add backgroung view
    backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    backGroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self addSubview:backGroundView];
    backGroundView.center = self.center;
    backGroundView.layer.cornerRadius = 8.0;
    backGroundView.clipsToBounds = YES;
    backGroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    //add activity indicator
    //activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicatorView.hidesWhenStopped = YES;
    activityIndicatorView.center = CGPointMake(backGroundView.frame.size.width/2, backGroundView.frame.size.height/2 - 15);
    [backGroundView addSubview:activityIndicatorView];
    //add label
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, activityIndicatorView.frame.size.height+activityIndicatorView.frame.origin.y + 10, backGroundView.frame.size.width, 25)];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    messageLabel.text = @"Please wait...";
    [backGroundView addSubview:messageLabel];
    backGroundView.alpha = 0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) setMessageText:(NSString *)text{
    messageLabel.text = text;
}
-(void) displayActivityIndicatorView{
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        backGroundView.alpha = 1.0;
    }];
    [activityIndicatorView startAnimating];
}
-(void) hideActivityIndicatorView{
    [UIView animateWithDuration:0.3 animations:^{
        backGroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
}
@end
