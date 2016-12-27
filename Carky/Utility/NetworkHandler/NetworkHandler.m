//
//  NetworkHandler.m
//  eDuru
//
//  Created by Avinash Kashyap on 10/20/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "NetworkHandler.h"
#import "Reachability.h"


@implementation NetworkHandler

#pragma mark -
-(BOOL) checkNetworkStatus{
    Reachability *reachability = [Reachability reachabilityWithHostName: @"www.google.co.in"];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL isNetworkAvailable = NO;
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            isNetworkAvailable = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            isNetworkAvailable = YES;
            break;
        }
        case NotReachable:
        {
            isNetworkAvailable = NO;
        }
    }
    //isNetworkAvailable = NO;
    reachability = nil;
    return isNetworkAvailable;
}

#pragma mark -
-(NSMutableDictionary *) addDefaultparamsToPostData:(NSDictionary *)dict{
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:@"123456789" forKey:@"device_token"];
    [postDict setObject:KPlateform forKey:@"platform"];
    [postDict setObject:@"123456789" forKey:@"ud_id"];
    [postDict addEntriesFromDictionary:dict];
    return postDict;
}
#pragma mark -
-(void) makeGetRequestWithUri:(NSString *)uri withCompletion:(CompletionBlock)completion withNetworkFailureBlock:(NetworkFailureBlock)networkBlock{
    if ([self checkNetworkStatus] == NO) {
        networkBlock(KNetworkFailureMessage);
        return;
    }
    NSMutableURLRequest *request = [self makeHttpRequestWithUrl:uri];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KAppAuthenticationToken]) {
        [request setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:KAppAuthenticationToken]] forHTTPHeaderField:@"Authorization"];
    }
    [self httpConnectionWithRequest:request withCompletion:completion];
}
-(void) makePostRequestWithUri:(NSString *)uri parameters:(NSDictionary *)postDict withCompletion:(CompletionBlock)completion withNetworkFailureBlock:(NetworkFailureBlock)networkBlock{
    if ([self checkNetworkStatus] == NO) {
        networkBlock(KNetworkFailureMessage);
        return;
    }
    
    NSMutableURLRequest *request = [self makeHttpRequestWithUrl:uri];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KAppAuthenticationToken]) {
        [request setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:KAppAuthenticationToken]] forHTTPHeaderField:@"Authorization"];
    }
    NSError *error;
    //NSDictionary *postInfo = [self addDefaultparamsToPostData:postDict];
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:postdata];
    [self httpConnectionWithRequest:request withCompletion:completion];
}
-(void) makeunlencodedPostRequestwith:(NSString *)uri parameters:(NSString *)postString withCompletion:(CompletionBlock)completion withNetworkFailureBlock:(NetworkFailureBlock)networkBlock{
    if ([self checkNetworkStatus] == NO) {
        networkBlock(KNetworkFailureMessage);
        return;
    }
    NSMutableURLRequest *request = [self makeHttpRequestWithUrl:uri];
    request.HTTPMethod = @"POST";
//    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //NSError *error;
    NSData *postdata = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%zd", [postdata length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.0];
    [request setHTTPBody:postdata];
    [self httpConnectionWithRequest:request withCompletion:completion];
}
-(NSMutableURLRequest *) makeHttpRequestWithUrl:(NSString *)urlString{
    // urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:<#(nonnull NSCharacterSet *)#>];
    urlString = [NSString stringWithFormat:@"%@%@",baseUrl, urlString];
    return [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:90.0];
}
-(void) httpConnectionWithRequest:(NSMutableURLRequest *)request withCompletion:(CompletionBlock)completion{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"url = %@",location);
        NSLog(@"resposne = %@", response);
        NSLog(@"Error = %@",error);
        if (error) {
            completion(nil,(NSHTTPURLResponse *)response, error);
            return ;
        }
        //-----
        NSData *data = [NSData dataWithContentsOfURL:location];
        id locationresponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (locationresponse != nil) {
            NSLog(@"\n\n\n");
            NSLog(@"location response = %@",locationresponse);
            completion(locationresponse,(NSHTTPURLResponse *)response, error);
        }
        else{
            NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"str = %@", str);
            completion(str, (NSHTTPURLResponse *)response,error);
        }
        
    }];
    [task resume];
}

