//
//  HTTPRequestHandler.h
//
//  Created by Maulik Desai on 20/11/17.
//  Copyright 2017 Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import "Constants.h"

@protocol HTTPRequestHandlerDelegate;


@interface HTTPRequestHandler : NSOperation
{
@private
	id <HTTPRequestHandlerDelegate> __unsafe_unretained delegate;
	
	NSMutableData *responseData;
	//NSURLConnection *httpConnection;
}

@property (nonatomic, strong) NSURLConnection *httpConnection;
@property (nonatomic, assign) CallTypeEnum myCallBack;
//@property (nonatomic, strong) NSURLConnection *httpConnection;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id <HTTPRequestHandlerDelegate>)theDelegate;
- (id)initWithRequest:(NSURLRequest *)request delegate:(id <HTTPRequestHandlerDelegate>)theDelegate andCallBack:(CallTypeEnum)callBack;

@end

@protocol HTTPRequestHandlerDelegate

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFinishWithData:(NSData *)data andCallBack:(CallTypeEnum)callType;
- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFailedWithError:(NSError *)error andCallBack:(CallTypeEnum)callType;

@end
