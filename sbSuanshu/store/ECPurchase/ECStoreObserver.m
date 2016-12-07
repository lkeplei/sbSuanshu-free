//
//  ECStoreObserver.m
//  myPurchase
//
//  Created by ris on 10-4-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ECStoreObserver.h" 


@implementation ECStoreObserver
@synthesize completeTrans = _completeTrans;
@synthesize failedTrans = _failedTrans;
@synthesize restoreTrans = _restoreTrans;
-(id)init
{
	if ((self = [super init])) {
		_completeTrans = [[NSMutableArray alloc] init];
		_failedTrans = [[NSMutableArray alloc] init];
		_restoreTrans = [[NSMutableArray alloc] init];
	}
	return self;
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction {
#ifdef ECPURCHASE_TEST_MODE
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iap" message:@"Purchase Successful, provide content"
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
#endif
	// Your application should implement these two methods.
    [self recordTransaction: transaction withStatus:0];
    [self provideContent: transaction.payment.productIdentifier];
	//post a notification to ECPurchase
	NSDictionary *userInfoDictionary =[NSDictionary dictionaryWithObjectsAndKeys:
									   transaction,@"transaction",nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"completeTransaction" object:self userInfo:userInfoDictionary];
	// Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction {
#ifdef ECPURCHASE_TEST_MODE
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iap" message:@"Restore Transaction"
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
#endif
    [self recordTransaction: transaction withStatus:1];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    //NSLog(transaction.originalTransaction.payment.productIdentifier);
    //NSLog(transaction.payment.productIdentifier);
	//NSDictionary *userInfoDictionary =[NSDictionary dictionaryWithObjectsAndKeys:transaction,@"transaction",nil];
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"restoreTransaction" object:self userInfo:userInfoDictionary];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction {
#ifdef ECPURCHASE_TEST_MODE
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iap" message:@"failed Transaction"
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
#endif
	[self recordTransaction:transaction withStatus:2];
    NSDictionary *userInfoDictionary =[NSDictionary dictionaryWithObjectsAndKeys:
                                       transaction,@"transaction",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"failedTransaction" object:self userInfo:userInfoDictionary];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction withStatus:(int)status
{
	if (status == 0) 
		[_completeTrans addObject:transaction];
	else if (status == 1)
		[_restoreTrans addObject:transaction];
	else if (status == 2)
		[_failedTrans addObject:transaction];

}

- (void)provideContent:(NSString *)productIdentifier
{
	
}

//for restore.
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishRestoreTransaction" object:self userInfo:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSDictionary *userInfoDictionary =[NSDictionary dictionaryWithObjectsAndKeys:
									   error,@"error",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"failedRestoreTransaction" object:self userInfo:userInfoDictionary];
}

-(void)dealloc
{
	RELEASE_SAFELY(_completeTrans);
	RELEASE_SAFELY(_failedTrans);
	RELEASE_SAFELY(_restoreTrans);
	[super dealloc];
}

@end

