//
//  InAppPurchaseManager.h
//  sudoku
//
//  Created by mac on 11-9-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECPurchase.h"
#import "InAppPurchaseManagerDelegate.h"

@interface InAppPurchaseManager : NSObject <ECPurchaseProductDelegate,ECPurchaseTransactionDelegate> {
    id<InAppPurchaseManagerDelegate>	_delegate;
}

@property(assign) id<InAppPurchaseManagerDelegate> delegate;

+(InAppPurchaseManager*)singleton;
+(void)initInAppPurchase;
-(void) cancelProductRequest;
-(void)requestProductData:(NSArray *)proIdentifiers;
-(void)addPayment:(SKProduct *)product userID:(NSInteger)userID exchangeID:(NSString *)exChangID;
-(void)setReceiptMode:(NSInteger)mode;
-(void)restore;
@end
