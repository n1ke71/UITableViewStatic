//
//  TableViewController.h
//  UITableViewStaticHW
//
//  Created by Ivan Kozaderov on 07.06.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    
    RegistrationFieldFirstName,
    RegistrationFieldLastName,
    RegistrationFieldLogin,
    RegistrationFieldPassword,
    RegistrationFieldAge,
    RegistrationFieldPhoneNumber,
    RegistrationFieldEmail,
    
}RegistrationField;

@interface TableViewController : UITableViewController <UITextFieldDelegate>

@property(assign,nonatomic) RegistrationField currentRegistrationField;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;

@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@property (weak, nonatomic) IBOutlet UITextField *loginField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *ageField;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet UISwitch *shadowsSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *detalizationControl;

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (weak, nonatomic) IBOutlet UISlider *musicSlider;

@property (weak, nonatomic) IBOutlet UISegmentedControl *complexityControl;

@property (weak, nonatomic) IBOutlet UISwitch *parentControlSwitch;


@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *registrationFields;

- (IBAction)actionValueChanged:(id)sender;

- (IBAction)actionTextChanged:(UITextField *)sender;


@end
