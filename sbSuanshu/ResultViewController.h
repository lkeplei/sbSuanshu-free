//
//  ResultViewController.h
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController
{
    IBOutlet UIButton *btnUser;

    IBOutlet UIView *viewChart;

}

@property (weak, nonatomic) IBOutlet UIView *viewHistoryContainer;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewBg;
@property (weak, nonatomic) IBOutlet UIButton *btnHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnTongji;

@end
