//
//  JupiterCredentialManagerViewController.h
//  Jupiter
//
//  Created by Matt Ryan on 10/5/13.
//  Copyright (c) 2013 Seventeen Stones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CredMgrVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

// UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
// UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end
