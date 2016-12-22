//
//  CustomTextField.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

-(void) awakeFromNib{
    [super awakeFromNib];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextAddPath(context, path.CGPath);
    CGContextSetLineWidth(context, 3);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextRestoreGState(context);
}


@end
