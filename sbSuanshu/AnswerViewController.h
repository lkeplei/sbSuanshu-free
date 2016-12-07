//
//  AnswerViewController.h
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerViewController : UIViewController
{
    IBOutlet UIImageView* imgViewCountDown;
    IBOutlet UIImageView* imgViewHighlightItem;

    IBOutlet UIScrollView* scrollView;

    IBOutlet UIImageView* imgViewDefen;
    IBOutlet UIImageView* imgViewDefenLine;
    IBOutlet UIImageView* imgViewFen;
    IBOutlet UIImageView* imgViewZonhe;
    IBOutlet UIImageView* imgViewZonheLine;

    IBOutlet UIButton* btnMyResult;
    IBOutlet UIButton* btnRedo;

    IBOutlet UIImageView* imgViewDefenNum1;
    IBOutlet UIImageView* imgViewDefenNum2;
    IBOutlet UIImageView* imgViewDefenNum3;
    IBOutlet UIImageView* imgViewZonheNum1;
    IBOutlet UIImageView* imgViewZonheNum2;
    IBOutlet UIImageView* imgViewZonheNum3;
    IBOutlet UIImageView* imgViewZonheNum4;

    IBOutlet UIImageView* imgViewStar1;
    IBOutlet UIImageView* imgViewStar2;
    IBOutlet UIImageView* imgViewStar3;
    IBOutlet UIImageView* imgViewStar4;
    IBOutlet UIImageView* imgViewStar5;
    IBOutlet UIImageView* imgViewStar6;

    IBOutlet UILabel* labelTime;
    IBOutlet UILabel* labelAmount;

    IBOutlet UIView* viewBackAlert;
}

@property(nonatomic, retain) NSMutableArray* arrTimu;
@property(nonatomic) float fDifficulty;
@property(nonatomic) int iStandardTime;
@property(nonatomic) int iMode;     //2/3/10
@property(nonatomic) int iFuhao;    //1|2|4|8:加减乘除

@property(nonatomic) int iCfgCnt;
@property(nonatomic) int iCfgR1;
@property(nonatomic) int iCfgR2;
@property(nonatomic) int iCfgR3;
@property(nonatomic) int iCfgR4;
@property(nonatomic) int iCfgF1;
@property(nonatomic) int iCfgF2;
@property(nonatomic) int iCfgF3;
@property(nonatomic) int iCfgF4;
@property(nonatomic) int iCfgMode;

@end
