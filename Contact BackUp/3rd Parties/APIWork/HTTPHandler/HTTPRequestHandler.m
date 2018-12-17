//
//  HTTPRequestHandler.m
//
//  Created by Maulik Desai on 20/11/17.
//  Copyright 2017 Desai. All rights reserved.
//

#import "HTTPRequestHandler.h"


@interface HTTPRequestHandler()

@property (nonatomic, unsafe_unretained) id <HTTPRequestHandlerDelegate> delegate;
@property (nonatomic, strong) NSMutableData *responseData;
//@property (nonatomic, strong) NSURLConnection *httpConnection;

@end



@implementation HTTPRequestHandler

@synthesize delegate, responseData, httpConnection, myCallBack;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id <HTTPRequestHandlerDelegate>)theDelegate
{
	self = [super init];
	if(self != nil)
	{
		self.delegate = theDelegate;
		self.httpConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
	return self;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id <HTTPRequestHandlerDelegate>)theDelegate andCallBack:(CallTypeEnum)callBack
{
    self = [super init];
    if(self != nil)
    {
        self.delegate = theDelegate;
        self.httpConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.myCallBack = callBack;
    }
    return self;
}


#pragma mark -
#pragma mark NSURLConnection Delegate methods.
#pragma mark -

// -------------------------------------------------------------------------------
//	connection:didReceiveResponse:response
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.responseData = [NSMutableData data];    // start off with new data
}

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.responseData appendData:data];  // append incoming data
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self.delegate requestHandler:self didFailedWithError:error andCallBack:self.myCallBack];
	self.httpConnection = nil;   // release our connection
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	self.httpConnection = nil;   // release our connection
//	[self.delegate requestHandler:self didFinishWithData:self.responseData];
    [self.delegate requestHandler:self didFinishWithData:self.responseData andCallBack:self.myCallBack];
	self.responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
	NSLog([NSString stringWithFormat: @"Bytes written: %ld", bytesWritten], nil);
	NSLog([NSString stringWithFormat: @"Total Bytes written: %ld", totalBytesWritten], nil);
	NSLog([NSString stringWithFormat: @"Expected Bytes To write: %ld", totalBytesExpectedToWrite], nil);
	
	//if (isAuthenticated) {
	//	[self.delegate Uploaded:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
	//}
}

@end
