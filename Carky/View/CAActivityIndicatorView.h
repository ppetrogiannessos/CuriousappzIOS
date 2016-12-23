//
//  CAActivityIndicatorView.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/20/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAActivityIndicatorView : UIView
{
    UIView *backGroundView;
    UIActivityIndicatorView *activityIndicatorView;
    UILabel *messageLabel;
}
-(void) setMessageText:(NSString *)text;
-(void) displayActivityIndicatorView;
-(void) hideActivityIndicatorView;
@end
