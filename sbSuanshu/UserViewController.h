//
//  UserViewController.h
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-22.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserViewControllerDelegate <NSObject>

@required
-(void)didSelectedUser:(NSDictionary*)user;

@end


@interface UserViewController : UITableViewController

@property id<UserViewControllerDelegate> delegate;

@end


