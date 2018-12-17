//
//  ViewController.h
//  Contact BackUp
//
//  Created by nestcode on 7/25/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "ApiCallManager.h"
#import "SCLAlertView.h"
#import "Constants.h"

#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import <GoogleMobileAds/GADInterstitial.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <sys/utsname.h>

@interface ViewController : UIViewController<GADBannerViewDelegate,GADInterstitialDelegate,ApiCallManagerDelegate,HTTPRequestHandlerDelegate,MFMailComposeViewControllerDelegate>
{
    GADBannerView *BannerView_;
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
    
}

@property (weak, nonatomic) IBOutlet UIView *viewBackUp;
@property (weak, nonatomic) IBOutlet UIView *viewContacts;
@property (weak, nonatomic) IBOutlet UIView *viewMail;
@property (weak, nonatomic) IBOutlet UIView *viewShare;
@property (weak, nonatomic) IBOutlet UIView *ViewRate;
@property (weak, nonatomic) IBOutlet UIView *viewMore;

@property (weak, nonatomic) IBOutlet UIStackView *bottomStackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstDistance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstView1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstView1Height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstView2Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstView2Height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstViewMailWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstViewMailHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstViewShareWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstViewShareHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstViewRateWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstViewRateHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstViewMoreWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConstViewMoreHeight;



@property (weak, nonatomic) IBOutlet UIView *adView;
@property(nonatomic,strong) GADBannerView *BannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;
-(GADRequest *)createRequest;


- (IBAction)onMailUsClicked:(id)sender;
- (IBAction)onShareClicked:(id)sender;
- (IBAction)onRateUsClicked:(id)sender;
- (IBAction)onMoreAppsClicked:(id)sender;


@end

