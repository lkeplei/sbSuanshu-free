//
//  2NumItemView.h
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-16.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoNumItemView : UIView

//@property(readonly) UILabel* lResult;
@property (weak, nonatomic) IBOutlet UILabel *labelResult;
@property (weak, nonatomic) IBOutlet UILabel *labelNo;
@property (weak, nonatomic) IBOutlet UILabel *labelQuestion;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCorret;

+ (TwoNumItemView*)create;

@end
