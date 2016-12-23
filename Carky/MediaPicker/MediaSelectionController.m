//
//  MediaSelectionController.m
//  Figs
//
//  Created by Avinash Kashyap on 12/15/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "MediaSelectionController.h"

@interface MediaSelectionController ()

@end

@implementation MediaSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+(MediaSelectionController *) mediaManager{
    return [[self alloc] initWithController:nil];
}
-(void) setOwnerController:(UIViewController*)con{
    ownerController = con;
}
+(MediaSelectionController *) mediaManagerWithController:(UIViewController *)controller{
    return [[self alloc] initWithController:controller];
}
-(instancetype) initWithController:(UIViewController *)controller{
    self = [super init];
    if (self) {
        if (controller != nil) {
            ownerController = controller;
            [controller addChildViewController:self];
        }
        
    }
    return self;
}
#pragma mark - Display Image Picker
-(void) displayImagePickerWithSource:(MediaPickerSourceType)sourceType withCompletionBlock:(MediaCompletionBlock)completionBlock{
    if (ownerController == nil) {
        [self displayAlertMessageWithTitle:@"" message:@"Need a root controller for display picker view" andType:0];
        return;
    }
    mediaCompletionBlock = completionBlock;
    if (sourceType == MediaPickerSourceImage || sourceType == MediaPickerSourceVideo) {
        NSString *model = [[UIDevice currentDevice] model];
        if ([model isEqualToString:@"iPhone Simulator"]) {
            //device is simulator
            NSLog(@"device running on simulator");
            [self displayAlertMessageWithTitle:@"" message:@"Need a real device for capture image and video." andType:0];
            return;
        }
        [self displayImagePickerWithSource:sourceType];
    }
    else{
       [self displayImagePickerWithSource:sourceType];
    }
}
#pragma mark -
-(void) displayImagePickerWithSource:(MediaPickerSourceType) source{
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    if (source == MediaPickerSourceImage || source == MediaPickerSourceVideo) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    pickerController.view.tag = 1;
    //check source and set media
    if (source == MediaPickerSourceVideo || source == MediaPickerSourceVideoAlbum) {
        pickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        pickerController.view.tag = 2;
    }
    pickerController.delegate = self;
    pickerController.modalInPopover = NO;
    [ownerController presentViewController:pickerController animated:YES completion:nil];
}
#pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (picker.view.tag == 1) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        if (picker.sourceType != UIImagePickerControllerSourceTypeCamera) {
            if (image.size.width>3264 || image.size.height>3264) {
                [self displayAlertMessageWithTitle:@"" message:@"Currently we support only images of maximum resolution to 4000x3000 pixels and less than 1Mb in size." andType:0];
                return;
            }
        }
        mediaCompletionBlock(image,nil);
    }
    else if (picker.view.tag == 2){
        NSString *videoUrlStr = [NSString stringWithFormat:@"%@",info[UIImagePickerControllerMediaURL]];
        mediaCompletionBlock(videoUrlStr,nil);
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Alert Message
-(void) displayAlertMessageWithTitle:(NSString *)title message:(NSString *)message andType:(NSInteger)type{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
