//
//  MainViewController.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

#import "UserModel.h"
#import "CHKeychain.h"

#import "GoogleMobileAds/GoogleMobileAds.h"

@interface MainViewController () <UITextFieldDelegate, GADInterstitialDelegate>
{
    BOOL _bShowFullAd;
}

@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation MainViewController

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
    if ([[UserModel sharedInstance ]currentUser]) {
        pView.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    pName.delegate = self;
    pAge.delegate = self;
    
    _bShowFullAd = NO;

    if ([(AppDelegate*)[UIApplication sharedApplication].delegate bFreeVersion]) {
        //全屏广告初始
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAD) name:sb_notify_purchase_ok object:nil];

        [self showInterstitial];
    }
}

- (void)showInterstitial {
    //显示全屏广告
    if (!_bShowFullAd) {
        [self performSelector:@selector(showFullAD) withObject:nil afterDelay:3];
    }
}

- (void)showFullAD {
    //显示全屏广告
    _interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3782605513789953/1757771024"];
    _interstitial.delegate = self;
    
    [_interstitial loadRequest:[GADRequest request]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_bannerView) {
        [_bannerView removeFromSuperview];
        _bannerView = nil;
    }
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:[GADRequest request]];
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


- (void)keyboardWillShown:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:NO];
}

#pragma mark action
-(IBAction)returned:(UIStoryboardSegue *)segue {
    
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
    
    pView.hidden = YES;
}

#pragma mark UIInterfaceOrientationIsLandscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark NSNotification
- (void)willEnterForegroundNotification:(NSNotification *)notification {
    [self showInterstitial];
}

- (void)hideAD {
    ((AppDelegate*)[UIApplication sharedApplication].delegate).bFreeVersion = YES;      //测试用的，永远有广告
    [CHKeychain save:KEY_USER_purchased data:[NSNumber numberWithBool:YES]];

    //隐藏全屏广告
}

#pragma mark - admob delegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
}

#pragma mark Display-Time Lifecycle Notifications
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    
}

- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    
}


- (GADBannerView *)bannerView {
    if (_bannerView == nil) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
        _bannerView.adUnitID = @"ca-app-pub-3782605513789953/6327571427";
        _bannerView.rootViewController = self;
        
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        CGFloat offsetX = 0.16 * width;
        _bannerView.size = CGSizeMake(width - offsetX * 2 , 0.1 * height);
        _bannerView.originY = height - _bannerView.height;
        _bannerView.originX = offsetX;
    }
    return _bannerView;
}
@end
