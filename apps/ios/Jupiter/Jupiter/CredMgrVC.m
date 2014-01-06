//
//  JupiterCredentialManagerViewController.m
//  Jupiter
//
//  Created by Matt Ryan on 10/5/13.
//  Copyright (c) 2013 Seventeen Stones. All rights reserved.
//

#import <AWSRuntime/AWSRuntime.h>

#import "CredMgrVC.h"

#define AWS_ACCESS_KEY_TEXT_FIELD_RID @"AWSAccessKeyTF"
#define AWS_ACCESS_KEY_TEXT @"AWS Access Key"
#define AWS_SECRET_KEY_TEXT_FIELD_RID @"AWSSecretKeyTF"
#define AWS_SECRET_KEY_TEXT @"AWS Secret Access Key"
#define CREDENTIAL_NAME_TEXT_FIELD_RID @"CredentialNameTF"
#define CREDENTIAL_NAME_TEXT @"Name This Credential"

@interface CredMgrVC ()

@property (weak, nonatomic) IBOutlet UIPickerView *awsCredentialPickerView;
@property (weak, nonatomic) IBOutlet UITextField *accessKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *secretKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *credentialNameTextField;
@property (strong, nonatomic) IBOutlet NSMutableArray * credentials;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) NSDictionary * textFieldPlaceholders;

@end

@implementation CredMgrVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (nil == self.credentials)
    {
        self.credentials = [[NSMutableArray alloc] init];
    }
    [self.credentials addObject:@"  (NONE)  "];
//    [self.credentials addObject:@"Default"];
//    [self.credentials addObject:@"Custom"];

    if (nil == self.textFieldPlaceholders)
    {
        self.textFieldPlaceholders = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      AWS_ACCESS_KEY_TEXT,
                                      AWS_ACCESS_KEY_TEXT_FIELD_RID,
                                      AWS_SECRET_KEY_TEXT,
                                      AWS_SECRET_KEY_TEXT_FIELD_RID,
                                      CREDENTIAL_NAME_TEXT,
                                      CREDENTIAL_NAME_TEXT_FIELD_RID,
                                      nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.credentials.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = [self.credentials objectAtIndex:row];
    return title;
}

- (IBAction)onTextFieldEditingDidBegin:(UITextField *)sender
{
}

- (IBAction)onAccessKeyTextFieldChanged:(UITextField *)sender
{
    self.loginButton.enabled = [self haveNewCredential];
}

- (IBAction)onTextFieldEditingDidEnd:(UITextField *)sender
{
}

- (IBAction)onLoginClicked:(UIButton *)sender
{
    if ([self haveNewCredential])
    {
        AmazonCredentials * cred = [[AmazonCredentials alloc]
                                    initWithAccessKey:self.accessKeyTextField.text
                                    withSecretKey:self.secretKeyTextField.text];
        
        // Save the credential here
    }
    else
    {
        // Load the credential by name from the cache
    }
    
    // Make this credential the active credential before the segue occurs
}

- (BOOL)haveNewCredential
{
    return ( (self.accessKeyTextField.text.length > 0
              && ![self.accessKeyTextField.text isEqualToString:AWS_ACCESS_KEY_TEXT])
            && (self.secretKeyTextField.text.length > 0
                && ![self.secretKeyTextField.text isEqualToString:AWS_SECRET_KEY_TEXT])
//         && (self.credentialNameTextField.text.length > 0
//             && ![self.credentialNameTextField.text isEqualToString:CREDENTIAL_NAME_TEXT])
            );
}

@end
