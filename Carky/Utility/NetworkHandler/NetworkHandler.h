//
//  NetworkHandler.h
//  eDuru
//
//  Created by Avinash Kashyap on 10/20/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

typedef void(^CompletionBlock)(id response, NSHTTPURLResponse *urlResponse,NSError *error);
typedef void (^NetworkFailureBlock)(NSString *message);
#define KPlateform @"iOS"
#define KNetworkFailureMessage @"No network available"
#define KAppAuthenticationToken @"access_token"

static NSString *baseUrl = @"http://carky-app.azurewebsites.net";
static NSString *userRegistration = @"/api/Account/Register";
static NSString *getToken = @"/token";
static NSString *phoneNumberVerification = @"/api/Account/SendPhoneNumberConfirmation";
static NSString *confirmPhoneNumber = @"/api/Account/ConfirmPhoneNumber";
static NSString *addClientRole = @"/api/Account/AddClientRole";
static NSString *addCarOwnerRole = @"/api/Account/AddCarOwnerRole";
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
//-
//-
-(void) makeunlencodedPostRequestwith:(NSString *)uri parameters:(NSString *)postString withCompletion:(CompletionBlock)completion withNetworkFailureBlock:(NetworkFailureBlock)networkBlock;
-(void) makeRquestForUploadImages:(NSArray*)imageList withUri:(NSString *)uri postData:(NSDictionary *)postData withCompletionHandler:(CompletionBlock)completionBloack withNetworkFailureBlock:(NetworkFailureBlock)networkBlock;

-(void)addCar:(NSString *)uri withImages:(NSArray *)imageList postData:(NSDictionary *)postDict withCompletion:(CompletionBlock)completion withNetworkFailureBlock:(NetworkFailureBlock)networkBlock;
@end
