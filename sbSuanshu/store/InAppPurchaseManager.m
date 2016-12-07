//
//  InAppPurchaseManager.m
//  sudoku
//
//  Created by mac on 11-9-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager

@synthesize delegate = _delegate;

static InAppPurchaseManager *_instance = nil;

+(InAppPurchaseManager*)singleton
{
    if (_instance==nil) {
        _instance=[[self alloc] init];
    }
    return _instance;
}

-(id)init
{
    if ((self=[super init])) {
        [[ECPurchase shared] setProductDelegate:self];
        [[ECPurchase shared] setTransactionDelegate:self];
        [[ECPurchase shared] setVerifyRecepitMode:ECVerifyRecepitModeiPhone];
    }
    return self;
}

-(void)dealloc
{
    _instance=nil;
    [super dealloc];
}

+(void)initInAppPurchase
{
    [[ECPurchase shared] addTransactionObserver];
}

-(void)requestProductData:(NSArray *)proIdentifiers
{
    [[ECPurchase shared] requestProductData:proIdentifiers];  
}

-(void) cancelProductRequest
{
    [[ECPurchase shared] cancelProductRequest]; 
}

-(void)addPayment:(SKProduct *)product userID:(NSInteger)userID exchangeID:(NSString *)exChangID
{
    [[ECPurchase shared] addPayment:product userID:userID exchangeID:exChangID]; 
}

-(void)setReceiptMode:(NSInteger)mode
{
    [[ECPurchase shared] setVerifyRecepitMode:mode];
}

-(void)restore
{
    [[ECPurchase shared] restore];
}

-(void)didReceivedProducts:(NSArray *)products
{
    NSAssert(_delegate,@"[store]:didReceivedProducts-> _delegate is null.");
    if([_delegate respondsToSelector:@selector(didReceivedProducts:)])
        [_delegate didReceivedProducts:products];
}
-(void)didFailedTransaction:(NSString *)proIdentifier
{
    //CCLOG(@"failed %@",proIdentifier);
    NSAssert(_delegate,@"[store]:didFailedTransaction-> _delegate is null.");
    if([_delegate respondsToSelector:@selector(didFailedTransaction:)])
        [_delegate didFailedTransaction:proIdentifier];
}
-(void)didRestoreTransaction:(NSString *)proIdentifier
{
    //CCLOG(@"restore %@",proIdentifier);
    NSAssert(_delegate,@"[store]:didRestoreTransaction-> _delegate is null.");
    if([_delegate respondsToSelector:@selector(didRestoreTransaction:)])
        [_delegate didRestoreTransaction:proIdentifier];
}
-(void)didCompleteTransaction:(NSString *)proIdentifier
{
    //CCLOG(@"complete %@",proIdentifier);
    NSAssert(_delegate,@"[store]:didCompleteTransaction-> _delegate is null.");
    if([_delegate respondsToSelector:@selector(didCompleteTransaction:)])
        [_delegate didCompleteTransaction:proIdentifier];
}
-(void)didCompleteTransactionAndVerifySucceed:(NSString *)proIdentifier
{
    //CCLOG(@"verify success %@",proIdentifier);
    NSAssert(_delegate,@"[store]:didCompleteTransactionAndVerifySucceed-> _delegate is null.");
    if([_delegate respondsToSelector:@selector(didCompleteTransactionAndVerifySucceed:)])
        [_delegate didCompleteTransactionAndVerifySucceed:proIdentifier];
}
-(void)didCompleteTransactionAndVerifyFailed:(NSString *)proIdentifier withError:(NSString *)error
{
    //CCLOG(@"verify failed %@",proIdentifier);
    NSAssert(_delegate,@"[store]:didCompleteTransactionAndVerifyFailed-> _delegate is null.");
    if([_delegate respondsToSelector:@selector(didCompleteTransactionAndVerifyFailed:withError:)])
        [_delegate didCompleteTransactionAndVerifyFailed:proIdentifier withError:error];
}

-(void)didFailedRestoreTransaction:(NSError *)error
{
    //CCLOG(@"complete %@",proIdentifier);
    NSAssert(_delegate,@"[store]:didFailedRestoreTransaction-> _delegate is null.");
    if([_delegate respondsToSelector:@selector(didFailedRestoreTransaction:)])
        [_delegate didFailedRestoreTransaction:error];
}

@end
