//
//  ConfigViewController.h
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController
{
    IBOutlet UIButton* btnTuijian;
    IBOutlet UIButton* btnMine;

    IBOutlet UIImageView* imgViewZuheBg;

    IBOutlet UIButton* btnSave;
    IBOutlet UIButton* btnDelete;
    IBOutlet UIButton* btnSaveToMine;

    IBOutlet UIButton* btnShuliang;
    IBOutlet UIButton* btnBili1;
    IBOutlet UIButton* btnBili2;
    IBOutlet UIButton* btnBili3;
    IBOutlet UIButton* btnBili4;
    IBOutlet UIButton* btnFanwei1;
    IBOutlet UIButton* btnFanwei2;
    IBOutlet UIButton* btnFanwei3;
    IBOutlet UIButton* btnFanwei4;

    IBOutlet UIButton* btnZuhe1;
    IBOutlet UIButton* btnZuhe2;
    IBOutlet UIButton* btnZuhe3;
    IBOutlet UIButton* btnZuhe4;
    IBOutlet UIButton* btnZuhe5;
    IBOutlet UIButton* btnZuhe6;
    IBOutlet UIButton* btnZuhe7;
    IBOutlet UIButton* btnZuhe8;
    IBOutlet UIButton* btnZuhe9;
    IBOutlet UIButton* btnZuhe10;
    IBOutlet UIButton* btnZuhe11;
    IBOutlet UIButton* btnZuhe12;

    IBOutlet UIButton* btn2Num;
    IBOutlet UIButton* btn3Num;
    IBOutlet UIButton* btnMixed;

    IBOutlet UIButton* btnFuhao1;
    IBOutlet UIButton* btnFuhao2;
    IBOutlet UIButton* btnFuhao3;
    IBOutlet UIButton* btnFuhao4;

    IBOutlet UIView* viewSave;
    IBOutlet UITextField* textFieldName;
    IBOutlet UIButton* btnSaveOk;
    IBOutlet UIView* viewDelete;
    IBOutlet UIView* viewRatioAlert;
    IBOutlet UIView* viewZuheAlert;
}

-(IBAction)btnClicked:(UIButton*)btn;
@end
