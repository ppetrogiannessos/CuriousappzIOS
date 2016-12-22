//
//  NetworkHandler.h
//  eDuru
//
//  Created by Avinash Kashyap on 10/20/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(id response, NSHTTPURLResponse *urlResponse,NSError *error);
typedef void (^NetworkFailureBlock)(NSString *message);
#define KPlateform @"iOS"
#define KNetworkFailureMessage @"No network available"
#define KAppAuthenticationToken @"access_token"

static NSString *baseUrl = @"http://carky-app.azurewebsites.net";
static NSString *userRegistration = @"/api/Account/Register";
static NSString *phoneNumberVerification = @"/api/Account/ConfirmPhoneNumber";
static NSString *addClientRole = @"";
static NSString *addCarOwnerRole = @"";
static NSString *resendCode = @"/api/Account/ConfirmPhoneNumber";
static NSString *getAllCarType = @"/api/Helper/GetAllCarTypes";
static NSString *addOwnerCar = @"/api/CarOwner/AddCar";
static NSString *uploadCarPhotos = @"/api/CarOwner/UploadCarPhotos";
static NSString *fetchTerms = @"/api/Account/FetchTerms";

@interface NetworkHandler : NSObject

@property (nonatomic, strong) NSString *deviceToken;

//Get request for fetch data from server
-(void) makeGetRequestWithUri:(NSString *)uri withCompletion:(CompletionBlock)completion withNetworkFailureBlock:(NetworkFailureBlock)networkBlock;

//Post request 
-(void) makePostRequestWithUri:(NSString *)uri parameters:(NSDictionary *)postDict withCompletion:(CompletionBlock)completion withNetworkFailureBlock:(NetworkFailureBlock)networkBlock;
@end
