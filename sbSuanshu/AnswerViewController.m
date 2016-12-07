//
//  AnswerViewController.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "AnswerViewController.h"
#import "AppDelegate.h"

#import "TwoNumItemView.h"

#import "UserModel.h"

#import "Sound.h"

#define TwoNumItemViewTagOffset     1000

#define Skip_1_Times     10

@interface AnswerViewController ()
{
    int iCnt;
    int _iCurrentNo;
    int _iTotal;
    
    BOOL _bFinish;
    
    NSDate* _startDate;
    NSTimer* _timer1;
}
@end

@implementation AnswerViewController
@synthesize iFuhao =_historyFuhao;
@synthesize arrTimu, fDifficulty, iStandardTime, iMode;
@synthesize iCfgCnt, iCfgF1, iCfgF2, iCfgF3, iCfgF4, iCfgMode, iCfgR1, iCfgR2, iCfgR3, iCfgR4;

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
    iCnt = 3;

    [self performSelector:@selector(chuti) withObject:nil afterDelay:0];
    
    _iCurrentNo = 1;
    
    _bFinish = NO;
    
    labelTime.text = @"00:00";
    labelAmount.text = [NSString stringWithFormat:@"%d/%d", 0, iCfgCnt ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startCountDown
{
    if (iCnt >= 0) {
        switch (iCnt) {
            case 3:
                [imgViewCountDown setImage:[UIImage imageNamed:@"1.2.18.png"]];
                [self performSelector:@selector(startCountDown) withObject:nil afterDelay:1];
                break;

            case 2:
                [imgViewCountDown setImage:[UIImage imageNamed:@"1.2.17.png"]];
                [self performSelector:@selector(startCountDown) withObject:nil afterDelay:1];
                break;

            case 1:
                [imgViewCountDown setImage:[UIImage imageNamed:@"1.2.16.png"]];
                [self performSelector:@selector(startCountDown) withObject:nil afterDelay:1];
                break;

            case 0:
                imgViewCountDown.hidden = YES;
                imgViewHighlightItem.hidden = NO;
            {
                float x = 0;
                float y = 0;
                float w = 574;
                float h = 70;
                for (int i=0; i<_iTotal; i++) {
                    TwoNumItemView* v2 = [TwoNumItemView create];
                    
                    if (![v2 isKindOfClass:[TwoNumItemView class]]) {
                        continue;
                    }
                    
                    NSMutableArray* a1 = [arrTimu objectAtIndex:i];

                    NSMutableArray* a2 = [a1 objectAtIndex:0];
                    
                    v2.labelNo.textColor = [UIColor colorWithRed:122/255.0f green:83/255.0f blue:28/255.0f alpha:1];
                    v2.labelNo.text = [NSString stringWithFormat:@"%d", (i+1)];
                    v2.tag = i + 1 + TwoNumItemViewTagOffset;
                    v2.imgViewCorret.hidden = YES;
                    
                    NSString* timu;
//                    NSString* result1;

                    if ([a1 count] > 1) {
                        NSString* timuTmp;

                        NSMutableArray* a3 = [a1 objectAtIndex:2];

                        switch ([[a3 objectAtIndex:3]integerValue]) {
                            case 1:
                                timuTmp = [NSString stringWithFormat:@"%d + %d", [[a3 objectAtIndex:2]integerValue], [[a3 objectAtIndex:4]integerValue]];
                                break;
                            case 2:
                                timuTmp = [NSString stringWithFormat:@"%d - %d", [[a3 objectAtIndex:2]integerValue], [[a3 objectAtIndex:4]integerValue]];
                                break;
                            case 4:
                                timuTmp = [NSString stringWithFormat:@"%d × %d", [[a3 objectAtIndex:2]integerValue], [[a3 objectAtIndex:4]integerValue]];
                                break;
                            case 8:
                                timuTmp = [NSString stringWithFormat:@"%d ÷ %d", [[a3 objectAtIndex:2]integerValue], [[a3 objectAtIndex:4]integerValue]];
                                break;
                                
                            default:
                                break;
                        }
                        
                        switch ([[a1 objectAtIndex:1]integerValue]) {
                            case 1:
                            {
                                switch ([[a2 objectAtIndex:3]integerValue]) {
                                    case 1:
                                        timu = [NSString stringWithFormat:@"%@ + %d = ", timuTmp, [[a2 objectAtIndex:4]integerValue]];
                                        break;
                                    case 2:
                                        timu = [NSString stringWithFormat:@"%@ - %d = ", timuTmp, [[a2 objectAtIndex:4]integerValue]];
                                        break;
                                    case 4:
                                        timu = [NSString stringWithFormat:@"%@ × %d = ", timuTmp, [[a2 objectAtIndex:4]integerValue]];
                                        break;
                                    case 8:
                                        timu = [NSString stringWithFormat:@"%@ ÷ %d = ", timuTmp, [[a2 objectAtIndex:4]integerValue]];
                                        break;
                                        
                                    default:
                                        break;
                                }
                            }
                                break;
                            case 2:
                            {
                                switch ([[a2 objectAtIndex:3]integerValue]) {
                                    case 1:
                                        timu = [NSString stringWithFormat:@"%d + %@ = ", [[a2 objectAtIndex:2]integerValue], timuTmp];
                                        break;
                                    case 2:
                                        timu = [NSString stringWithFormat:@"%d - %@ = ", [[a2 objectAtIndex:2]integerValue], timuTmp];
                                        break;
                                    case 4:
                                        timu = [NSString stringWithFormat:@"%d × %@ = ", [[a2 objectAtIndex:2]integerValue], timuTmp];
                                        break;
                                    case 8:
                                        timu = [NSString stringWithFormat:@"%d ÷ %@ = ", [[a2 objectAtIndex:2]integerValue], timuTmp];
                                        break;
                                        
                                    default:
                                        break;
                                }
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                    else {
                        switch ([[a2 objectAtIndex:3]integerValue]) {
                            case 1:
                                timu = [NSString stringWithFormat:@"%d + %d = ", [[a2 objectAtIndex:2]integerValue], [[a2 objectAtIndex:4]integerValue]];
                                break;
                            case 2:
                                timu = [NSString stringWithFormat:@"%d - %d = ", [[a2 objectAtIndex:2]integerValue], [[a2 objectAtIndex:4]integerValue]];
                                break;
                            case 4:
                                timu = [NSString stringWithFormat:@"%d × %d = ", [[a2 objectAtIndex:2]integerValue], [[a2 objectAtIndex:4]integerValue]];
                                break;
                            case 8:
                                timu = [NSString stringWithFormat:@"%d ÷ %d = ", [[a2 objectAtIndex:2]integerValue], [[a2 objectAtIndex:4]integerValue]];
                                break;
                                
                            default:
                                break;
                        }
                    }

                    v2.labelQuestion.text = timu;
                    
//                    result1 = [NSString stringWithFormat:@"%d", [[a2 objectAtIndex:1]integerValue]];
//                    v2.labelResult.text = result1;
                    v2.labelResult.text = @"";
                    
                    v2.labelResult.tag = [[a2 objectAtIndex:1]integerValue];
                    
                    v2.frame = CGRectMake(x, y, w, h);
                    [scrollView addSubview:v2];
                    
                    y += 70;
                }
                scrollView.contentSize = CGSizeMake(w, h*_iTotal);
                float yOffset = scrollView.frame.size.height/2 - 35;
        
                scrollView.contentOffset = CGPointMake(0, -yOffset);
                [self setAlphaForRows];
                
                _startDate = [NSDate date];
                _timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
            }
                break;

            default:
                break;
        }
        
        iCnt -= 1;
    }
    
}

#pragma mark action
-(IBAction)btnClicked:(UIButton*)btn
{
    //倒数时，锁定键盘
    if (imgViewCountDown.hidden == NO) {
        return;
    }
    
    [Sound playBtnSnd];
    
    TwoNumItemView* vCurrent = (TwoNumItemView*)[scrollView viewWithTag:(_iCurrentNo+TwoNumItemViewTagOffset)];
    switch (btn.tag) {
        case 101:
        {
            if (_bFinish) {
                break;
            }
            if ([vCurrent.labelResult.text length] == 3) {
                break;
            }
            vCurrent.labelResult.text = [vCurrent.labelResult.text stringByAppendingString:@"1"];
        }
            break;
        case 102:
        {
            if (_bFinish) {
                break;
            }
            if ([vCurrent.labelResult.text length] == 3) {
                break;
            }
            vCurrent.labelResult.text = [vCurrent.labelResult.text stringByAppendingString:@"2"];
        }
            break;
        case 103:
        {
            if (_bFinish) {
                break;
            }
            if ([vCurrent.labelResult.text length] == 3) {
                break;
            }
            vCurrent.labelResult.text = [vCurrent.labelResult.text stringByAppendingString:@"3"];
        }
            break;
        case 104:
        {
            if (_bFinish) {
                break;
            }
            if ([vCurrent.labelResult.text length] == 3) {
                break;
            }
            vCurrent.labelResult.text = [vCurrent.labelResult.text stringByAppendingString:@"4"];
        }
            break;
        case 105:
        {
            if (_bFinish) {
                break;
            }
            if ([vCurrent.labelResult.text length] == 3) {
                break;
            }
            vCurrent.labelResult.text = [vCurrent.labelResult.text stringByAppendingString:@"5"];
        }
            break;
        case 106:
        {
            if (_bFinish) {
                break;
            }
            if ([vCurrent.labelResult.text length] == 3) {
                break;
            }
            vCurrent.labelResult.text = [vCurrent.labelResult.text stringByAppendingString:@"6"];
        }
            break;
        case 107:
        {
            if (_bFinish) {
                break;
            }
            if ([vCurrent.labelResult.text length] == 3) {
                break;
            }
            vCurrent.labelResult.text = [vCurrent.labelResult.text stringByAppendingString:@"7"];
        }
            break;
        case 108:
        {
            if (_bFinish) {
                break;
            }
            if ([vCurrent.labelResult.text length] == 3) {
                break;
            }
            vCurrent.labelResult.text = [vCurrent.labelResult.text stringByAppendingString:@"8"];
        }
            break;
        case 109:
        {
            if (_bFinish) {
                break;
            }
            if ([vCurrent.labelResult.text length] == 3) {
                break;
            }
            vCurrent.labelResult.text = [vCurrent.labelResult.text stringByAppendingString:@"9"];
        }
            break;
        case 100:
        {
            if (_bFinish) {
                break;
            }
            if ([vCurrent.labelResult.text length] == 3) {
                break;
            }
            vCurrent.labelResult.text = [vCurrent.labelResult.text stringByAppendingString:@"0"];
        }
            break;

        case 123:
        {
            if (_bFinish) {
                break;
            }
            NSString* tmp = vCurrent.labelResult.text;
            if ([tmp length] > 0) {
               vCurrent.labelResult.text = [tmp substringToIndex:([tmp length] - 1)];
            }
        }
            break;

        case 121:
        {
            if (_bFinish) {
                break;
            }
            
            if (_iCurrentNo > 1) {
                _iCurrentNo -= 1;
                CGPoint p1 = scrollView.contentOffset;
                p1.y -= 70;
                scrollView.contentOffset = p1;
                [self setAlphaForRows];

                labelAmount.text = [NSString stringWithFormat:@"%d/%d", _iCurrentNo-1, _iTotal ];

            }
        }
            break;

        case 122:
        case 124:
        {
            if (_bFinish) {
                break;
            }

            if (_iCurrentNo < _iTotal) {
                _iCurrentNo += 1;
                CGPoint p1 = scrollView.contentOffset;
                p1.y += 70;
                scrollView.contentOffset = p1;
                [self setAlphaForRows];

                labelAmount.text = [NSString stringWithFormat:@"%d/%d", _iCurrentNo-1, _iTotal ];
            }
            else {
                _bFinish = YES;
                
                labelAmount.text = [NSString stringWithFormat:@"%d/%d", _iCurrentNo, _iTotal ];
                
                imgViewHighlightItem.hidden = YES;
                
                imgViewDefen.hidden = NO;
                imgViewDefenLine.hidden = NO;
//                imgViewFen.hidden = NO;
                imgViewZonhe.hidden = NO;
                imgViewZonheLine.hidden = NO;
                btnMyResult.hidden = NO;
                btnRedo.hidden = NO;
                
                scrollView.scrollEnabled = YES;
                scrollView.contentOffset = CGPointMake(0, 0);
                [self setAlphaForRows];

                [self doAfterFinish];
            }
        }
            break;
            
        case 202:
        {
            imgViewHighlightItem.hidden = NO;
            
            imgViewDefen.hidden = YES;
            imgViewDefenLine.hidden = YES;
            imgViewFen.hidden = YES;
            imgViewZonhe.hidden = YES;
            imgViewZonheLine.hidden = YES;
            btnMyResult.hidden = YES;
            btnRedo.hidden = YES;
            
            scrollView.scrollEnabled = NO;
            float yOffset = scrollView.frame.size.height/2 - 35;
            scrollView.contentOffset = CGPointMake(0, -yOffset);
            _iCurrentNo = 1;
            
            _bFinish = NO;
            
            [self setAlphaForRows];

            [self resetAfterFinish];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    if (_bFinish) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        viewBackAlert.hidden = NO;
    }
}

- (IBAction)btnOnAlertClicked:(UIButton*)sender
{
    if (sender.tag == 101) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        viewBackAlert.hidden = YES;
    }
}

#pragma mark private
- (void) doAfterFinish {
    int iCorrectCnt = 0;
    
    NSMutableDictionary *wrongDic;
    NSMutableArray *wrongArray;
    
    for (int i=1; i<= _iTotal; i++) {
        TwoNumItemView* vTmp = (TwoNumItemView*)[scrollView viewWithTag:(i+TwoNumItemViewTagOffset)];
        if (![vTmp isKindOfClass:[TwoNumItemView class]]) {
            continue;
        }
        if ([vTmp.labelResult.text intValue] == vTmp.labelResult.tag) {
            vTmp.imgViewCorret.highlighted = NO;
            iCorrectCnt++;
        } else {
            vTmp.imgViewCorret.highlighted = YES;
            
            if (wrongDic == nil) {
                wrongArray = [NSMutableArray array];
                
                wrongDic = [NSMutableDictionary dictionary];
                [wrongDic setObject:[KenUtils getStringFromDate:[NSDate date] format:kDateFormat] forKey:KEY_wrong_date];
                [wrongDic setObject:wrongArray forKey:KEY_wrong_data];
            }

            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObject:[NSNumber numberWithInt:[vTmp.labelResult.text intValue]]];
            
            NSArray *timu = [self.arrTimu objectAtIndex:i - 1];
            if ([timu count] > 1) {
                [tempArray addObject:@[timu[0][0], timu[0][1],
                                       timu[2][2], timu[2][3], timu[2][4], timu[0][3], timu[0][4]]];
            } else {
                [tempArray addObjectsFromArray:timu];
            }
            
            [wrongArray addObject:tempArray];
        }
        vTmp.imgViewCorret.hidden = NO;
    }

    int iFenshu = iCorrectCnt * 100 / _iTotal;

    [imgViewDefenNum1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"1.2.%d.png", (22+iFenshu/100)]]];
    imgViewDefenNum1.hidden = NO;
    [imgViewDefenNum2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"1.2.%d.png", (22+(iFenshu%100)/10)]]];
    imgViewDefenNum2.hidden = NO;
    [imgViewDefenNum3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"1.2.%d.png", (22+(iFenshu%10))]]];
    imgViewDefenNum3.hidden = NO;
    if(iFenshu < 10)
    {
        imgViewDefenNum1.hidden = YES;
        imgViewDefenNum2.hidden = YES;
    }
    else if(iFenshu < 100)
    {
        imgViewDefenNum1.hidden = YES;
    }

    float fDuration = (- [_startDate timeIntervalSinceNow]);
    int iZongheFenshu = fDifficulty * (iFenshu/10.0f) * (iFenshu/10.0f) * sqrt(iStandardTime/fDuration);

    [imgViewZonheNum1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"1.2.%d.png", (22+iZongheFenshu/1000)]]];
    imgViewZonheNum1.hidden = NO;
    [imgViewZonheNum2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"1.2.%d.png", (22+(iZongheFenshu%1000)/100)]]];
    imgViewZonheNum2.hidden = NO;
    [imgViewZonheNum3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"1.2.%d.png", (22+(iZongheFenshu%100)/10)]]];
    imgViewZonheNum3.hidden = NO;
    [imgViewZonheNum4 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"1.2.%d.png", (22+(iZongheFenshu%10))]]];
    imgViewZonheNum4.hidden = NO;

    if(iZongheFenshu < 10)
    {
        imgViewZonheNum1.hidden = YES;
        imgViewZonheNum2.hidden = YES;
        imgViewZonheNum3.hidden = YES;
    }
    else if(iZongheFenshu < 100)
    {
        imgViewZonheNum1.hidden = YES;
        imgViewZonheNum2.hidden = YES;
    }
    else if(iZongheFenshu < 1000)
    {
        imgViewZonheNum1.hidden = YES;
    }

    [_timer1 invalidate];
    
    NSMutableDictionary* item = [NSMutableDictionary dictionary];
