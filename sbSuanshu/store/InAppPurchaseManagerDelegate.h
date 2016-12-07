//
//  InAppPurchaseManagerDelegate.h
//  Test
//
//  Created by apple on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@protocol InAppPurchaseManagerDelegate <NSObject>

@required
-(void)didReceivedProducts:(NSArray *)products;
-(void)didFailedTransaction:(NSString *)proIdentifier;
-(void)didRestoreTransaction:(NSString *)proIdentifier;
-(void)didFailedRestoreTransaction:(NSError *)error;
@optional
//if you do not need to verify receipt,plz implement this function
-(void)didCompleteTransaction:(NSString *)proIdentifier;
//if you want to verify receipt via iphone or server,plz implement the follow functions
-(void)didCompleteTransactionAndVerifySucceed:(NSString *)proIdentifier;
-(void)didCompleteTransactionAndVerifyFailed:(NSString *)proIdentifier withError:(NSString *)error;
@end