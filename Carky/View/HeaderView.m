//
//  HeaderView.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self = [super init];
    if (self) {
        [self configuration];
    }
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configuration];
    }
    return self;
}
-(void) awakeFromNib{
    [super awakeFromNib];
    [self configuration];
}
#pragma mark -
-(void) configuration{
    //add logo
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 100, 19)];
    self.logoImageView.image = [UIImage imageNamed:@"carky_logo.png"];
    self.logoImageView.backgroundColor = [UIColor clearColor];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImageView.center = CGPointMake(self.frame.size.width/2, 40);
    self.logoImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:self.logoImageView];
    //add menu button
    self.menuButton = [self initializeButton:self.menuButton withImage:[UIImage imageNamed:@"home_icon.png"] andFrame:CGRectMake(20, 25, 24, 15)];
    [self.menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.menuButton];
    //add route button
    self.routeButton = [self initializeButton:self.menuButton withImage:[UIImage imageNamed:@"route_icon.png"] andFrame:CGRectMake(self.frame.size.width - 44, 25, 24, 15)];
    [self.routeButton addTarget:self action:@selector(routeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.routeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:self.routeButton];
    //---
    CGFloat w = 40;
    CGFloat x = 5;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 60)];
    backView.backgroundColor = [UIColor clearColor];
    backView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height-30);
    backView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:backView];
    //add Indicator labels
    UILabel *firstLabel;
    firstLabel = [self initializeLabel:firstLabel withFrame:CGRectMake(x, 5, w, w) withText:@"1" andTag:1];
    [backView addSubview:firstLabel];
    UIView *firstView;
    firstView = [self initializeView:firstView withColor:[UIColor lightGrayColor] andFrame:CGRectMake(45, 24, 31, 2)];
    [backView addSubview:firstView];
    UILabel *firstTextLabel;
    firstTextLabel = [self initializeLabel:firstTextLabel withFrame:CGRectMake(x, w+5, w, 15) withText:@"SIGNUP" andTag:11];
    [backView addSubview:firstTextLabel];
    //-----
    x += 70;
    UILabel *secondLabel;
    secondLabel = [self initializeLabel:firstLabel withFrame:CGRectMake(x, 5, w, w) withText:@"2" andTag:2];
    [backView addSubview:secondLabel];
    UIView *secView;
    secView = [self initializeView:secView withColor:[UIColor lightGrayColor] andFrame:CGRectMake(x+w, 24, 31, 2)];
    [backView addSubview:secView];
    UILabel *secTextLabel;
    secTextLabel = [self initializeLabel:secTextLabel withFrame:CGRectMake(x, w+5, w, 15) withText:@"LIST" andTag:12];
    [backView addSubview:secTextLabel];
    //-----
    x += 70;
    UILabel *thirdLabel;
    thirdLabel = [self initializeLabel:thirdLabel withFrame:CGRectMake(x, 5, w, w) withText:@"3" andTag:3];
    [backView addSubview:thirdLabel];
    UIView *thirdView;
    thirdView = [self initializeView:thirdView withColor:[UIColor lightGrayColor] andFrame:CGRectMake(x+w, 24, 31, 2)];
    [backView addSubview:thirdView];
    UILabel *thirdTextLabel;
    thirdTextLabel = [self initializeLabel:thirdTextLabel withFrame:CGRectMake(x-5, w+5, w+10, 15) withText:@"PICTURES" andTag:13];
    [backView addSubview:thirdTextLabel];
    //-----
    x += 70;
    UILabel *forthLabel;
    forthLabel = [self initializeLabel:forthLabel withFrame:CGRectMake(x, 5, w, w) withText:@"4" andTag:4];
    [backView addSubview:forthLabel];
    UILabel *fourthTextLabel;
    fourthTextLabel = [self initializeLabel:fourthTextLabel withFrame:CGRectMake(x, w+5, w, 15) withText:@"TERMS" andTag:14];
    [backView addSubview:fourthTextLabel];
    //-----
}
#pragma mark -
-(UIButton *) initializeButton:(UIButton *)sender withImage:(UIImage *)image andFrame:(CGRect)frame{
    sender = [UIButton buttonWithType:UIButtonTypeCustom];
    [sender setBackgroundImage:image forState:UIControlStateNormal];
    sender.frame = frame;
    return sender;
}
-(UILabel*) initializeLabel:(UILabel *)label withFrame:(CGRect)frame withText:(NSString *)text andTag:(NSInteger )tag{
    label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.tag = tag;
    label.textColor = [UIColor lightGrayColor];
    label.text = text;
    if (tag<10) {
        label.font = [UIFont boldSystemFontOfSize:17.0f];
        label.layer.cornerRadius = frame.size.width/2;
        label.clipsToBounds = YES;
        [self view:label addBorderColor:[UIColor lightGrayColor]];
        label.layer.borderWidth = 2.0;
    }
    else{
        label.font = [UIFont boldSystemFontOfSize:8.0f];
    }
    return label;
}
-(void) view:(UIView *)view addBorderColor:(UIColor *)color{
    view.layer.borderColor = color.CGColor;
}
-(UIView *) initializeView:(UIView *)view withColor:(UIColor *)color andFrame:(CGRect)frame{
    view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}
#pragma mark -
-(void) menuButtonAction:(UIButton *)sender{
    
}
-(void) routeButtonAction:(UIButton *)sender{
    
}
#pragma mark -
-(void) updateViewIndicator:(NSInteger)tagValue{
    UILabel *label = [self viewWithTag:tagValue];
    label.textColor = [UIColor blackColor];
    label.layer.borderColor = [UIColor blackColor].CGColor;
    UILabel *labelText = [self viewWithTag:10+tagValue];
    labelText.textColor = [UIColor blackColor];
}
@end
