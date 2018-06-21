//
//  TableViewController.m
//  UITableViewStaticHW
//
//  Created by Ivan Kozaderov on 07.06.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//

#import "TableViewController.h"

static NSString *kSettingsFirstName = @"FirstName";
static NSString *kSettingsLastName = @"LastName";
static NSString *kSettingsLogin = @"Login";
static NSString *kSettingsPassword = @"Password";
static NSString *kSettingsAge = @"Age";
static NSString *kSettingsPhoneNumber = @"PhoneNumber";
static NSString *kSettingsEmail = @"Email";
static NSString *kSettingsShadows = @"Shadows";
static NSString *kSettingsDetalization = @"Detalization";
static NSString *kSettingsVolume = @"Volume";
static NSString *kSettingsMusic = @"Music";
static NSString *kSettingsComplexity = @"Complexity";
static NSString *kSettingsParentControl = @"ParentControl";

@interface TableViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self loadSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Save and Load

- (void)saveSettings {
    
    [self.userDefaults setBool: self.shadowsSwitch.isOn forKey:kSettingsShadows];
    [self.userDefaults setInteger: self.detalizationControl.selectedSegmentIndex forKey:kSettingsDetalization];
    [self.userDefaults setFloat: self.musicSlider.value forKey:kSettingsMusic];
    [self.userDefaults setFloat: self.volumeSlider.value forKey:kSettingsVolume];
    [self.userDefaults setInteger: self.complexityControl.selectedSegmentIndex forKey:kSettingsComplexity];
    [self.userDefaults setBool: self.parentControlSwitch.isOn forKey:kSettingsParentControl];
    
    [self.userDefaults setObject: self.firstNameField.text forKey:kSettingsFirstName];
    [self.userDefaults setObject: self.lastNameField.text forKey:kSettingsLastName];
    [self.userDefaults setObject: self.loginField.text forKey:kSettingsLogin];
    [self.userDefaults setObject: self.passwordField.text forKey:kSettingsPassword];
    [self.userDefaults setObject: self.ageField.text forKey:kSettingsAge];
    [self.userDefaults setObject: self.phoneNumberField.text forKey:kSettingsPhoneNumber];
    [self.userDefaults setObject: self.emailField.text forKey:kSettingsEmail];
    
    [self.userDefaults synchronize];
}


- (void)loadSettings {
    
    self.shadowsSwitch.on = [self.userDefaults boolForKey:kSettingsShadows];
    self.detalizationControl.selectedSegmentIndex = [self.userDefaults integerForKey:kSettingsDetalization];
    self.musicSlider.value = [self.userDefaults floatForKey:kSettingsMusic];
    self.volumeSlider.value = [self.userDefaults floatForKey:kSettingsVolume];
    self.complexityControl.selectedSegmentIndex = [self.userDefaults integerForKey:kSettingsComplexity];
    self.parentControlSwitch.on = [self.userDefaults boolForKey:kSettingsParentControl];
    
    self.firstNameField.text = [self.userDefaults objectForKey:kSettingsFirstName];
    self.lastNameField.text = [self.userDefaults stringForKey:kSettingsLastName];
    self.loginField.text = [self.userDefaults objectForKey:kSettingsLogin];
    self.passwordField.text = [self.userDefaults stringForKey:kSettingsPassword];
    self.ageField.text = [self.userDefaults objectForKey:kSettingsAge];
    self.phoneNumberField.text = [self.userDefaults stringForKey:kSettingsPhoneNumber];
    self.emailField.text = [self.userDefaults stringForKey:kSettingsEmail];
    
}

#pragma  mark - Actions

- (IBAction)actionValueChanged:(id)sender {
    [self saveSettings];
}

- (IBAction)actionTextChanged:(UITextField *)sender {
    [self saveSettings];
}

