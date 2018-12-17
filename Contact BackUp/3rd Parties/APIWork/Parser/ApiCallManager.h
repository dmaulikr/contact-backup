//
//  ApiCallManager.h
//
//  Created by Maulik Desai on 20/11/17.
//  Copyright 2017 Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Constants.h"


@protocol ApiCallManagerDelegate

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType;
- (void)parserSuccessDelegateDidFinish:(NSDictionary *)dictResult andCallType:(CallTypeEnum)callType;

@end

@interface ApiCallManager : NSObject <HTTPRequestHandlerDelegate>
{
	id<ApiCallManagerDelegate>_delegate;
	HTTPRequestHandler *requestHandler;
	NSString *functionName;
}

+(ApiCallManager *)sharedApiCallManager;

- (void)callAPIWithDelegate:(id<ApiCallManagerDelegate>)delegate withURL:(NSString *)strURL withData:(NSMutableDictionary *)dict andCallBack:(CallTypeEnum)callBack;

@end