//    [item setObject:_startDate forKey:KEY_History_date];
    [item setObject:[NSDate date] forKey:KEY_History_date];
    [item setObject:[NSNumber numberWithInt:self.iFuhao] forKey:KEY_History_fuhao];
    [item setObject:[NSNumber numberWithInt:iMode] forKey:KEY_History_mode];
    [item setObject:[NSNumber numberWithInt:_iTotal] forKey:KEY_History_cnt];
    [item setObject:[NSNumber numberWithFloat:fDuration] forKey:KEY_History_duration];
    [item setObject:[NSNumber numberWithInt:iFenshu] forKey:KEY_History_defen];
    [item setObject:[NSNumber numberWithFloat:fDifficulty] forKey:KEY_History_nandu];
    [item setObject:[NSNumber numberWithInt:iZongheFenshu] forKey:KEY_History_zonghe];
    
    [[UserModel sharedInstance]addHistoryItemForCurrentUser:item];
    
    [[UserModel sharedInstance] addWrongForCurrentUser:wrongDic];
}

- (void) resetAfterFinish {
    for (int i=1; i<= _iTotal; i++) {
        TwoNumItemView* vTmp = (TwoNumItemView*)[scrollView viewWithTag:(i+TwoNumItemViewTagOffset)];
        if (![vTmp isKindOfClass:[TwoNumItemView class]]) {
            continue;
        }

//        vTmp.imgViewCorret.hidden = YES;
//        vTmp.labelResult.text = @"";
        [vTmp removeFromSuperview];
    }
    
    imgViewDefenNum1.hidden = YES;
    imgViewDefenNum2.hidden = YES;
    imgViewDefenNum3.hidden = YES;
    imgViewZonheNum1.hidden = YES;
    imgViewZonheNum2.hidden = YES;
    imgViewZonheNum3.hidden = YES;
    imgViewZonheNum4.hidden = YES;
    
    labelTime.text = @"00:00";
    labelAmount.text = [NSString stringWithFormat:@"%d/%d", _iCurrentNo-1, _iTotal ];
    
    iCnt = 3;

    [self performSelector:@selector(chuti) withObject:nil afterDelay:0];
    
    imgViewCountDown.hidden = NO;
    imgViewHighlightItem.hidden = YES;
}