#pragma  mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentRegistrationField = (RegistrationField) [self.registrationFields indexOfObject:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:[self.registrationFields lastObject]]) {
        [[self.registrationFields lastObject] resignFirstResponder];
    } else {
        NSUInteger index = [self.registrationFields indexOfObject:textField];
        [self.registrationFields[index + 1] becomeFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL shouldChange = YES;
    
    switch (self.currentRegistrationField) {
        case RegistrationFieldFirstName:
        case RegistrationFieldLastName:
            shouldChange = [self shouldValidateText:textField.text
                                  replacementString:string
                                          maxLength:15
                                          isDigital:NO];
            break;
            
        case RegistrationFieldLogin:
        case RegistrationFieldPassword:
            shouldChange = [self registrationTextField:textField
                         shouldChangeCharactersInRange:range
                                     replacementString:string];
            break;
        case RegistrationFieldAge:
            shouldChange = [self shouldValidateText:textField.text
                                  replacementString:string
                                          maxLength:1
                                          isDigital:YES];
            break;
        case RegistrationFieldPhoneNumber:
            shouldChange = [self textPhoneField:textField
                  shouldChangeCharactersInRange:range
                              replacementString:string];
            break;
        case RegistrationFieldEmail:
            shouldChange = [self textEmailField:textField
                  shouldChangeCharactersInRange:range
                              replacementString:string];
            break;
    }
    
    return shouldChange;
}


#pragma mark - Fields Validation

- (BOOL)shouldValidateText:(NSString *)text replacementString:(NSString *)replacementString maxLength:(int)maxLength isDigital:(int)isDigital {
    NSCharacterSet *validationSet = [NSCharacterSet decimalDigitCharacterSet];
    if (isDigital) {
        validationSet = [validationSet invertedSet];
    }
    NSArray *components = [replacementString componentsSeparatedByCharactersInSet:validationSet];
    return [components count] <= 1 && [text length] <= maxLength;
}

- (BOOL)textPhoneField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSCharacterSet *validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSArray *components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //  NSLog(@"newString=%@",newString);
    
    NSArray *validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    
    newString = [validComponents componentsJoinedByString:@""];
    
    //  NSLog(@"newString fixed=%@",newString);
    
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 3;
    
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
        
        return NO;
    }
    
    
    NSMutableString *resultString = [NSMutableString string];
    
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
    
    
    if (localNumberLength > 0) {
        
        NSString *number = [newString substringFromIndex:(NSUInteger) [newString length] - localNumberLength];
        
        [resultString appendString:number];
        
        if ([resultString length] > 3) {
            
            [resultString insertString:@"-" atIndex:3];
        }
        
    }
    
    
    if ([newString length] > localNumberMaxLength) {
        
        NSInteger areaCodeLength = MIN([newString length] - localNumberMaxLength, areaCodeMaxLength);
        
        NSRange areaRange = NSMakeRange([newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        
        NSString *area = [newString substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@) ", area];
        
        [resultString insertString:area atIndex:0];
    }
    
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
        
        
        NSInteger countryCodeLength = MIN((int) [newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
        
        NSString *countryCode = [newString substringWithRange:countryCodeRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        
        [resultString insertString:countryCode atIndex:0];
    }
    
    textField.text = resultString;
    
    return NO;
    
}

- (BOOL)textEmailField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //localPart@serverPart
    //localPart  10
    //serverPart 10
    
    static const int localPartMaxLength = 10;
    static const int serverPartMaxLength = 10;
    
    static NSString *symbolsString = @"!#$%&'*+-/=?^_`{|}~[],";
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *symbolsSet = [NSCharacterSet characterSetWithCharactersInString:symbolsString];
    NSArray *components = [newString componentsSeparatedByCharactersInSet:symbolsSet];
    
    BOOL shouldChange;
    shouldChange = [components count] <= 1;
    shouldChange = !(([newString length] == 1) && ([string isEqualToString:@"@"] || [string isEqualToString:@"."]));
    shouldChange = [self check:newString byCharacter: @"@"];
    shouldChange = [self check:newString byCharacter: @"."];
    shouldChange = [newString length] <= localPartMaxLength + serverPartMaxLength;
    return shouldChange;
    
}

- (BOOL)check:(NSString *)string byCharacter: (NSString *) str {
    NSCharacterSet *atSymbolSet = [NSCharacterSet characterSetWithCharactersInString:str];
    NSArray *validAtComponents = [string componentsSeparatedByCharactersInSet:atSymbolSet];
    return [validAtComponents count] <= 2;
}

- (BOOL)registrationTextField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return [newString length] <= 16;
}


@end
