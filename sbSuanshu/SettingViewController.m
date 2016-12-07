//
//  SettingViewController.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"

#import "UserModel.h"

#import "UserViewController.h"

@interface SettingViewController () <UserViewControllerDelegate, UITextFieldDelegate>
{
    UIPopoverController* _popController;
}
@end

@implementation SettingViewController

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
    NSDictionary* dic1 = [[UserModel sharedInstance]currentUser];
    [btnUser setTitle:[dic1 objectForKey:KEY_USER_name] forState:(UIControlStateNormal)];
    [btnAge setTitle:[dic1 objectForKey:KEY_USER_age] forState:(UIControlStateNormal)];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    pName.delegate = self;
    pAge.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark action
-(IBAction)returned:(UIStoryboardSegue *)segue {
    
}

- (IBAction)btnBackClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)cancelClicked:(UIButton *)btn {
    [self hideKeyBoard];
    pView.hidden = YES;
}

-(IBAction)okClicked:(UIButton *)btn {
    //check input
    if ([pName.text length]<=0) {
//        TTAlertNoTitle(@"请输入用户名");
        [pName becomeFirstResponder];
        return;
    }
    
    if ([pAge.text length]<=0) {
//        TTAlertNoTitle(@"请输入年龄");
        [pAge becomeFirstResponder];
        return;
    }
    
    [self hideKeyBoard];
    
    [[UserModel sharedInstance]addUser:pName.text age:pAge.text];
    [[UserModel sharedInstance]setCurrentUser:([NSDictionary dictionaryWithObjectsAndKeys:
                                                pName.text, KEY_USER_name,
                                                pAge.text, KEY_USER_age,
                                                nil])];
    
    [btnUser setTitle:pName.text forState:(UIControlStateNormal)];
    [btnAge setTitle:pAge.text forState:(UIControlStateNormal)];
    
    pView.hidden = YES;
}

-(IBAction)addNewUserClicked:(UIButton *)btn {
    pName.text = nil;
    pAge.text = nil;
    pView.hidden = NO;
}

#pragma mark display
-(void)hideKeyBoard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = pView.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    newFrame.origin.y = (up?(-(keyboardFrame.size.height-(768-466))):0);
    pView.frame = newFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:NO];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length] == 0) {
        return NO;
    }
    
    if (textField == pName) {
        [pAge becomeFirstResponder];
    }
    else {
        [self okClicked:nil];
    }
    
    return YES;
}


-(NSUInteger) asciiLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    

//    NSUInteger unicodeLength = asciiLength / 2;
//    
//    if(asciiLength % 2) {
//        unicodeLength++;
//    }
//    
//    return unicodeLength;
    
    return asciiLength;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int iMax = 12;
    
    //删除
    if (string.length == 0) {
        return YES;
    }
    
    if (textField == pName) {
        
//        NSUInteger newLength = (textField.text.length - range.length) + string.length;
        NSString* s1 = [textField.text substringWithRange:range];
        NSUInteger newLength = [self asciiLengthOfString:textField.text] - [self asciiLengthOfString:s1] + [self asciiLengthOfString:string];
        if(newLength <= iMax)
        {
            return YES;
        }
        else if ([self asciiLengthOfString:textField.text] > iMax)
        {
            return  NO;
        }
        else {
            
//            NSUInteger emptySpace = iMax - (textField.text.length - range.length);
//            textField.text = [[[textField.text substringToIndex:range.location]
//                               stringByAppendingString:[string substringToIndex:emptySpace]]
//                              stringByAppendingString:[textField.text substringFromIndex:(range.location + range.length)]];

            int iMaxAddLen = iMax - ([self asciiLengthOfString:textField.text] - [self asciiLengthOfString:s1]);
            NSMutableString* s2 = [NSMutableString string];
            
            for (NSUInteger i = 0; i < string.length; i++) {
                
                
                unichar uc = [string characterAtIndex: i];
                NSUInteger asciiLength = 0;

                asciiLength = isascii(uc) ? 1 : 2;

                if (iMaxAddLen >= asciiLength) {
                    [s2 stringByAppendingString:[NSString stringWithCharacters:&uc length:1]];
                    iMaxAddLen -= asciiLength;
                }
                else {
                    break;
                }
                
            }

            textField.text = [[[textField.text substringToIndex:range.location]
                               stringByAppendingString:s2]
                              stringByAppendingString:[textField.text substringFromIndex:(range.location + range.length)]];

            return NO;
        }
    }
    
    return YES;
}

#pragma mark segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
        UIStoryboardPopoverSegue* ps = (UIStoryboardPopoverSegue*)segue;
        
        UserViewController* c1 = segue.destinationViewController;
        c1.delegate = self;
        
        _popController = ps.popoverController;
    }
}

#pragma mark UserViewControllerDelegate
-(void)didSelectedUser:(NSDictionary*)user
{
    [_popController dismissPopoverAnimated:YES];
    
    [btnUser setTitle:[user objectForKey:KEY_USER_name] forState:(UIControlStateNormal)];
    [btnAge setTitle:[user objectForKey:KEY_USER_age] forState:(UIControlStateNormal)];
    
    [[UserModel sharedInstance]setCurrentUser:user];
}

#pragma mark UIInterfaceOrientationIsLandscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
