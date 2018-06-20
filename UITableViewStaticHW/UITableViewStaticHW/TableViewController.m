//
//  TableViewController.m
//  UITableViewStaticHW
//
//  Created by Ivan Kozaderov on 07.06.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//

#import "TableViewController.h"

static NSString* kSettingsFirstName       = @"FirstName"     ;
static NSString* kSettingsLastName        = @"LastName "     ;
static NSString* kSettingsLogin           = @"Login"         ;
static NSString* kSettingsPassword        = @"Password "     ;
static NSString* kSettingsAge             = @"Age "          ;
static NSString* kSettingsPhoneNumber     = @"PhoneNumber"   ;
static NSString* kSettingsEmail           = @"Email "        ;
static NSString* kSettingsShadows         = @"Shadows"       ;
static NSString* kSettingsDetalization    = @"Detalization " ;
static NSString* kSettingsVolume          = @"Volume "       ;
static NSString* kSettingsMusic           = @"Music "        ;
static NSString* kSettingsComplexity      = @"Complexity "   ;
static NSString* kSettingsParentControl   = @"ParentControl ";

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadSettings];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Save and Load

-(void)saveSettings{
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:self.shadowsSwitch.isOn                           forKey:kSettingsShadows];
    [userDefaults setInteger:self.detalizationControl.selectedSegmentIndex  forKey:kSettingsDetalization];
    [userDefaults setFloat:self.musicSlider.value                           forKey:kSettingsMusic];
    [userDefaults setFloat:self.volumeSlider.value                          forKey:kSettingsVolume];
    [userDefaults setInteger:self.complexityControl.selectedSegmentIndex    forKey:kSettingsComplexity];
    [userDefaults setBool:self.parentControlSwitch.isOn                     forKey:kSettingsParentControl];
    
    [userDefaults setObject:self.firstNameField.text forKey:kSettingsFirstName];
    
    [userDefaults setObject:self.lastNameField.text forKey:kSettingsLastName];
    
    [userDefaults setObject:self.loginField.text forKey:kSettingsLogin];
    
    [userDefaults setObject:self.passwordField.text forKey:kSettingsPassword];
    
    [userDefaults setObject:self.ageField.text forKey:kSettingsAge];
    
    [userDefaults setObject:self.phoneNumberField.text forKey:kSettingsPhoneNumber];
    
    [userDefaults setObject:self.emailField.text forKey:kSettingsEmail];
    
    [userDefaults synchronize];
}


-(void)loadSettings{
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];

    self.shadowsSwitch.on                         = [userDefaults boolForKey:kSettingsShadows];
    self.detalizationControl.selectedSegmentIndex = [userDefaults integerForKey:kSettingsDetalization];
    self.musicSlider.value                        = [userDefaults floatForKey:kSettingsMusic];
    self.volumeSlider.value                       = [userDefaults floatForKey:kSettingsVolume];
    self.complexityControl.selectedSegmentIndex   = [userDefaults integerForKey:kSettingsComplexity];
    self.parentControlSwitch.on                   = [userDefaults boolForKey:kSettingsParentControl];
    
    self.firstNameField.text    = [userDefaults objectForKey:kSettingsFirstName];
    self.lastNameField.text     = [userDefaults stringForKey:kSettingsLastName];
    self.loginField.text        = [userDefaults objectForKey:kSettingsLogin];
    self.passwordField.text     = [userDefaults stringForKey:kSettingsPassword];
    self.ageField.text          = [userDefaults objectForKey:kSettingsAge];
    self.phoneNumberField.text  = [userDefaults stringForKey:kSettingsPhoneNumber];
    self.emailField.text        = [userDefaults stringForKey:kSettingsEmail];

}

#pragma  mark - Actions

- (IBAction)actionValueChanged:(id)sender {
    
     [self saveSettings];
}

- (IBAction)actionTextChanged:(UITextField *)sender {
    
    [self saveSettings];
    
}

