//
//  MediaSelectionController.h
//  Figs
//
//  Created by Avinash Kashyap on 12/15/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

typedef NS_ENUM (NSInteger, MediaPickerSourceType){
    MediaPickerSourceImage,
    MediaPickerSourceVideo,
    MediaPickerSourcePhotoAlbum,
    MediaPickerSourceVideoAlbum
};
typedef void(^MediaCompletionBlock)(id response, NSError *error);

@interface MediaSelectionController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    MediaCompletionBlock mediaCompletionBlock;
    UIViewController *ownerController;
}
//create instance
+(MediaSelectionController *) mediaManager;
//create instance with owner controller
+(MediaSelectionController *) mediaManagerWithController:(UIViewController *)controller;
//set owner controller
-(void) setOwnerController:(UIViewController*)con;
//display image picker
-(void) displayImagePickerWithSource:(MediaPickerSourceType)sourceType withCompletionBlock:(MediaCompletionBlock)completionBlock;
@end
