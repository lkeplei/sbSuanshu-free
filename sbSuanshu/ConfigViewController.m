//
//  ConfigViewController.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "ConfigViewController.h"
#import "AnswerViewController.h"

#import "AppDelegate.h"

#import "UserModel.h"

#import "InAppPurchaseManager.h"


@interface ConfigViewController () <UITextFieldDelegate, InAppPurchaseManagerDelegate>
{
    int _count;
    int _ratio1;
    int _ratio2;
    int _ratio3;
    int _ratio4;
    int _fanwei1;
    int _fanwei2;
    int _fanwei3;
    int _fanwei4;
    int _mode;  //2;3;10;
    
    NSMutableArray* _myZuhe;
    int _iSelectedIndex;
}
@end

@implementation ConfigViewController

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
    
    _count = 10;

//    _ratio1 = 25;
//    _ratio2 = 25;
//    _ratio3 = 25;
//    _ratio4 = 25;
    _ratio1 = 0;
    _ratio2 = 0;
    _ratio3 = 0;
    _ratio4 = 0;
//
//    _fanwei1 = 10;
//    _fanwei2 = 10;
//    _fanwei3 = 20;
//    _fanwei4 = 20;
//    
    _fanwei1 = 0;
    _fanwei2 = 0;
    _fanwei3 = 0;
    _fanwei4 = 0;

    _mode = 2;

    
    
    _iSelectedIndex = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    textFieldName.delegate = self;
    
    [self setBtnTextColor];
    [self setBtnLocalizedTitle];
    
    [self setBtnForFreeVersion];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBtnForFreeVersion) name:sb_notify_purchase_ok object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    CGRect newFrame = viewSave.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    newFrame.origin.y = (up?(-(keyboardFrame.size.height-(768-466))):0);
    viewSave.frame = newFrame;
    
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
    if ([textFieldName.text length] == 0) {
        return NO;
    }

    [self btnClicked:btnSaveOk];
    return YES;
}


#pragma mark action
-(IBAction)returned:(UIStoryboardSegue *)segue {
    
}

