//
//  ResultTableCell.h
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-15.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTixing;
@property (weak, nonatomic) IBOutlet UILabel *labelTishu;
@property (weak, nonatomic) IBOutlet UILabel *labelYongshi;
@property (weak, nonatomic) IBOutlet UILabel *labelDefen;
@property (weak, nonatomic) IBOutlet UILabel *labelZonghe;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewStar1;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewStar2;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewStar3;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewStar4;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewStar5;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewStar6;
@end
