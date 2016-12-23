//
//  CarDetailsViewController.m
//  Carky
//
//  Created by Avinash Kashyap on 12/22/16.
//  Copyright © 2016 CuriousAppz. All rights reserved.
//

#import "CarDetailsViewController.h"
#import "UIController.h"
#import "UploadCarAvtarViewController.h"
#import "NetworkHandler.h"
#import "CAActivityIndicatorView.h"

@interface CarDetailsViewController ()
{
    CAActivityIndicatorView *caActivityIndicator;
    NSString *filterKey;
}
@end

@implementation CarDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.makeImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.modelImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.transmissionImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.fuelImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.registationImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.kmImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.carAddressImageView];
    [[UIController sharedInstance] addBorderWithWidth:1.0f withColor:[UIColor lightGrayColor] withCornerRadious:20.0f toView:self.yearImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headerView updateViewIndicator:2];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self getAllCarType];
    //[self getTerms];
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark -
-(void) displayActivityIndicator{
    if (!caActivityIndicator) {
        caActivityIndicator = [[CAActivityIndicatorView alloc] initWithFrame:self.navigationController.view.frame];
    }
    [self.navigationController.view addSubview:caActivityIndicator];
    // [caActivityIndicator setMessageText:@"Exporting video"];
    [caActivityIndicator displayActivityIndicatorView];
}
-(void) hideActivityIndicator{
    dispatch_async(dispatch_get_main_queue(), ^{
        [caActivityIndicator hideActivityIndicatorView];
    });
    
}
#pragma mark -
-(void) getAllCarType{
    [self displayActivityIndicator];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    [networkHandler makeGetRequestWithUri:getAllCarType withCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self hideActivityIndicator];
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            return ;
        }
        if (urlResponse.statusCode == 200) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivityIndicator];
                if ([response isKindOfClass:[NSArray class]]){
                    carDetailsArray = [NSArray arrayWithArray:response];
                }
                else{
                    [self displayAlertWithTitle:@"Error" withMessage:@"Please try again"];
                }
            });
        }
        else{
            NSLog(@"Display error message");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivityIndicator];
                if([response isKindOfClass:[NSDictionary class]]){
                    if (response[@"Message"]) {
                        [self displayAlertWithTitle:@"Error" withMessage:response[@"Message"]];
                    }
                }
                else{
                    [self displayAlertWithTitle:@"Error" withMessage:@"Please try again"];
                }
            });
            
        }
    } withNetworkFailureBlock:^(NSString *message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayAlertWithTitle:@"Error" withMessage:message];
        });
    }];
}
#pragma mark -
#pragma mark -
-(void) getTerms{
    [self displayActivityIndicator];
    NSDictionary *postDict = @{@"Culture":@"sample string 1"};
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    [networkHandler makePostRequestWithUri:fetchTerms parameters:postDict withCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self hideActivityIndicator];
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            return ;
        }
        if (urlResponse.statusCode == 200) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivityIndicator];
                if ([response isKindOfClass:[NSArray class]]){
                    carDetailsArray = [NSArray arrayWithArray:response];
                }
                else{
                    [self displayAlertWithTitle:@"Error" withMessage:@"Please try again"];
                }
            });
        }
        else{
            NSLog(@"Display error message");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivityIndicator];
                if([response isKindOfClass:[NSDictionary class]]){
                    if (response[@"Message"]) {
                        [self displayAlertWithTitle:@"Error" withMessage:response[@"Message"]];
                    }
                }
                else{
                    [self displayAlertWithTitle:@"Error" withMessage:@"Please try again"];
                }
            });
        }
        
    } withNetworkFailureBlock:^(NSString *message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayAlertWithTitle:@"Error" withMessage:message];
        });
    }];
 
}

#pragma mark -
-(void) displayAlertWithTitle:(NSString *)title withMessage:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}
#pragma mark -
-(void)configurePickerView{
    if (!self.pickerView) {
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }
    [self.pickerView reloadAllComponents];
}
#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [selectionDetailsArray count];
}

#pragma mark - Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //activeTextField.text = [event objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component
{
    return [selectionDetailsArray objectAtIndex:row][filterKey];
}
#pragma mark - UITextFieldDelegate
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    [self displayPickerForTextField:textField];
}
-(void) displayPickerForTextField:(UITextField *)textField{
    if (textField.tag>4) {
        return;
    }
    activeTxtFld = (CustomTextField *)textField;
    if (textField.tag == 0){
     filterKey = @"Make";
    }
    else if (textField.tag == 1){
        filterKey = @"Model";
    }
}
#pragma mark -
- (IBAction)nextButtonAction:(UIButton *)sender{
    [self gotoCarAvtarUploadController];
}
-(void) gotoCarAvtarUploadController{
    UploadCarAvtarViewController *avtarController = [[UploadCarAvtarViewController alloc] initWithNibName:@"UploadCarAvtarViewController" bundle:nil];
    [self.navigationController pushViewController:avtarController animated:YES];
}
@end
