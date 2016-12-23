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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"check"]) {
//        carDetailsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"check"];
//        return;
//    }
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
                    [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"check"];
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
        [self hideActivityIndicator];
        [self displayAlertWithTitle:@"No internet connection" withMessage:@"Please check internet connection and try again"];
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
-(void) displayDatePicker:(UITextField *)textField{
    [self configureDatePicker];
    textField.inputView = self.yearPicker;
    textField.inputAccessoryView = self.toolBar;
}
-(void) configureDatePicker{
    if (!self.yearPicker) {
        self.yearPicker = [[UIDatePicker alloc] init];
        self.yearPicker.datePickerMode = UIDatePickerModeDate;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-10];
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [comps setYear:0];
        NSDate *maxDate = [NSDate date];
        
        [self.yearPicker setMaximumDate:maxDate];
        [self.yearPicker setMinimumDate:minDate];
    }
}
#pragma mark -
-(void)configurePickerView{
    if (!self.pickerView) {
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }
    [self.pickerView reloadAllComponents];
}
-(void) configureInputAccessoryView{
    if (!self.toolBar) {
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toolBarDoneButtonAction)];
        self.toolBar.items = @[barButtonItem];
    }
}
-(void) toolBarDoneButtonAction{
    //activeTxtFld.text = [selectionDetailsArray objectAtIndex:row][filterKey];
   // NSInteger row = [self.pickerView selectedRowInComponent:0];
    if(activeTxtFld == self.yearTxtFld){
        self.yearTxtFld.text = [NSString stringWithFormat:@"%@",self.yearPicker.date];
    }
    [self.view endEditing:YES];
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
    activeTxtFld.text = [selectionDetailsArray objectAtIndex:row][filterKey];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component
{
    return [selectionDetailsArray objectAtIndex:row][filterKey];
}
#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 5 || textField.tag == 6) {
        UITextField *nextTxtFld = [self.backView viewWithTag:textField.tag+1];
        [self performSelector:@selector(respondToNextField:) withObject:nextTxtFld afterDelay:0.1];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
-(void)respondToNextField:(UITextField *)nextTxtFld{
    [nextTxtFld becomeFirstResponder];
}
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag != 0 && self.makeTxtFld.text.length<1) {
        return NO;
    }
    return YES;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    activeTxtFld = (CustomTextField *)textField;
    [self displayPickerForTextField:textField];
}
-(void) displayPickerForTextField:(UITextField *)textField{
    if (textField.tag>4) {
        return;
    }
    if (textField.tag != 0 && self.makeTxtFld.text.length<1) {
        return;
    }
    if (textField.tag == 0){
     filterKey = @"Make";
        selectionDetailsArray = [NSArray arrayWithArray:carDetailsArray];
    }
    else if (textField.tag == 1){
        filterKey = @"Model";
        selectionDetailsArray = [self getFilterModel:self.makeTxtFld.text];
    }
    else if(textField.tag == 2){
        NSLog(@"transmission");
        filterKey = @"Transmission";
        selectionDetailsArray = @[@{@"Transmission":@"Manual"},@{@"Transmission":@"Automatic"}];
    }
    else if (textField.tag == 3){
        //NSLog(@"year");
        [self displayDatePicker:textField];
        return;
    }
    else if (textField.tag == 4){
        NSLog(@"fuel type");
        filterKey = @"Fuel";
        selectionDetailsArray = @[@{@"Fuel":@"Gas"},@{@"Fuel":@"Diesel"},@{@"Fuel":@"LPG"}];
    }
    [self configurePickerView];
    textField.inputView = self.pickerView;
    if ([textField.text isEqualToString:@""] && selectionDetailsArray.count>0) {
        textField.text = [selectionDetailsArray objectAtIndex:0][filterKey];
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
    }
    [self configureInputAccessoryView];
    textField.inputAccessoryView = self.toolBar;
}
-(NSArray *) getFilterModel:(NSString *)make{
    NSArray *filteredModel = [carDetailsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.Make == %@",make]];
    return filteredModel;
}
#pragma mark -
#pragma mark - Keyboard Appearance Notification Observer
-(void) handleKeyboardChangeFrameNotification:(NSNotification *)notify{
    NSDictionary* notificationInfo = [notify userInfo];
    CGRect keyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = activeTxtFld.frame;
    
    CGFloat y = frame.origin.y + 230;
    
    CGFloat v  = self.view.frame.size.height-keyboardFrame.size.height;
    if (y > v) {
        [self updateTopLayoutConstraint:-(y - v)];
    }
    else{
        [self updateTopLayoutConstraint:0];
    }
}
-(void) handleKeyboardWillHideNotification:(NSNotification *)notify{
    [self updateTopLayoutConstraint:0];
}
#pragma mark -
-(void) updateTopLayoutConstraint:(NSInteger)constValue{
    self.topLayoutConstraint.constant = constValue;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark -
- (IBAction)nextButtonAction:(UIButton *)sender{
    if (self.makeTxtFld.text.length<1 || self.modelTxtFld.text.length<1 || self.transmissionTxtFld.text.length<1 || self.yearTxtFld.text.length<1 || self.fuelTxtFld.text.length<1 || self.registrationTxtFld.text.length<1 || self.kmTxtFld.text.length<1 || self.carAddressTxtFld.text.length<1) {
        [self displayAlertWithTitle:@"" withMessage:@"All fields are mandatory"];
        return;
    }
    NSArray *tempArray = [self getFilterModel:self.makeTxtFld.text];
    if (tempArray.count<1) {
        return;
    }
    NSDictionary *dict = [tempArray objectAtIndex:0];
    [self makeRequestForAddCar:dict];
}
-(void) makeRequestForAddCar:(NSDictionary *)dict{
    [self displayActivityIndicator];
    NSDictionary *carType = @{@"Id":dict[@"Id"], @"Make":self.makeTxtFld.text,@"Model":self.modelTxtFld.text,@"Transmission":@"",@"Fuel":@"", @"Category":dict[@"Category"]};
    NSDictionary *postDict = @{@"CarType":carType, @"Year":self.yearTxtFld.text, @"Odometer":self.kmTxtFld.text, @"Address":self.carAddressTxtFld.text,@"Registration":self.registrationTxtFld.text};
    NetworkHandler *networkHandler = [[NetworkHandler alloc] init];
    [networkHandler makePostRequestWithUri:addOwnerCar parameters:postDict withCompletion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            [self hideActivityIndicator];
            [self displayAlertWithTitle:@"Error" withMessage:error.localizedDescription];
            return ;
        }
        if (urlResponse.statusCode == 200) {
            [self hideActivityIndicator];
            if([response isKindOfClass:[NSDictionary class]]){
                dispatch_async(dispatch_get_main_queue(), ^{
                   NSLog(@"jsoon dict = %@", response);
                });
            }
        }
        else{
            NSLog(@"Display error message");
            [self hideActivityIndicator];
            if([response isKindOfClass:[NSDictionary class]]){
                if (response[@"Message"]) {
                    [self displayAlertWithTitle:@"Error" withMessage:response[@"Message"]];
                }
                else if (response[@"error_description"]){
                    [self displayAlertWithTitle:@"Error" withMessage:response[@"error_description"]];
                }
                else if (response[@"error"]) {
                    [self displayAlertWithTitle:@"Error" withMessage:response[@"error"]];
                }
            }
            else{
                [self displayAlertWithTitle:@"Error" withMessage:@"Please try again"];
            }
        }
    } withNetworkFailureBlock:^(NSString *message) {
        [self hideActivityIndicator];
        [self displayAlertWithTitle:@"No internet connection" withMessage:@"Please check internet connection and try again"];
    }];
}
-(void) gotoCarAvtarUploadController{
    UploadCarAvtarViewController *avtarController = [[UploadCarAvtarViewController alloc] initWithNibName:@"UploadCarAvtarViewController" bundle:nil];
    [self.navigationController pushViewController:avtarController animated:YES];
}
@end