#pragma  mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.currentRegistrationField = (int) [self.registrationFields indexOfObject:textField];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if ([textField isEqual:[self.registrationFields lastObject]]) {
        
        [[self.registrationFields lastObject] resignFirstResponder];
        
    }
    
    else {
        
        NSUInteger index =  [self.registrationFields indexOfObject:textField];
        [[self.registrationFields objectAtIndex: index + 1]   becomeFirstResponder];
        
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    BOOL shouldChange = YES;
    
    
    
    if (self.currentRegistrationField == RegistrationFieldFirstName) {
        
        shouldChange = [self textFirstLastNameField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    
    else if (self.currentRegistrationField == RegistrationFieldLastName)
        
    {
        
        shouldChange = [self textFirstLastNameField:textField shouldChangeCharactersInRange:range replacementString:string];
        
        
    }
    
    else if (self.currentRegistrationField == RegistrationFieldLogin)
        
    {
        
        shouldChange = [self textLoginField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    else if (self.currentRegistrationField == RegistrationFieldPassword)
        
    {
        
        shouldChange = [self textPasswordField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    
    else if (self.currentRegistrationField == RegistrationFieldAge)
        
    {
        
        shouldChange = [self textAgeField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    
    else if (self.currentRegistrationField == RegistrationFieldPhoneNumber)
        
    {
        
        shouldChange = [self textPhoneField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    
    else if (self.currentRegistrationField == RegistrationFieldEmail){
        
        shouldChange = [self textEmailField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    
    
    return shouldChange;
}



#pragma mark - Fields Validation

- (BOOL)textFirstLastNameField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL shouldChange = YES;
    
    static const int nameMaxLength  = 15;
    
    NSCharacterSet* validationSet = [NSCharacterSet decimalDigitCharacterSet];
    
    NSArray* components           = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if (([components count] > 1) | ([textField.text length] > nameMaxLength)) {
        
        shouldChange =  NO;
    }
    
    return shouldChange;
}


- (BOOL)textAgeField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    static const int ageMaxLength  = 1;
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSArray* components           = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if (([components count] > 1) | ([textField.text length] > ageMaxLength)) {
        
        return  NO;
    }
    
    
    return YES;
    
}

- (BOOL)textPhoneField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSArray* components           = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        
        return  NO;
    }
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //  NSLog(@"newString=%@",newString);
    
    NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    
    newString = [validComponents componentsJoinedByString:@""];
    
    //  NSLog(@"newString fixed=%@",newString);
    
    
    static const int localNumberMaxLength  = 7;
    static const int areaCodeMaxLength     = 3;
    static const int countryCodeMaxLength  = 3;
    
    
    if ([newString length] >  localNumberMaxLength +  areaCodeMaxLength + countryCodeMaxLength) {
        
        return  NO;
    }
    
    
    NSMutableString* resultString = [NSMutableString string];
    
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
    
    
    
    if (localNumberLength > 0) {
        
        NSString* number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
        
        [resultString appendString:number];
        
        if ([resultString length] > 3 ) {
            
            [resultString insertString:@"-" atIndex:3];
        }
        
    }
    
    
    if ([newString length] > localNumberMaxLength) {
        
        NSInteger areaCodeLength = MIN([newString length] - localNumberMaxLength, areaCodeMaxLength);
        
        NSRange areaRange = NSMakeRange([newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        
        NSString* area = [newString substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@) ",area];
        
        [resultString insertString:area atIndex:0];
    }
    
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
        
        
        NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
        
        NSString* countryCode = [newString substringWithRange:countryCodeRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ",countryCode];
        
        [resultString insertString:countryCode atIndex:0];
    }
    
    textField.text = resultString;
    
    return NO;
    
}

- (BOOL)textEmailField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //localPart@serverPart
    //localPart  10
    //serverPart 10
    
    static const int localPartMaxLength   = 10;
    static const int serverPartMaxLength  = 10;
    
    BOOL shouldChange = YES;
    
    static NSString*  symbolsString = @"!#$%&'*+-/=?^_`{|}~[],";
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet* symbolsSet = [NSCharacterSet characterSetWithCharactersInString:symbolsString];
    
    NSArray* components = [newString componentsSeparatedByCharactersInSet:symbolsSet];
    
    if ([components count] > 1) {
        
        shouldChange =  NO;
    }
    
    if (([newString length] == 1 ) && ([string isEqualToString:@"@"] || [string isEqualToString:@"."]) ) {
        
        shouldChange =  NO;
    }
    
    
    NSCharacterSet* atSymbolSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];
    
    NSArray* validAtComponents = [newString componentsSeparatedByCharactersInSet:atSymbolSet];
    
    if ([validAtComponents count] > 2) {
        
        shouldChange =  NO;
    }
    
    NSCharacterSet* pointSymbolSet = [NSCharacterSet characterSetWithCharactersInString:@"."];
    
    NSArray* validPointComponents = [newString componentsSeparatedByCharactersInSet:pointSymbolSet];
    
    if ([validPointComponents count] > 2) {
        
        shouldChange =  NO;
    }
    
    
    if ([newString length] > localPartMaxLength + serverPartMaxLength) {
        
        shouldChange =  NO;
    }
    
    
    return shouldChange;
    
}
- (BOOL)textLoginField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL shouldChange = YES;
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([newString length] > 16) {
        
        shouldChange = NO;
    }
    
    return shouldChange;
}
- (BOOL)textPasswordField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL shouldChange = YES;
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([newString length] > 16) {
        
        shouldChange = NO;
    }
    
    return shouldChange;
}




@end
