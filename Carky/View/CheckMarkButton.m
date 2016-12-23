//
//  CheckMarkButton.m
//  Carky
//
//  Created by Avinash Kashyap on 12/23/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "CheckMarkButton.h"

@implementation CheckMarkButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
}
-(void) setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected == YES) {
        NSLog(@"Selected");
        self.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else{
        self.layer.borderColor = [UIColor redColor].CGColor;
    }
}
@end