#pragma mark -
-(void) makeRquestForUploadImages:(NSArray*)imageList withUri:(NSString *)uri postData:(NSDictionary *)postData withCompletionHandler:(CompletionBlock)completionBloack withNetworkFailureBlock:(NetworkFailureBlock)networkBlock{
    
    if ([self checkNetworkStatus] == NO) {
        networkBlock(KNetworkFailureMessage);
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:KAppAuthenticationToken]] forHTTPHeaderField:@"Authorization"];
    NSString *boundary = @"-------------------------0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [manager.requestSerializer setValue:contentType forHTTPHeaderField:@"mimeType"];
    [manager.requestSerializer setValue:@"false" forHTTPHeaderField:@"Content-Type"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseUrl, uri];
    NSArray *nameKeyArray = @[@"sidepic",@"frontpic",@"outsidepic",@"insidepic"];
    [manager method:@"POST" andUrl:urlString parameters:postData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        int i = 0;
        for(UIImage *image in imageList){
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%@",nameKeyArray[i]] fileName:[NSString stringWithFormat:@"%@.jpeg",[nameKeyArray objectAtIndex:i]] mimeType:@"image/jpeg"];
            i++;
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response upload image: %@", responseObject);
        if(operation.response.statusCode == 200){
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Response Object Error= %@ \n \nError = %@",operation.responseObject,error);
    }];
}
#pragma mark -
-(void)addCar:(NSString *)uri withImages:(NSArray *)imageList postData:(NSDictionary *)postDict withCompletion:(CompletionBlock)completion withNetworkFailureBlock:(NetworkFailureBlock)networkBlock
{
    if ([self checkNetworkStatus] == NO) {
        networkBlock(KNetworkFailureMessage);
        return;
    }

    //NSString *boundary =[NSString stringWithFormat:@"Boundary-%@",[[NSUUID UUID] UUIDString]];// @"-------------------------0xKhTmLbOuNdArY";
    
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    NSMutableURLRequest *request = [self makeHttpRequestWithUrl:uri];
    request.HTTPMethod = @"POST";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
   // [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
   // contentType =@"multipart/form-data";
    
    [request addValue:@"false" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"false" forHTTPHeaderField:@"processData"];
//    [request addValue:@"form" forHTTPHeaderField:@"data"];
    [request addValue:contentType forHTTPHeaderField:@"mimeType"];
    [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request addValue:@"18484b99-1932-6a8f-e6e7-7f6b8e64e1f9" forHTTPHeaderField:@"postman-token"];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:KAppAuthenticationToken]) {
        [request setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:KAppAuthenticationToken]] forHTTPHeaderField:@"Authorization"];
    }
   
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"param1\";\r\n\r\n%@", @"10001"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSArray *imageNameArray = @[@"sidepic",@"frontpic",@"outsidepic",@"insidepic"];
    NSString *mimetype = [NSString stringWithFormat:@"multipart/form-data"];
    for (int i=0; i<imageList.count; i++)
    {
        NSData *imageData = UIImagePNGRepresentation([imageList objectAtIndex:i]);//UIImageJPEGRepresentation([imageList objectAtIndex:i],1);
        NSString *despo = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.png\"\r\n",[imageNameArray objectAtIndex:i] ,[imageNameArray objectAtIndex:i]];
        NSLog(@"despo = %@", despo);
        if (imageData)
        {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.png\"\r\n",[imageNameArray objectAtIndex:i] ,[imageNameArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",contentType] dataUsingEncoding:NSUTF8StringEncoding]];
           // [body appendData:[[NSString stringWithFormat:@"mimeType: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            
            
            
            
            
            /*
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpeg\"\r\n",[imageNameArray objectAtIndex:i],[imageNameArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            //[body appendData:[[NSString stringWithFormat:@"mimeType: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            //[body appendData:[[NSString stringWithFormat:@"processData: false\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];*/
        }
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
   // NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setHTTPMethod:@"POST"];
  //  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    [self httpConnectionWithRequest:request withCompletion:completion];
}
@end