- (IBAction)btnBackClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)btnZuheClicked:(UIButton*)btn
{
    if (btn == btnTuijian) {
        btnTuijian.selected = YES;
        btnMine.selected = NO;
        imgViewZuheBg.highlighted = NO;
        
        btnDelete.hidden = YES;
        btnSave.hidden = YES;
        btnSaveToMine.hidden = NO;
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;

        [self setBtnLocalizedTitle];
    }
    else if (btn == btnMine){
        
        if ([self alertForFreeVersion]) {
            return;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;

        _iSelectedIndex = -1;
        
        [self resetMyZuheBtnTitle];
        
    }
    else if(btn == btnZuhe1)
    {
        if (btnTuijian.selected == YES) {
            _count = 10;
            
            _ratio1 = 60;
            _ratio2 = 40;
            _ratio3 = 0;
            _ratio4 = 0;

            _fanwei1 = 10;
            _fanwei2 = 10;
            _fanwei3 = 20;
            _fanwei4 = 20;

            _mode = 2;

        }
        else {
            _iSelectedIndex = 0;
        }
    
        btnZuhe1.selected = YES;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
    }
    else if(btn == btnZuhe2)
    {
        if (btnTuijian.selected == YES) {
            _count = 20;
            
            _ratio1 = 60;
            _ratio2 = 40;
            _ratio3 = 0;
            _ratio4 = 0;
            
            
            _fanwei1 = 20;
            _fanwei2 = 20;
            _fanwei3 = 20;
            _fanwei4 = 20;
            
            _mode = 2;
        }
        else {
            _iSelectedIndex = 1;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = YES;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
        
    }
    else if(btn == btnZuhe3)
    {
        if (btnTuijian.selected == YES) {
            _count = 20;
            
            _ratio1 = 50;
            _ratio2 = 50;
            _ratio3 = 0;
            _ratio4 = 0;
            
            
            _fanwei1 = 20;
            _fanwei2 = 20;
            _fanwei3 = 20;
            _fanwei4 = 20;
            
            _mode = 2;
        }
        else {
            _iSelectedIndex = 2;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = YES;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
        
    }
    else if(btn == btnZuhe4)
    {
        if (btnTuijian.selected == YES) {
            _count = 30;
            
            _ratio1 = 50;
            _ratio2 = 50;
            _ratio3 = 0;
            _ratio4 = 0;
            
            _fanwei1 = 100;
            _fanwei2 = 100;
            _fanwei3 = 20;
            _fanwei4 = 20;
            
            _mode = 2;
        }
        else {
            _iSelectedIndex = 3;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = YES;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
        
    }
    else if(btn == btnZuhe5)
    {
        
//        if ([self alertForFreeVersion]) {
//            return;
//        }
        
        if (btnTuijian.selected == YES) {
            _count = 20;
            
            _ratio1 = 40;
            _ratio2 = 40;
            _ratio3 = 20;
            _ratio4 = 0;
            
            _fanwei1 = 100;
            _fanwei2 = 100;
            _fanwei3 = 20;
            _fanwei4 = 20;
            
            _mode = 2;
        }
        else {
            _iSelectedIndex = 4;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = YES;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
        
    }
    else if(btn == btnZuhe6)
    {
        
//        if ([self alertForFreeVersion]) {
//            return;
//        }
        
        if (btnTuijian.selected == YES) {
            _count = 30;
            
            _ratio1 = 40;
            _ratio2 = 40;
            _ratio3 = 20;
            _ratio4 = 0;
            
            _fanwei1 = 100;
            _fanwei2 = 100;
            _fanwei3 = 100;
            _fanwei4 = 20;
            
            _mode = 2;
        }
        else {
            _iSelectedIndex = 5;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = YES;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
        
    }
    else if(btn == btnZuhe7)
    {
        
//        if ([self alertForFreeVersion]) {
//            return;
//        }
        
        if (btnTuijian.selected == YES) {
            _count = 30;
            
            _ratio1 = 30;
            _ratio2 = 30;
            _ratio3 = 20;
            _ratio4 = 20;
            
            _fanwei1 = 100;
            _fanwei2 = 100;
            _fanwei3 = 100;
            _fanwei4 = 100;
            
            _mode = 2;
        }
        else {
            _iSelectedIndex = 6;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = YES;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
        
    }
    else if(btn == btnZuhe8)
    {
        
//        if ([self alertForFreeVersion]) {
//            return;
//        }
        
        if (btnTuijian.selected == YES) {
            _count = 50;
            
            _ratio1 = 30;
            _ratio2 = 30;
            _ratio3 = 20;
            _ratio4 = 20;
            
            _fanwei1 = 100;
            _fanwei2 = 100;
            _fanwei3 = 100;
            _fanwei4 = 100;
            
            _mode = 10;
        }
        else {
            _iSelectedIndex = 7;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = YES;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
        
    }
    else if(btn == btnZuhe9)
    {
        
//        if ([self alertForFreeVersion]) {
//            return;
//        }
        
        if (btnTuijian.selected == YES) {
            _count = 30;
            
            _ratio1 = 30;
            _ratio2 = 30;
            _ratio3 = 20;
            _ratio4 = 20;
            
            _fanwei1 = 500;
            _fanwei2 = 500;
            _fanwei3 = 100;
            _fanwei4 = 100;
            
            _mode = 10;
        }
        else {
            _iSelectedIndex = 8;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = YES;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
        
    }
    else if(btn == btnZuhe10)
    {
        
//        if ([self alertForFreeVersion]) {
//            return;
//        }
        
        if (btnTuijian.selected == YES) {
            _count = 50;
            
            _ratio1 = 20;
            _ratio2 = 20;
            _ratio3 = 30;
            _ratio4 = 30;
            
            _fanwei1 = 500;
            _fanwei2 = 500;
            _fanwei3 = 100;
            _fanwei4 = 100;
            
            _mode = 10;
        }
        else {
            _iSelectedIndex = 9;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = YES;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
        
    }
    else if(btn == btnZuhe11)
    {
        
//        if ([self alertForFreeVersion]) {
//            return;
//        }
        
        if (btnTuijian.selected == YES) {
            _count = 50;
            
            _ratio1 = 30;
            _ratio2 = 30;
            _ratio3 = 20;
            _ratio4 = 20;
            
            _fanwei1 = 500;
            _fanwei2 = 500;
            _fanwei3 = 100;
            _fanwei4 = 100;
            
            _mode = 10;
        }
        else {
            _iSelectedIndex = 10;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = YES;
        btnZuhe12.selected = NO;
        
    }
    else if(btn == btnZuhe12)
    {
        
//        if ([self alertForFreeVersion]) {
//            return;
//        }
        
        if (btnTuijian.selected == YES) {
            _count = 50;
            
            _ratio1 = 30;
            _ratio2 = 30;
            _ratio3 = 20;
            _ratio4 = 20;
            
            _fanwei1 = 500;
            _fanwei2 = 500;
            _fanwei3 = 500;
            _fanwei4 = 500;
            
            _mode = 3;
        }
        else {
            _iSelectedIndex = 11;
        }
        
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = YES;
    }
    
    if (btnTuijian.selected == NO && _iSelectedIndex != -1)
    {
        NSMutableDictionary* dic1 = [_myZuhe objectAtIndex:_iSelectedIndex];
        
        _count = [[dic1 objectForKey:KEY_zuhe_cnt]integerValue];
        if (0 == _count) {
            _count = 10;
        }
        _ratio1 = [[dic1 objectForKey:KEY_zuhe_ratio1]integerValue];
        _ratio2 = [[dic1 objectForKey:KEY_zuhe_ratio2]integerValue];
        _ratio3 = [[dic1 objectForKey:KEY_zuhe_ratio3]integerValue];
        _ratio4 = [[dic1 objectForKey:KEY_zuhe_ratio4]integerValue];
        
        _fanwei1 = [[dic1 objectForKey:KEY_zuhe_fanwei1]integerValue];
        if (0 == _fanwei1) {
            _fanwei1 = 10;
        }
        _fanwei2 = [[dic1 objectForKey:KEY_zuhe_fanwei2]integerValue];
        if (0 == _fanwei2) {
            _fanwei2 = 10;
        }
        _fanwei3 = [[dic1 objectForKey:KEY_zuhe_fanwei3]integerValue];
        if (0 == _fanwei3) {
            _fanwei3 = 20;
        }
        _fanwei4 = [[dic1 objectForKey:KEY_zuhe_fanwei4]integerValue];
        if (0 == _fanwei4) {
            _fanwei4 = 20;
        }
        
        _mode = [[dic1 objectForKey:KEY_zuhe_mode]integerValue];
        if (0 == _mode) {
            _mode = 2;
        }

    }
    
    if ((btn != btnTuijian) && (btn != btnMine)) {
        [self setBtnStateAndTitle];
    }
}

-(IBAction)btnStartClicked:(UIButton*)btn
{
    if(100 == (_ratio1 + _ratio2 + _ratio3 + _ratio4)) {
        if (0 == _mode) {
            TTAlertNoTitle(@"请选择题目形式", nil);
            return;
        }
        
        UIStoryboard* s1 = self.storyboard;
        AnswerViewController* a1 = [s1 instantiateViewControllerWithIdentifier:@"AnswerViewController"];
        
        a1.iCfgCnt = _count;

        a1.iCfgR1 = _ratio1;
        a1.iCfgR2 = _ratio2;
        a1.iCfgR3 = _ratio3;
        a1.iCfgR4 = _ratio4;
        
        a1.iCfgF1 = _fanwei1;
        a1.iCfgF2 = _fanwei2;
        a1.iCfgF3 = _fanwei3;
        a1.iCfgF4 = _fanwei4;
        
        a1.iCfgMode = _mode;
        
        [self presentModalViewController:a1 animated:YES];
    }
    else {
        viewRatioAlert.hidden = NO;
        [self.view bringSubviewToFront:viewRatioAlert];
    }
}

-(IBAction)btnLeftClicked:(UIButton*)btn
{
    
//    if ([self alertForFreeVersion]) {
//        return;
//    }
    
    switch (btn.tag) {
        case 1:
        {
            if (_count > 10) {
                _count -= 10;
            }
            else {
                _count = 10;
                btnShuliang.selected = YES;
            }
            
            [btnShuliang setTitle:[NSString stringWithFormat:@"%d", _count] forState:(UIControlStateNormal)];
            [btnShuliang setTitle:[NSString stringWithFormat:@"%d", _count] forState:(UIControlStateSelected)];
        }
            break;
        case 13:
        {
            if (! btnFuhao1.selected) {
                return;
            }
            
            if (_ratio1 > 10) {
                _ratio1 -= 10;
            }
            else {
                _ratio1 = 10;
            }
            
            [btnBili1 setTitle:[NSString stringWithFormat:@"%d%%", _ratio1] forState:(UIControlStateNormal)];
            [btnBili1 setTitle:[NSString stringWithFormat:@"%d%%", _ratio1] forState:(UIControlStateSelected)];
        }
            break;
        case 15:
        {
            if (! btnFuhao1.selected) {
                return;
            }
            switch (_fanwei1) {
                case 10:
                    break;
                case 20:
                    _fanwei1 = 10;
                    break;
                case 100:
                    _fanwei1 = 20;
                    break;
                case 500:
                    _fanwei1 = 100;
                    break;
                    
                default:
                    _fanwei1 = 10;
                    break;
            }
            
            [btnFanwei1 setTitle:[NSString stringWithFormat:@"<%d", _fanwei1] forState:(UIControlStateNormal)];
            [btnFanwei1 setTitle:[NSString stringWithFormat:@"<%d", _fanwei1] forState:(UIControlStateSelected)];
        }
            break;
        case 23:
        {
            if (! btnFuhao2.selected) {
                return;
            }

            if (_ratio2 > 10) {
                _ratio2 -= 10;
            }
            else {
                _ratio2 = 10;
            }

            [btnBili2 setTitle:[NSString stringWithFormat:@"%d%%", _ratio2] forState:(UIControlStateNormal)];
            [btnBili2 setTitle:[NSString stringWithFormat:@"%d%%", _ratio2] forState:(UIControlStateSelected)];
        }
            break;
        case 25:
        {
            if (! btnFuhao2.selected) {
                return;
            }

            switch (_fanwei2) {
                case 10:
                    break;
                case 20:
                    _fanwei2 = 10;
                    break;
                case 100:
                    _fanwei2 = 20;
                    break;
                case 500:
                    _fanwei2 = 100;
                    break;
                    
                default:
                    _fanwei2 = 10;
                    break;
            }
            
            [btnFanwei2 setTitle:[NSString stringWithFormat:@"<%d", _fanwei2] forState:(UIControlStateNormal)];
            [btnFanwei2 setTitle:[NSString stringWithFormat:@"<%d", _fanwei2] forState:(UIControlStateSelected)];
        }
            break;
        case 33:
        {
            if (! btnFuhao3.selected) {
                return;
            }

            if (_ratio3 > 10) {
                _ratio3 -= 10;
            }
            else {
                _ratio3 = 10;
            }

            [btnBili3 setTitle:[NSString stringWithFormat:@"%d%%", _ratio3] forState:(UIControlStateNormal)];
            [btnBili3 setTitle:[NSString stringWithFormat:@"%d%%", _ratio3] forState:(UIControlStateSelected)];
        }
            break;
        case 35:
        {
            if (! btnFuhao3.selected) {
                return;
            }
            
            switch (_fanwei3) {
                case 10:
                    break;
                case 20:
                    break;
                case 100:
                    _fanwei3 = 20;
                    break;
                case 500:
                    _fanwei3 = 100;
                    break;
                    
                default:
                    _fanwei3 = 20;
                    break;
            }
            
            [btnFanwei3 setTitle:[NSString stringWithFormat:@"<%d", _fanwei3] forState:(UIControlStateNormal)];
            [btnFanwei3 setTitle:[NSString stringWithFormat:@"<%d", _fanwei3] forState:(UIControlStateSelected)];
        }
            break;
        case 43:
        {
            if (! btnFuhao4.selected) {
                return;
            }
            
            if (_ratio4 > 10) {
                _ratio4 -= 10;
            }
            else {
                _ratio4 = 10;
            }

            [btnBili4 setTitle:[NSString stringWithFormat:@"%d%%", _ratio4] forState:(UIControlStateNormal)];
            [btnBili4 setTitle:[NSString stringWithFormat:@"%d%%", _ratio4] forState:(UIControlStateSelected)];
        }
            break;
        case 45:
        {
            if (! btnFuhao4.selected) {
                return;
            }
            
            switch (_fanwei4) {
                case 10:
                    break;
                case 20:
                    break;
                case 100:
                    _fanwei4 = 20;
                    break;
                case 500:
                    _fanwei4 = 100;
                    break;
                    
                default:
                    _fanwei4 = 20;
                    break;
            }
            
            [btnFanwei4 setTitle:[NSString stringWithFormat:@"<%d", _fanwei4] forState:(UIControlStateNormal)];
            [btnFanwei4 setTitle:[NSString stringWithFormat:@"<%d", _fanwei4] forState:(UIControlStateSelected)];
        }
            break;
            
        default:
            break;
    }
    
    if(btnTuijian.selected == YES)
    {
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
    }
}

-(IBAction)btnRightClicked:(UIButton*)btn
{
    
//    if ([self alertForFreeVersion]) {
//        return;
//    }
    
    switch (btn.tag) {
        case 2:
        {
            if (_count < 50) {
                _count += 10;
            }
            
            btnShuliang.selected = YES;
            
            [btnShuliang setTitle:[NSString stringWithFormat:@"%d", _count] forState:(UIControlStateNormal)];
            [btnShuliang setTitle:[NSString stringWithFormat:@"%d", _count] forState:(UIControlStateSelected)];
        }
            break;
        case 14:
        {
            if (! btnFuhao1.selected) {
                return;
            }
            
            if (_ratio1 < 100) {
                _ratio1 += 10;
            }
            
            [btnBili1 setTitle:[NSString stringWithFormat:@"%d%%", _ratio1] forState:(UIControlStateNormal)];
            [btnBili1 setTitle:[NSString stringWithFormat:@"%d%%", _ratio1] forState:(UIControlStateSelected)];
        }
            break;
        case 16:
        {
            if (! btnFuhao1.selected) {
                return;
            }

            switch (_fanwei1) {
                case 10:
                    _fanwei1 = 20;
                    break;
                case 20:
                    _fanwei1 = 100;
                    break;
                case 100:
                    _fanwei1 = 500;
                    break;
                case 500:
                    break;
                    
                default:
                    _fanwei1 = 10;
                    break;
            }
            
            [btnFanwei1 setTitle:[NSString stringWithFormat:@"<%d", _fanwei1] forState:(UIControlStateNormal)];
            [btnFanwei1 setTitle:[NSString stringWithFormat:@"<%d", _fanwei1] forState:(UIControlStateSelected)];
        }
            break;
        case 24:
        {
            if (! btnFuhao2.selected) {
                return;
            }

            if (_ratio2 < 100) {
                _ratio2 += 10;
            }
            
            [btnBili2 setTitle:[NSString stringWithFormat:@"%d%%", _ratio2] forState:(UIControlStateNormal)];
            [btnBili2 setTitle:[NSString stringWithFormat:@"%d%%", _ratio2] forState:(UIControlStateSelected)];
        }
            break;
        case 26:
        {
            if (! btnFuhao2.selected) {
                return;
            }
            
            switch (_fanwei2) {
                case 10:
                    _fanwei2 = 20;
                    break;
                case 20:
                    _fanwei2 = 100;
                    break;
                case 100:
                    _fanwei2 = 500;
                    break;
                case 500:
                    break;
                    
                default:
                    _fanwei2 = 10;
                    break;
            }
            
            [btnFanwei2 setTitle:[NSString stringWithFormat:@"<%d", _fanwei2] forState:(UIControlStateNormal)];
            [btnFanwei2 setTitle:[NSString stringWithFormat:@"<%d", _fanwei2] forState:(UIControlStateSelected)];
        }
            break;
        case 34:
        {
            if (! btnFuhao3.selected) {
                return;
            }
            
            if (_ratio3 < 100) {
                _ratio3 += 10;
            }
            
            [btnBili3 setTitle:[NSString stringWithFormat:@"%d%%", _ratio3] forState:(UIControlStateNormal)];
            [btnBili3 setTitle:[NSString stringWithFormat:@"%d%%", _ratio3] forState:(UIControlStateSelected)];
        }
            break;
        case 36:
        {
            if (! btnFuhao3.selected) {
                return;
            }
            
            switch (_fanwei3) {
                case 10:
                    _fanwei3 = 20;
                    break;
                case 20:
                    _fanwei3 = 100;
                    break;
                case 100:
                    _fanwei3 = 500;
                    break;
                case 500:
                    break;
                    
                default:
                    _fanwei3 = 20;
                    break;
            }
            
            [btnFanwei3 setTitle:[NSString stringWithFormat:@"<%d", _fanwei3] forState:(UIControlStateNormal)];
            [btnFanwei3 setTitle:[NSString stringWithFormat:@"<%d", _fanwei3] forState:(UIControlStateSelected)];
        }
            break;
        case 44:
        {
            if (! btnFuhao4.selected) {
                return;
            }
            
            if (_ratio4 < 100) {
                _ratio4 += 10;
            }
            
            [btnBili4 setTitle:[NSString stringWithFormat:@"%d%%", _ratio4] forState:(UIControlStateNormal)];
            [btnBili4 setTitle:[NSString stringWithFormat:@"%d%%", _ratio4] forState:(UIControlStateSelected)];
        }
            break;
        case 46:
        {
            if (! btnFuhao4.selected) {
                return;
            }
            
            switch (_fanwei4) {
                case 10:
                    _fanwei4 = 20;
                    break;
                case 20:
                    _fanwei4 = 100;
                    break;
                case 100:
                    _fanwei4 = 500;
                    break;
                case 500:
                    break;
                    
                default:
                    _fanwei4 = 20;
                    break;
            }
            
            [btnFanwei4 setTitle:[NSString stringWithFormat:@"<%d", _fanwei4] forState:(UIControlStateNormal)];
            [btnFanwei4 setTitle:[NSString stringWithFormat:@"<%d", _fanwei4] forState:(UIControlStateSelected)];
        }
            break;
            
        default:
            break;
    }
    
    if(btnTuijian.selected == YES)
    {
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
    }

}

-(IBAction)btnModeClicked:(UIButton*)btn
{
    
//    if ([self alertForFreeVersion]) {
//        return;
//    }
    
    if (btn == btn2Num) {
        btn2Num.selected = YES;
        btn3Num.selected = NO;
        btnMixed.selected = NO;
        
        _mode = 2;
    }
    else if (btn == btn3Num) {
        btn2Num.selected = NO;
        btn3Num.selected = YES;
        btnMixed.selected = NO;

        _mode = 3;
    }
    else if (btn == btnMixed) {
        btn2Num.selected = NO;
        btn3Num.selected = NO;
        btnMixed.selected = YES;
        
        _mode = 10;
    }

    if(btnTuijian.selected == YES)
    {
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
    }
}

-(IBAction)btnClicked:(UIButton*)btn
{
    if (btn == btnSaveToMine) {
        
        if ([self alertForFreeVersion]) {
            return;
        }

        if(100 != (_ratio1 + _ratio2 + _ratio3 + _ratio4)) {
            viewRatioAlert.hidden = NO;
            [self.view bringSubviewToFront:viewRatioAlert];
            return;
        }
        
        _myZuhe = [NSMutableArray arrayWithArray: [UserModel sharedInstance].zuheForCurrentUser];
        _iSelectedIndex = 0;
        
        do {
            NSMutableDictionary* dic1 = [_myZuhe objectAtIndex:_iSelectedIndex];
            if (nil == [dic1 objectForKey:KEY_zuhe_name]) {
                break;
            }

            _iSelectedIndex++;

        } while (_iSelectedIndex < 12);
        
        if (_iSelectedIndex > 11) {
            _iSelectedIndex = -1;
//            TTAlertNoTitle(@"我的组合已满，请先删除一个");
            viewZuheAlert.hidden = NO;
            [self.view bringSubviewToFront:viewZuheAlert];

            return;
        }

        textFieldName.text = nil;
        viewSave.hidden = NO;
        [self.view bringSubviewToFront:viewSave];

    }
    else if(btn == btnSave)
    {
        if (-1 == _iSelectedIndex) {
            return;
        }
        //check
        if(0 == _count) {
            TTAlertNoTitle(@"(0 == _count)", nil);
            return;
        }
        if(100 != (_ratio1 + _ratio2 + _ratio3 + _ratio4)) {
            viewRatioAlert.hidden = NO;
            [self.view bringSubviewToFront:viewRatioAlert];
            return;
        }
        if(0 == _mode) {
            TTAlertNoTitle(@"(0 == _mode)", nil);
            return;
        }
        
        NSMutableDictionary* dic1 = [_myZuhe objectAtIndex:_iSelectedIndex];
        textFieldName.text = [dic1 objectForKey:KEY_zuhe_name];
        
        viewSave.hidden = NO;
        [self.view bringSubviewToFront:viewSave];
    }
    else if (btn == btnDelete) {
        if (-1 == _iSelectedIndex) {
            return;
        }
        NSMutableDictionary* dic1 = [_myZuhe objectAtIndex:_iSelectedIndex];
        if (nil == [dic1 objectForKey:KEY_zuhe_name]) {
            return;
        }
        
        viewDelete.hidden = NO;
        [self.view bringSubviewToFront:viewDelete];
    }
    else{
        switch (btn.tag) {
            case 101:   //取消保存
            {
                [textFieldName resignFirstResponder];

            }
                break;
                
            case 102:   //确定保存
            {
                if ([textFieldName.text length] == 0) {
                    [textFieldName becomeFirstResponder];
                    return;
                }
                else {
                    [textFieldName resignFirstResponder];

                    
                    NSMutableDictionary* z1 = [NSMutableDictionary dictionary];
                    [z1 setObject:textFieldName.text forKey:KEY_zuhe_name];
                    [z1 setObject:[NSNumber numberWithInt:_count] forKey:KEY_zuhe_cnt];
                    [z1 setObject:[NSNumber numberWithInt:_ratio1] forKey:KEY_zuhe_ratio1];
                    [z1 setObject:[NSNumber numberWithInt:_ratio2] forKey:KEY_zuhe_ratio2];
                    [z1 setObject:[NSNumber numberWithInt:_ratio3] forKey:KEY_zuhe_ratio3];
                    [z1 setObject:[NSNumber numberWithInt:_ratio4] forKey:KEY_zuhe_ratio4];
                    [z1 setObject:[NSNumber numberWithInt:_fanwei1] forKey:KEY_zuhe_fanwei1];
                    [z1 setObject:[NSNumber numberWithInt:_fanwei2] forKey:KEY_zuhe_fanwei2];
                    [z1 setObject:[NSNumber numberWithInt:_fanwei3] forKey:KEY_zuhe_fanwei3];
                    [z1 setObject:[NSNumber numberWithInt:_fanwei4] forKey:KEY_zuhe_fanwei4];
                    [z1 setObject:[NSNumber numberWithInt:_mode] forKey:KEY_zuhe_mode];
                    
                    _myZuhe = [NSMutableArray arrayWithArray: [UserModel sharedInstance].zuheForCurrentUser];
                    [_myZuhe setObject:z1 atIndexedSubscript:_iSelectedIndex];
                    [UserModel sharedInstance].zuheForCurrentUser = _myZuhe;
                    
                    btnZuhe1.selected = NO;
                    btnZuhe2.selected = NO;
                    btnZuhe3.selected = NO;
                    btnZuhe4.selected = NO;
                    btnZuhe5.selected = NO;
                    btnZuhe6.selected = NO;
                    btnZuhe7.selected = NO;
                    btnZuhe8.selected = NO;
                    btnZuhe9.selected = NO;
                    btnZuhe10.selected = NO;
                    btnZuhe11.selected = NO;
                    btnZuhe12.selected = NO;
                    
                    switch (_iSelectedIndex) {
                        case 0:
                            btnZuhe1.selected = YES;
                            break;
                        case 1:
                            btnZuhe2.selected = YES;
                            break;
                        case 2:
                            btnZuhe3.selected = YES;
                            break;
                        case 3:
                            btnZuhe4.selected = YES;
                            break;
                        case 4:
                            btnZuhe5.selected = YES;
                            break;
                        case 5:
                            btnZuhe6.selected = YES;
                            break;
                        case 6:
                            btnZuhe7.selected = YES;
                            break;
                        case 7:
                            btnZuhe8.selected = YES;
                            break;
                        case 8:
                            btnZuhe9.selected = YES;
                            break;
                        case 9:
                            btnZuhe10.selected = YES;
                            break;
                        case 10:
                            btnZuhe11.selected = YES;
                            break;
                        case 11:
                            btnZuhe12.selected = YES;
                            break;

                        default:
                            break;
                    }
                    
                    [self resetMyZuheBtnTitle];
                }
            }
                break;
                
            case 201:   //确定删除
            {
                NSMutableDictionary* z1 = [NSMutableDictionary dictionary];

                _myZuhe = [NSMutableArray arrayWithArray: [UserModel sharedInstance].zuheForCurrentUser];
                [_myZuhe setObject:z1 atIndexedSubscript:_iSelectedIndex];
                [UserModel sharedInstance].zuheForCurrentUser = _myZuhe;

                btnZuhe1.selected = NO;
                btnZuhe2.selected = NO;
                btnZuhe3.selected = NO;
                btnZuhe4.selected = NO;
                btnZuhe5.selected = NO;
                btnZuhe6.selected = NO;
                btnZuhe7.selected = NO;
                btnZuhe8.selected = NO;
                btnZuhe9.selected = NO;
                btnZuhe10.selected = NO;
                btnZuhe11.selected = NO;
                btnZuhe12.selected = NO;
                
                _count = 10;
                _ratio1 = 0;
                _ratio2 = 0;
                _ratio3 = 0;
                _ratio4 = 0;
                _mode = 2;
                [self setBtnStateAndTitle];
                
                [self resetMyZuheBtnTitle];
            }
                break;
                
            case 202:   //取消删除
                break;
                
            default:
                break;
        }

        viewDelete.hidden = YES;
        viewSave.hidden = YES;
        viewRatioAlert.hidden = YES;
        viewZuheAlert.hidden = YES;
        [self hideKeyBoard];
    }
    
}

- (IBAction)btnFuhaoClicked:(UIButton*)sender
{
    
//    if ([self alertForFreeVersion]) {
//        return;
//    }
    
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 101:
//            [btnBili1 setTitle:@"－" forState:(UIControlStateNormal)];
//            [btnFanwei1 setTitle:@"－" forState:(UIControlStateNormal)];
//            btnBili1.selected = !btnBili1.selected;
//            btnFanwei1.selected = !btnFanwei1.selected;
            if (sender.selected) {
                _ratio1 = 10;
                _fanwei1 = 10;
            }
            else {
                _ratio1 = 0;
            }
            break;
        
        case 102:
//            [btnBili2 setTitle:@"－" forState:(UIControlStateNormal)];
//            [btnFanwei2 setTitle:@"－" forState:(UIControlStateNormal)];
//            btnBili2.selected = !btnBili2.selected;
//            btnFanwei2.selected = !btnFanwei2.selected;
            if (sender.selected) {
                _ratio2 = 10;
                _fanwei2 = 10;
            }
            else {
                _ratio2 = 0;
            }
            break;
        
        case 103:
//            [btnBili3 setTitle:@"－" forState:(UIControlStateNormal)];
//            [btnFanwei3 setTitle:@"－" forState:(UIControlStateNormal)];
//            btnBili3.selected = !btnBili3.selected;
//            btnFanwei3.selected = !btnFanwei3.selected;
            if (sender.selected) {
                _ratio3 = 10;
                _fanwei3 = 20;
            }
            else {
                _ratio3 = 0;
            }
            break;

        case 104:
//            [btnBili4 setTitle:@"－" forState:(UIControlStateNormal)];
//            [btnFanwei4 setTitle:@"－" forState:(UIControlStateNormal)];
//            btnBili4.selected = !btnBili4.selected;
//            btnFanwei4.selected = !btnFanwei4.selected;
            if (sender.selected) {
                _ratio4 = 10;
                _fanwei4 = 20;
            }
            else {
                _ratio4 = 0;
            }
            break;
            
        default:
            break;
    }
    
    if(btnTuijian.selected == YES)
    {
        btnZuhe1.selected = NO;
        btnZuhe2.selected = NO;
        btnZuhe3.selected = NO;
        btnZuhe4.selected = NO;
        btnZuhe5.selected = NO;
        btnZuhe6.selected = NO;
        btnZuhe7.selected = NO;
        btnZuhe8.selected = NO;
        btnZuhe9.selected = NO;
        btnZuhe10.selected = NO;
        btnZuhe11.selected = NO;
        btnZuhe12.selected = NO;
    }
    
    [self setBtnStateAndTitle];

}

#pragma mark private
-(void)setBtnStateAndTitle{
    if (_count > 0) {
        btnShuliang.selected = YES;
        [btnShuliang setTitle:[NSString stringWithFormat:@"%d", _count] forState:(UIControlStateNormal)];
        [btnShuliang setTitle:[NSString stringWithFormat:@"%d", _count] forState:(UIControlStateSelected)];
    }
    else {
        btnShuliang.selected = NO;
        [btnShuliang setTitle:@"—" forState:(UIControlStateNormal)];
        [btnShuliang setTitle:@"—" forState:(UIControlStateSelected)];
    }


    btn2Num.selected = NO;
    btn3Num.selected = NO;
    btnMixed.selected = NO;
    if (2 == _mode) {
        btn2Num.selected = YES;
    }
    else if (3 == _mode) {
        btn3Num.selected = YES;
    }
    else if (10 == _mode) {
        btnMixed.selected = YES;
    }
    
    if (_ratio1 > 0) {
        btnFuhao1.selected = YES;
        
        btnBili1.selected = YES;
        btnFanwei1.selected = YES;
        
        [btnBili1 setTitle:[NSString stringWithFormat:@"%d%%", _ratio1] forState:(UIControlStateNormal)];
        [btnFanwei1 setTitle:[NSString stringWithFormat:@"<%d", _fanwei1] forState:(UIControlStateNormal)];
        
        [btnBili1 setTitle:[NSString stringWithFormat:@"%d%%", _ratio1] forState:(UIControlStateSelected)];
        [btnFanwei1 setTitle:[NSString stringWithFormat:@"<%d", _fanwei1] forState:(UIControlStateSelected)];
    }
    else {
        btnFuhao1.selected = NO;

        btnBili1.selected = NO;
        btnFanwei1.selected = NO;

        [btnBili1 setTitle:@"—" forState:(UIControlStateNormal)];
        [btnFanwei1 setTitle:@"—" forState:(UIControlStateNormal)];

        [btnBili1 setTitle:@"—" forState:(UIControlStateSelected)];
        [btnFanwei1 setTitle:@"—" forState:(UIControlStateSelected)];
    }
    
    if (_ratio2 > 0) {
        btnFuhao2.selected = YES;
        
        btnBili2.selected = YES;
        btnFanwei2.selected = YES;
        
        [btnBili2 setTitle:[NSString stringWithFormat:@"%d%%", _ratio2] forState:(UIControlStateNormal)];
        [btnFanwei2 setTitle:[NSString stringWithFormat:@"<%d", _fanwei2] forState:(UIControlStateNormal)];

        [btnBili2 setTitle:[NSString stringWithFormat:@"%d%%", _ratio2] forState:(UIControlStateSelected)];
        [btnFanwei2 setTitle:[NSString stringWithFormat:@"<%d", _fanwei2] forState:(UIControlStateSelected)];
    }
    else {
        btnFuhao2.selected = NO;
        
        btnBili2.selected = NO;
        btnFanwei2.selected = NO;
        
        [btnBili2 setTitle:@"—" forState:(UIControlStateNormal)];
        [btnFanwei2 setTitle:@"—" forState:(UIControlStateNormal)];
        
        [btnBili2 setTitle:@"—" forState:(UIControlStateSelected)];
        [btnFanwei2 setTitle:@"—" forState:(UIControlStateSelected)];
    }
    
    if (_ratio3 > 0) {
        btnFuhao3.selected = YES;
        
        btnBili3.selected = YES;
        btnFanwei3.selected = YES;
        
        [btnBili3 setTitle:[NSString stringWithFormat:@"%d%%", _ratio3] forState:(UIControlStateNormal)];
        [btnFanwei3 setTitle:[NSString stringWithFormat:@"<%d", _fanwei3] forState:(UIControlStateNormal)];

        [btnBili3 setTitle:[NSString stringWithFormat:@"%d%%", _ratio3] forState:(UIControlStateSelected)];
        [btnFanwei3 setTitle:[NSString stringWithFormat:@"<%d", _fanwei3] forState:(UIControlStateSelected)];
    }
    else {
        btnFuhao3.selected = NO;
        
        btnBili3.selected = NO;
        btnFanwei3.selected = NO;
        
        [btnBili3 setTitle:@"—" forState:(UIControlStateNormal)];
        [btnFanwei3 setTitle:@"—" forState:(UIControlStateNormal)];
        
        [btnBili3 setTitle:@"—" forState:(UIControlStateSelected)];
        [btnFanwei3 setTitle:@"—" forState:(UIControlStateSelected)];
    }
    
    if (_ratio4 > 0) {
        btnFuhao4.selected = YES;
        
        btnBili4.selected = YES;
        btnFanwei4.selected = YES;
        
        [btnBili4 setTitle:[NSString stringWithFormat:@"%d%%", _ratio4] forState:(UIControlStateNormal)];
        [btnFanwei4 setTitle:[NSString stringWithFormat:@"<%d", _fanwei4] forState:(UIControlStateNormal)];

        [btnBili4 setTitle:[NSString stringWithFormat:@"%d%%", _ratio4] forState:(UIControlStateSelected)];
        [btnFanwei4 setTitle:[NSString stringWithFormat:@"<%d", _fanwei4] forState:(UIControlStateSelected)];
    }
    else {
        btnFuhao4.selected = NO;
        
        btnBili4.selected = NO;
        btnFanwei4.selected = NO;
        
        [btnBili4 setTitle:@"—" forState:(UIControlStateNormal)];
        [btnFanwei4 setTitle:@"—" forState:(UIControlStateNormal)];
        
        [btnBili4 setTitle:@"—" forState:(UIControlStateSelected)];
        [btnFanwei4 setTitle:@"—" forState:(UIControlStateSelected)];
    }

}

-(void)resetMyZuheBtnTitle {
    btnTuijian.selected = NO;
    btnMine.selected = YES;
    imgViewZuheBg.highlighted = YES;
    
    btnDelete.hidden = NO;
    btnSave.hidden = NO;
    btnSaveToMine.hidden = YES;

    _myZuhe = [NSMutableArray arrayWithArray: [UserModel sharedInstance].zuheForCurrentUser];
    for (int i=0; i<12; i++) {
        NSDictionary* d1 = [_myZuhe objectAtIndex:i];
        NSString* name1 = [d1 objectForKey:KEY_zuhe_name];
        if (nil == name1) {
            name1 = @"—";
        }
        switch (i) {
            case 0:
                [btnZuhe1 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 1:
                [btnZuhe2 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 2:
                [btnZuhe3 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 3:
                [btnZuhe4 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 4:
                [btnZuhe5 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 5:
                [btnZuhe6 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 6:
                [btnZuhe7 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 7:
                [btnZuhe8 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 8:
                [btnZuhe9 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 9:
                [btnZuhe10 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 10:
                [btnZuhe11 setTitle:name1 forState:(UIControlStateNormal)];
                break;
            case 11:
                [btnZuhe12 setTitle:name1 forState:(UIControlStateNormal)];
                break;
                
            default:
                break;
        }
    }
}

- (void)setBtnTextColor {
    
    UIColor* c1 = [UIColor colorWithRed:(138/255.0f) green:(110/255.0f) blue:(9/255.0f) alpha:1];
    
    [btnZuhe1 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe2 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe3 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe4 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe5 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe6 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe7 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe8 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe9 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe10 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe11 setTitleColor:c1 forState:(UIControlStateNormal)];
    [btnZuhe12 setTitleColor:c1 forState:(UIControlStateNormal)];
}

- (void)setBtnLocalizedTitle {
    
    [btnZuhe1 setTitle:NSLocalizedString(@"zuhe1", nil) forState:(UIControlStateNormal)];
    [btnZuhe2 setTitle:NSLocalizedString(@"zuhe2", nil) forState:(UIControlStateNormal)];
    [btnZuhe3 setTitle:NSLocalizedString(@"zuhe3", nil) forState:(UIControlStateNormal)];
    [btnZuhe4 setTitle:NSLocalizedString(@"zuhe4", nil) forState:(UIControlStateNormal)];
    [btnZuhe5 setTitle:NSLocalizedString(@"zuhe5", nil) forState:(UIControlStateNormal)];
    [btnZuhe6 setTitle:NSLocalizedString(@"zuhe6", nil) forState:(UIControlStateNormal)];
    [btnZuhe7 setTitle:NSLocalizedString(@"zuhe7", nil) forState:(UIControlStateNormal)];
    [btnZuhe8 setTitle:NSLocalizedString(@"zuhe8", nil) forState:(UIControlStateNormal)];
    [btnZuhe9 setTitle:NSLocalizedString(@"zuhe9", nil) forState:(UIControlStateNormal)];
    [btnZuhe10 setTitle:NSLocalizedString(@"zuhe10", nil) forState:(UIControlStateNormal)];
    [btnZuhe11 setTitle:NSLocalizedString(@"zuhe11", nil) forState:(UIControlStateNormal)];
    [btnZuhe12 setTitle:NSLocalizedString(@"zuhe12", nil) forState:(UIControlStateNormal)];
}

#pragma mark lock free version
- (void)setBtnForFreeVersion {
    if ([(AppDelegate*)[UIApplication sharedApplication].delegate bFreeVersion]) {

        [btnSaveToMine setImage:[UIImage imageNamed:@"8.1.png"] forState:(UIControlStateNormal)];
        [btnMine setImage:[UIImage imageNamed:@"8.3.png"] forState:(UIControlStateNormal)];
        
//        [btnZuhe5 setBackgroundImage:[UIImage imageNamed:@"8.1.1.png"] forState:(UIControlStateNormal)];
//        [btnZuhe6 setBackgroundImage:[UIImage imageNamed:@"8.1.1.png"] forState:(UIControlStateNormal)];
//        [btnZuhe7 setBackgroundImage:[UIImage imageNamed:@"8.1.1.png"] forState:(UIControlStateNormal)];
//        [btnZuhe8 setBackgroundImage:[UIImage imageNamed:@"8.1.1.png"] forState:(UIControlStateNormal)];
//        [btnZuhe9 setBackgroundImage:[UIImage imageNamed:@"8.1.1.png"] forState:(UIControlStateNormal)];
//        [btnZuhe10 setBackgroundImage:[UIImage imageNamed:@"8.1.1.png"] forState:(UIControlStateNormal)];
//        [btnZuhe11 setBackgroundImage:[UIImage imageNamed:@"8.1.1.png"] forState:(UIControlStateNormal)];
//        [btnZuhe12 setBackgroundImage:[UIImage imageNamed:@"8.1.1.png"] forState:(UIControlStateNormal)];
    }
    else {
        [btnSaveToMine setImage:[UIImage imageNamed:@"1.1.3.png"] forState:(UIControlStateNormal)];
        [btnMine setImage:[UIImage imageNamed:@"1.1.28.png"] forState:(UIControlStateNormal)];
        
        [btnZuhe5 setBackgroundImage:[UIImage imageNamed:@"1.1.24.png"] forState:(UIControlStateNormal)];
        [btnZuhe6 setBackgroundImage:[UIImage imageNamed:@"1.1.24.png"] forState:(UIControlStateNormal)];
        [btnZuhe7 setBackgroundImage:[UIImage imageNamed:@"1.1.24.png"] forState:(UIControlStateNormal)];
        [btnZuhe8 setBackgroundImage:[UIImage imageNamed:@"1.1.24.png"] forState:(UIControlStateNormal)];
        [btnZuhe9 setBackgroundImage:[UIImage imageNamed:@"1.1.24.png"] forState:(UIControlStateNormal)];
        [btnZuhe10 setBackgroundImage:[UIImage imageNamed:@"1.1.24.png"] forState:(UIControlStateNormal)];
        [btnZuhe11 setBackgroundImage:[UIImage imageNamed:@"1.1.24.png"] forState:(UIControlStateNormal)];
        [btnZuhe12 setBackgroundImage:[UIImage imageNamed:@"1.1.24.png"] forState:(UIControlStateNormal)];
    }
}

- (BOOL)alertForFreeVersion {
    if ([(AppDelegate*)[UIApplication sharedApplication].delegate bFreeVersion]) {

        ssAlertNoTitle(NSLocalizedString(@"Purchase", nil), NSLocalizedString(@"Restore", nil), self);
        return YES;
    }
    else {
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 != buttonIndex) {
        NSLog(@"click buy");
        
        [InAppPurchaseManager singleton].delegate = self;
        
        if (2 == buttonIndex) {
            [[InAppPurchaseManager singleton] restore];
        }
        else {
            NSArray *ids = [NSArray arrayWithObject:@"isnowball_math_regular"]; 
            [[InAppPurchaseManager singleton] requestProductData:ids];
        }
        
    }
}

#pragma mark InAppPurchaseManagerDelegate
-(void)didReceivedProducts:(NSArray *)products
{
    if ([products count] == 0)
    {
        TTAlertNoTitle(@"获取产品信息失败", nil);
        return;
    }
    for(SKProduct *product in products)
    {
        [[InAppPurchaseManager singleton] addPayment:product userID:0 exchangeID:nil];
    }
    
}

//delegate: i show various event in here.
-(void)didFailedTransaction:(NSString *)proIdentifier
{
    TTAlertNoTitle(NSLocalizedString(@"PurchaseFail", nil), nil);
}


-(void)didCompleteTransaction:(NSString *)proIdentifier
{
    TTAlertNoTitle(NSLocalizedString(@"PurchaseSuccess", nil), nil);
}

//恢复
-(void)didFailedRestoreTransaction:(NSError *)error
{
    TTAlertNoTitle(NSLocalizedString(@"RestoreFail", nil), nil);
}

-(void)didRestoreTransaction:(NSString *)proIdentifier
{
    TTAlertNoTitle(NSLocalizedString(@"RestoreSuccess", nil), nil);
    [[NSNotificationCenter defaultCenter]postNotificationName:sb_notify_purchase_ok object:nil];
}

//购买
-(void)didCompleteTransactionAndVerifySucceed:(NSString *)proIdentifier
{
    TTAlertNoTitle(NSLocalizedString(@"PurchaseSuccess", nil), nil);
    [[NSNotificationCenter defaultCenter]postNotificationName:sb_notify_purchase_ok object:nil];
}

-(void)didCompleteTransactionAndVerifyFailed:(NSString *)proIdentifier withError:(NSString *)error
{
    TTAlertNoTitle(NSLocalizedString(@"PurchaseFail", nil), nil);
}

#pragma mark UIInterfaceOrientationIsLandscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