- (void) updateTime {
    NSTimeInterval t1 = - [_startDate timeIntervalSinceNow];

    int m = t1/60;
    int s = (int)t1%60;
    
    labelTime.text = [NSString stringWithFormat:@"%02d:%02d", m, s];
}

- (void) setAlphaForRows {
    for (int i=1; i<= _iTotal; i++) {
        TwoNumItemView* vTmp = (TwoNumItemView*)[scrollView viewWithTag:(i+TwoNumItemViewTagOffset)];
        int tmp = abs(i - _iCurrentNo);
        if (_bFinish) {
            vTmp.alpha = 1;
        }
        else if (0 == tmp) {
            vTmp.alpha = 1;
        }
        else if(1 == tmp)
        {
            vTmp.alpha = 0.66;
        }
        else if(2 == tmp)
        {
            vTmp.alpha = 0.33;
        }
        else
        {
            vTmp.alpha = 0;
        }
    }
}

-(void)chuti {
    //出题
    NSMutableArray* selectedTimus = [NSMutableArray array];
    int iFuhaoCnt = 0;
    int iTixing = 0;
    {
        if (nil == [(AppDelegate*)[UIApplication sharedApplication].delegate tiku]) {
            NSLog(@"wait 1 second");
            [self performSelector:@selector(chuti) withObject:nil afterDelay:1];
            return;
        }

        NSMutableArray* all = [NSMutableArray arrayWithArray:[(AppDelegate*)[UIApplication sharedApplication].delegate tiku]];
        
        int i3NumCnt = 0;
        
        switch (iCfgMode) {
            case 2:
                iFuhaoCnt = iCfgCnt * 1;
                break;
                
            case 3:
                iFuhaoCnt = iCfgCnt * 2;
                i3NumCnt = iCfgCnt;
                break;
                
            case 10:
                iFuhaoCnt = iCfgCnt/2 * (1+2);
                i3NumCnt = iCfgCnt/2;
                break;
                
            default:
                break;
        }
        int iJia = iFuhaoCnt * iCfgR1 / 100;
        int iJian = iFuhaoCnt * iCfgR2 / 100;
        int iCheng = iFuhaoCnt * iCfgR3 / 100;
        int iChu = iFuhaoCnt * iCfgR4 / 100;
        
        //检查
        if (iFuhaoCnt != (iJia + iJian + iCheng + iChu)) {
            if (iCfgR4 != 0) {
                iChu = iFuhaoCnt - iJia - iJian - iCheng;
            }
            else if (iCfgR3 != 0) {
                iCheng = iFuhaoCnt - iJia - iJian;
            }
            else if (iCfgR2 != 0) {
                iJian = iFuhaoCnt - iJia;
            }
            else {
                iJia = iFuhaoCnt;
            }
        }
        
        if (iJia) {
            iTixing |= 1;
        }
        if (iJian) {
            iTixing |= 2;
        }
        if (iCheng) {
            iTixing |= 4;
        }
        if (iChu) {
            iTixing |= 8;
        }
        
        //先加减，后乘除
        BOOL bReset = NO;
        int iErrCnt = 0;
        
        //计算难度系数
        float fDifficulty1 = 0;
        float fDifficulty2 = 0;
        float fDifficulty3 = 0;
        float fDifficulty4 = 0;
        float fDifficulty5 = 0;
        
        switch (iCfgF1) {
            case 10:
                fDifficulty1 = 1.0;
                break;
            case 20:
                fDifficulty1 = 1.5;
                break;
            case 100:
                fDifficulty1 = 2.5;
                break;
            case 500:
                fDifficulty1 = 3.6;
                break;
                
            default:
                break;
        }
        switch (iCfgF2) {
            case 10:
                fDifficulty2 = 1.2;
                break;
            case 20:
                fDifficulty2 = 1.8;
                break;
            case 100:
                fDifficulty2 = 2.5;
                break;
            case 500:
                fDifficulty2 = 3.6;
                break;
                
            default:
                break;
        }
        switch (iCfgF3) {
            case 10:
                fDifficulty3 = 0.0;
                break;
            case 20:
                fDifficulty3 = 2.5;
                break;
            case 100:
                fDifficulty3 = 4.0;
                break;
            case 500:
                fDifficulty3 = 5.0;
                break;
                
            default:
                break;
        }
        switch (iCfgF4) {
            case 10:
                fDifficulty4 = 0.0;
                break;
            case 20:
                fDifficulty4 = 2.5;
                break;
            case 100:
                fDifficulty4 = 4.0;
                break;
            case 500:
                fDifficulty4 = 5.0;
                break;
                
            default:
                break;
        }
        
        switch (iCfgMode) {
            case 2:
                fDifficulty5 = 1.0;
                break;
            case 3:
                fDifficulty5 = 1.4;
                break;
            case 10:
                fDifficulty5 = 1.2;
                break;
                
            default:
                break;
        }
        //难度星级值=（Σ题目类型难度系数X占比）X题目形式难度系数
        fDifficulty = (fDifficulty1 * iJia / iFuhaoCnt
                       + fDifficulty2 * iJian / iFuhaoCnt
                       + fDifficulty3 * iCheng / iFuhaoCnt
                       + fDifficulty4 * iChu / iFuhaoCnt) * fDifficulty5;
        
        
        int iSkipTimes = 0;
        for (; ((iJia > 0) || (iJian > 0) || (iCheng > 0)||(iChu > 0)); ) {
            
            //找不到题目，找重复的题目
            if (bReset) {
                all = [NSMutableArray arrayWithArray:[(AppDelegate*)[UIApplication sharedApplication].delegate tiku]];
                bReset = NO;
            }
            
            //先3个数，后2个数，免得不能拆分。
            //左边拆分不了，拆分右边
            //都不能拆分，换题
            NSMutableArray* tmp = [NSMutableArray array];   //选出的题目
            
            int iType = 0;  //0:两个数；1：拆分左边；2:拆分右边；
            
            int iResult = 0;    //拆分的数
            
            int iFuhao1 = [self getFuhao:iJia jian:iJian cheng:iCheng chu:iChu forFuhao:0];
            NSMutableArray* t1 = [self getTimu:all fuhao:iFuhao1 result:iResult];
            if (nil == t1) {
                NSLog(@"error1, cann't find one in tiku");
                bReset = YES;
                
                continue;
            }
            else {
                //过滤掉包含1的题目  //过滤掉除法，除自己
                if ((1 == [[t1 objectAtIndex:2] integerValue]) || (1 == [[t1 objectAtIndex:4] integerValue])
                    || ((3 == iFuhao1) && ([[t1 objectAtIndex:2] integerValue] == [[t1 objectAtIndex:4] integerValue]))) {
                    iSkipTimes++;
                    if (Skip_1_Times == iSkipTimes) {
                        NSLog(@"not skip 1 ");
                        iSkipTimes = 0;
                    }
                    else {
                        NSLog(@"skip 1 ");
                        continue;
                    }
                }
                iSkipTimes = 0;
            }
            
            if (i3NumCnt > 0) {
                
                iType = arc4random() % 2 + 1;
                
                if (iType == 1) {
                    iResult = [[t1 objectAtIndex:2] integerValue];
                }
                else if(iType == 2) {
                    iResult = [[t1 objectAtIndex:4] integerValue];
                }
                
                int iFuhao2 = 0;
                switch (iFuhao1) {
                    case 0:
                        iFuhao2 = [self getFuhao:(iJia-1) jian:iJian cheng:iCheng chu:iChu forFuhao:(iFuhao1)];
                        //拆分加法，左边都可以，右边不能减法
                        if (iType == 2 && iFuhao2 ==1) {
                            NSLog(@"拆分加法，右边不能减法, 左边加法可能超出范围");
                            continue;
                        }
                        break;
                    case 1:
                        iFuhao2 = [self getFuhao:iJia jian:(iJian-1) cheng:iCheng chu:iChu forFuhao:(iFuhao1)];
                        //拆分减法，右边只可以乘除
                        if (iType == 2 && ((iFuhao2 ==0)||(iFuhao2 ==1))) {
                            NSLog(@"拆分减法，右边只可以乘除");
                            continue;
                        }
                        break;
                    case 2:
                        iFuhao2 = [self getFuhao:iJia jian:iJian cheng:(iCheng-1) chu:iChu forFuhao:(iFuhao1)];
                        if (iType == 2 && iFuhao2 == 3) {
                            NSLog(@"乘法，右边不能拆分拆分成除法");
                            continue;
                        }
                        break;
                    case 3:
                        if (iType == 2) {
                            NSLog(@"除法，右边不能拆分");
                            continue;
                        }
                        iFuhao2 = [self getFuhao:iJia jian:iJian cheng:iCheng chu:(iChu-1) forFuhao:(iFuhao1)];
                        break;
                        
                    default:
                        break;
                }
                
                if (-1 == iFuhao2) {
                    NSLog(@"乘除，找不到乘号除号了，重新出题");
                    continue;
                }
                
                NSMutableArray* t2 = [self getTimu:all fuhao:iFuhao2 result:iResult];
                
                if (t2) {

                    //过滤掉包含1的题目
                    if ((1 == [[t2 objectAtIndex:2] integerValue]) || (1 == [[t2 objectAtIndex:4] integerValue])) {
                        iSkipTimes++;
                        if (Skip_1_Times == iSkipTimes) {
                            NSLog(@"not skip 1 ");
                            iSkipTimes = 0;
                        }
                        else {
                            NSLog(@"skip 1 ");
                            continue;
                        }
                    }
                    iSkipTimes = 0;

                    [tmp addObject:t1];
                    [tmp addObject:[NSNumber numberWithInt:iType]];
                    [tmp addObject:t2];
                    
                    //添加之后，all中删除，避免重复选择
                    [self removeSelectedTimu:t1 from:all];
                    
                    //更新剩余的符号
                    i3NumCnt--;
                    switch (iFuhao1) {
                        case 0:
                            iJia--;
                            break;
                        case 1:
                            iJian--;
                            break;
                        case 2:
                            iCheng--;
                            break;
                        case 3:
                            iChu--;
                            break;
                            
                        default:
                            break;
                    }
                    
                    switch (iFuhao2) {
                        case 0:
                            iJia--;
                            break;
                        case 1:
                            iJian--;
                            break;
                        case 2:
                            iCheng--;
                            break;
                        case 3:
                            iChu--;
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                else {
                    //三个数的，如果不能拆分，换题？找重复的题目？
                    
                    iErrCnt++;
                    if (iErrCnt == 100) {
                        NSLog(@"error3, cann't find one in tiku 100 times");
                        iErrCnt = 0;
                        bReset = YES;
                    }
                    NSLog(@"error2, cann't find one in tiku");
                    continue;   //重新选题
                }
            }
            else {
                [tmp addObject:t1];
                //添加之后，all中删除，避免重复选择
                [self removeSelectedTimu:t1 from:all];
                
                //更新剩余的符号
                switch (iFuhao1) {
                    case 0:
                        iJia--;
                        break;
                    case 1:
                        iJian--;
                        break;
                    case 2:
                        iCheng--;
                        break;
                    case 3:
                        iChu--;
                        break;
                        
                    default:
                        break;
                }
                
            }
            
            [selectedTimus addObject:tmp];
            
        }
        
        if ([selectedTimus count] != iCfgCnt) {
            NSLog(@"([selectedTimus count] != _count)");
        }
    }
    
    //打乱顺序
    NSMutableArray* luan = [NSMutableArray arrayWithArray:selectedTimus];
    //        while ([selectedTimus count] > 0) {
    //            id obj1 = [selectedTimus objectAtIndex:(arc4random()%[selectedTimus count])];
    //
    //            [luan addObject:obj1];
    //
    //            [selectedTimus removeObject:obj1];
    //        }
    for (NSInteger i = luan.count-1; i > 0; i--)
    {
        [luan exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(i+1)];
    }
    
    self.arrTimu = luan;
    self.fDifficulty = fDifficulty;
    self.iStandardTime = iFuhaoCnt * 6;
    self.iMode = iCfgMode;
    self.iFuhao = iTixing;
    
    _iTotal = [arrTimu count];

    imgViewStar1.highlighted = NO;
    imgViewStar2.highlighted = NO;
    imgViewStar3.highlighted = NO;
    imgViewStar4.highlighted = NO;
    imgViewStar5.highlighted = NO;
    imgViewStar6.highlighted = NO;
    if (fDifficulty < 2.0) {
        imgViewStar1.highlighted = YES;
    }
    else if (fDifficulty < 3.0) {
        imgViewStar1.highlighted = YES;
        imgViewStar2.highlighted = YES;
    }
    else if (fDifficulty < 4.0) {
        imgViewStar1.highlighted = YES;
        imgViewStar2.highlighted = YES;
        imgViewStar3.highlighted = YES;
    }
    else if (fDifficulty < 5.0) {
        imgViewStar1.highlighted = YES;
        imgViewStar2.highlighted = YES;
        imgViewStar3.highlighted = YES;
        imgViewStar4.highlighted = YES;
    }
    else if (fDifficulty < 6.0) {
        imgViewStar1.highlighted = YES;
        imgViewStar2.highlighted = YES;
        imgViewStar3.highlighted = YES;
        imgViewStar4.highlighted = YES;
        imgViewStar5.highlighted = YES;
    }
    else {
        imgViewStar1.highlighted = YES;
        imgViewStar2.highlighted = YES;
        imgViewStar3.highlighted = YES;
        imgViewStar4.highlighted = YES;
        imgViewStar5.highlighted = YES;
        imgViewStar6.highlighted = YES;
    }
    
    labelTime.text = @"00:00";
    labelAmount.text = [NSString stringWithFormat:@"%d/%d", 0, _iTotal ];
    
    [self startCountDown];
}

-(int)getFuhao:(int)iJia jian:(int)iJian cheng:(int)iCheng chu:(int)iChu forFuhao:(int)iFuhao
{
    int iRet = 0;
    
    
    //拆分乘法，只能乘除
    if (iFuhao==2) {
        if (0 == (iCheng + iChu)) {
            //没有乘除了，出错
            return -1;
        }
        int iTotal = iCheng + iChu;
        
        iRet = arc4random()%iTotal + 1;
        if (iRet > (iCheng)) {
            iRet = 3;
        }
        else{
            iRet = 2;
        }
        
    }
    //拆分除法，左边可以乘除，右边不能拆分
    else if (iFuhao==3) {
        if (0 == (iCheng + iChu)) {
            //没有乘除了，出错
            return -1;
        }

        int iTotal = iCheng + iChu;
        
        iRet = arc4random()%iTotal + 1;
        if (iRet > (iCheng)) {
            iRet = 3;
        }
        else{
            iRet = 2;
        }
        
    }
    else {
        int iTotal = iJia + iJian + iCheng + iChu;
        
        iRet = arc4random()%iTotal + 1;
        if (iRet > (iJia + iJian + iCheng)) {
            iRet = 3;
        }
        else if (iRet > (iJia + iJian)) {
            iRet = 2;
        }
        else if (iRet > (iJia)) {
            iRet = 1;
        }
        else{
            iRet = 0;
        }
    }
    
    return iRet;
}

-(NSMutableArray*)getTimu:(NSMutableArray*)all fuhao:(int)iFuhao result:(int)iResult
{
    NSMutableArray* toChoose;
    NSMutableArray* toChoose2 = [NSMutableArray array];
    
    int iFanwei = iCfgF1;
    
    switch (iFuhao) {
        case 0:
            iFanwei = iCfgF1;
            break;
        case 1:
            iFanwei = iCfgF2;
            break;
        case 2:
            iFanwei = iCfgF3;
            break;
        case 3:
            iFanwei = iCfgF4;
            break;
            
        default:
            break;
    }
    
    int iIndex2 = 0;
    switch (iFanwei) {
        case 10:
            iIndex2 = 0;
            break;
        case 20:
//            iIndex2 = 1;
            iIndex2 = arc4random_uniform(2);
            break;
        case 100:
//            iIndex2 = 2;
            iIndex2 = arc4random_uniform(3);
            break;
        case 500:
//            iIndex2 = 3;
            iIndex2 = arc4random_uniform(4);
            break;
        default:
            break;
    }

    /*
     出100以内和500以内的加减法的时候，不出10以内的题目。这个限制只是针对两个数的题目。
     */
    if (((iFuhao==0)||(iFuhao==1))&&(0==iResult)) {
        switch (iFanwei) {
            case 100:
                iIndex2 = arc4random_uniform(2) + 1;
                break;
            case 500:
                iIndex2 = arc4random_uniform(3) + 1;
                break;
            default:
                break;
        }
    }
    
    
    if ([all count] == 0) {
        return nil;
    }
    NSArray* tmpA1 = [all objectAtIndex:iFuhao];
    if ((iIndex2+1) > [tmpA1 count]) {
        return nil;
    }
    toChoose  = [tmpA1 objectAtIndex:iIndex2];
    if (![toChoose isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (0 != iResult) {
        
        for (NSMutableArray* tmp in toChoose) {
            if (iResult == [[tmp objectAtIndex:1]integerValue]) {
                [toChoose2 addObject:tmp];
            }
        }
        
        toChoose = toChoose2;
    }
    
    if ([toChoose count] == 0) {
        return nil;
    }
    
    return [toChoose objectAtIndex:(arc4random()%[toChoose count])];
}

-(void)removeSelectedTimu:(NSMutableArray*)timu from:(NSMutableArray*)all {
    return;
    
    for (int i=0; i<4; i++) {
        
        NSMutableArray* a1 = [all objectAtIndex:i];
        
        for (int j=0; j<4; j++) {
            NSMutableArray* a2 = [a1 objectAtIndex:i];
            
            if ([a2 containsObject:timu]) {
                [a2 removeObject:timu];
                break;
            }
        }
        
    }
}

#pragma mark UIInterfaceOrientationIsLandscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
