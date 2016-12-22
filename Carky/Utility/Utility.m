//
//  Utility.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "Utility.h"

@implementation Utility
+(BOOL) validateEmail:(NSString *)email{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL) checkNumberString:(NSString *)string{
    //^[0-9]*$
    NSString *laxString = @"^[0-9]*$";
    NSPredicate *numberCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", laxString];
    return [numberCheck evaluateWithObject:string];
    
}
@end
