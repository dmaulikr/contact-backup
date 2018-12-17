//
//  ViewController.m
//  Contact BackUp
//
//  Created by nestcode on 7/25/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSInteger m;
    NSUserDefaults *Visited1;
    NSUserDefaults *isBanner, *isFullScreen, *Interval, *bannerID, *FullID;
    NSString *strBanner, *strFull;
    NSUserDefaults *AdvertData;
    NSUserDefaults *userScreen;
    MFMailComposeViewController *mailCont;
    NSString *osVersion ,*deviceName ,*appVersion;
}
@synthesize BannerView = BannerView_;
@synthesize interstitial = InterstitialView_;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    AdvertData = [NSUserDefaults standardUserDefaults];
    [self APIAdData];
    
    isBanner = [NSUserDefaults standardUserDefaults];
    isFullScreen = [NSUserDefaults standardUserDefaults];
    Interval = [NSUserDefaults standardUserDefaults];
    bannerID = [NSUserDefaults standardUserDefaults];
    FullID = [NSUserDefaults standardUserDefaults];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.BannerView.delegate = self;
    
    _viewMail.layer.cornerRadius = 5.0f;
    _viewMail.layer.borderWidth = 0.5f;
    _viewMail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _ViewRate.layer.cornerRadius = 5.0f;
    _ViewRate.layer.borderWidth = 0.5f;
    _ViewRate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _viewShare.layer.cornerRadius = 5.0f;
    _viewShare.layer.borderWidth = 0.5f;
    _viewShare.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _viewMore.layer.cornerRadius = 5.0f;
    _viewMore.layer.borderWidth = 0.5f;
    _viewMore.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _viewBackUp.layer.cornerRadius = 5.0f;
    _viewBackUp.layer.borderWidth = 0.5f;
    _viewBackUp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _viewContacts.layer.cornerRadius = 5.0f;
    _viewContacts.layer.borderWidth = 0.5f;
    _viewContacts.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    if (IS_IPHONE_6P) {
        _bottomStackView.spacing = 20;
        _ConstDistance.constant = 70;
    }
    else if (IS_IPHONE_6) {
        _bottomStackView.spacing = 15;
        _ConstDistance.constant = 70;
    }
    else if (IS_IPHONE_X) {
        _bottomStackView.spacing = 18;
        _ConstDistance.constant = 70;
    }
    else{
        _bottomStackView.spacing = 5;
        _ConstDistance.constant = 50;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    strBanner = [bannerID valueForKey:@"bannerID"];
    strFull = [FullID valueForKey:@"FullID"];
    
    NSInteger isBannerActive = [isBanner integerForKey:@"isBanner"];
    if (isBannerActive == 1) {
        [self createAdBannerView];
    }
    
    NSInteger intervalFull = [Interval integerForKey:@"Interval"];
    Visited1 = [NSUserDefaults standardUserDefaults];
    NSInteger fav = [Visited1 integerForKey:@"MainVisited"];
    if (intervalFull == 0) {
        intervalFull = 3;
    }
    m = fav % intervalFull;
    if (m == 0) {
        NSInteger isFullActive = [isFullScreen integerForKey:@"isFullScreen"];
        if (isFullActive == 1) {
            [self createAndLoadInterstitial];
        }
    }
    m++;
    [Visited1 setInteger:m forKey:@"MainVisited"];
    [Visited1 synchronize];
}

- (void) createAdBannerView
{
    NSLog(@"%s",__FUNCTION__);
    if (self.BannerView == nil)
    {
        self.BannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
        [self.adView addSubview:self.BannerView];
        self.BannerView.rootViewController = self;
        BannerView_.adUnitID = strBanner;
        [self.BannerView loadRequest:[GADRequest request]];
    }
    if (![self.adView.subviews containsObject:self.BannerView])
        [self.adView addSubview:self.BannerView];
}

- (GADInterstitial *)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:strFull];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[DFPRequest request]];
    return self.interstitial;
}

- (void)interstitialDidReceiveAd:(DFPInterstitial *)ad {
    NSLog(@"Interstitial Ad Received");
    [InterstitialView_ presentFromRootViewController:self];
}

-(GADRequest *)createRequest{
    GADRequest *request = [GADRequest request];
    // request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    return request;
}

- (IBAction)onMailUsClicked:(id)sender {
    osVersion = [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion] ];
    deviceName = [self deviceModelName];
    appVersion = [NSString stringWithFormat:@"App Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    if([MFMailComposeViewController canSendMail]) {
        mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        [mailCont setSubject:@"Feedback"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"http://www.nestcodeinfo.com/"]];
        [mailCont setMessageBody:[NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n%@\n%@\n%@",osVersion,deviceName,appVersion] isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:NULL];
    }
    else{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Aleart"
                                     message:@"No Mail Account has been set!! Please set Mail Account first in order to send Support Mail"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)onShareClicked:(id)sender {
    NSString *str = @"https://itunes.apple.com/us/app/cryptocurrency-coinmarketcap/id1376008786?ls=1&mt=8";
    NSArray * shareItems = @[str];
    NSLog(@"%@",shareItems);
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    avc.excludedActivityTypes = nil;
    [self presentViewController:avc animated:YES completion:nil];
}

- (IBAction)onRateUsClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/app/cryptocurrency-coinmarketcap/id1376008786?ls=1&mt=8"]];
}

- (IBAction)onMoreAppsClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/developer/nestcode-infotech-private-limited/id1376008785"]];
}

-(void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Ad Received");
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad due to: %@", [error localizedFailureReason]);
}

-(void)APIAdData{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        
    }
    else
    {
        NSDictionary *tmp = [[NSDictionary alloc]initWithObjectsAndKeys:
                             @"iOS",@"type",
                             @"com.nex.meditation",@"build_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        self.view.userInteractionEnabled = NO;
        
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",URL_BASE];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_BASE];
    }
}

#pragma mark - API HANDLER

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    
}

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFailedWithError:(NSError *)error andCallBack:(CallTypeEnum)callType
{
    
}

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFinishWithData:(NSData *)data andCallBack:(CallTypeEnum)callType
{
    self.view.userInteractionEnabled = YES;
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    
    if ([[jsonRes valueForKey:@"message"] isEqualToString:@"Unauthenticated."]) {
    }
    else  {
        [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_BASE];
        NSLog(@"%@",jsonRes);
        
        if ([[jsonRes valueForKey:@"status"]  isEqualToString:@"error"]) {
        }
        else{
            NSDictionary *dictTemp = [[NSDictionary alloc]init];
            dictTemp = [jsonRes valueForKey:@"data"];
            NSDictionary *dictAdvrt = [[NSDictionary alloc]init];
            NSMutableArray *arrPersonalAdvrt = [[NSMutableArray alloc]init];
            dictAdvrt = [dictTemp valueForKey:@"advertisement_detail"];
            arrPersonalAdvrt = [dictTemp valueForKey:@"personal_ads"];
            
            if ([[dictAdvrt valueForKey:@"rewarded_id"] isKindOfClass:[NSNull class]]) {
                [dictAdvrt setValue:@"N/A" forKey:@"rewarded_id"];
            }
            [AdvertData setObject:dictAdvrt forKey:@"AdvertData"];
            [AdvertData synchronize];
            
            NSUserDefaults *googleAdID = [NSUserDefaults standardUserDefaults];
            [googleAdID setValue:[dictAdvrt valueForKey:@"google_app_id"] forKey:@"googleAdID"];
            [googleAdID synchronize];
            
            NSString *strIsBanner = [NSString stringWithFormat:@"%@",[[dictAdvrt objectForKey:@"display_type"]valueForKey:@"Banner"]];
            NSString *strIsFull = [NSString stringWithFormat:@"%@",[[dictAdvrt objectForKey:@"display_type"]valueForKey:@"Fullscreen"]];
            NSString *strInterval = [NSString stringWithFormat:@"%@",[dictAdvrt valueForKey:@"fullscreen_showtime"]];
            NSString *strBanner = [NSString stringWithFormat:@"%@",[dictAdvrt valueForKey:@"banner_id"]];
            NSString *strFull = [NSString stringWithFormat:@"%@",[dictAdvrt valueForKey:@"fullscreen_id"]];
            
            [isBanner setInteger:[strIsBanner integerValue] forKey:@"isBanner"];
            [isFullScreen setInteger:[strIsFull integerValue] forKey:@"isFullScreen"];
            [Interval setInteger:[strInterval integerValue] forKey:@"Interval"];
            [bannerID setValue:strBanner forKey:@"bannerID"];
            [FullID setValue:strFull forKey:@"FullID"];
            [isBanner synchronize];
            [isFullScreen synchronize];
            [Interval synchronize];
            [bannerID synchronize];
            [FullID synchronize];
            
            NSDictionary *dictVersion = [dictTemp valueForKey:@"version_detail"];
            NSString *strUpdate = [dictVersion valueForKey:@"app_force_update"];
            NSString *strUpdateVersion = [dictVersion valueForKey:@"app_version"];
            NSString *strUpdateLog = [dictVersion valueForKey:@"change_log"];
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *AppLink = [NSString stringWithFormat:@"%@",[dictTemp valueForKey:@"app_link"]];
            
            if ([strUpdateVersion compare:version options:NSNumericSearch] == NSOrderedDescending) {
                if ([strUpdate isEqualToString:@"No"]) {
                    SCLAlertView *alert = [[SCLAlertView alloc] init];
                    [alert addButton:@"OK" actionBlock:^(void) {
                    }];
                    [alert showWarning:self.parentViewController title:@"Update Alert!!" subTitle:strUpdateLog closeButtonTitle:nil duration:0.0f];
                }
                else{
                    SCLAlertView *alert = [[SCLAlertView alloc] init];
                    [alert addButton:@"OK" actionBlock:^(void) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: AppLink]];
                    }];
                    [alert showWarning:self.parentViewController title:@"Update Alert!!" subTitle:strUpdateLog closeButtonTitle:nil duration:0.0f];
                }
            }
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString*)deviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //MARK: More official list is at
    //http://theiphonewiki.com/wiki/Models
    //MARK: You may just return machineName. Following is for convenience
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"i386 Simulator",
      @"x86_64":   @"x86_64 Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      
      @"iPhone7,1":    @"iPhone 6+(GSM+CDMA)",
      @"iPhone7,2":    @"iPhone 6(GSM+CDMA)",
      
      @"iPhone8,1":    @"iPhone 6S(GSM+CDMA)",
      @"iPhone8,2":    @"iPhone 6S+(GSM+CDMA)",
      @"iPhone8,4":    @"iPhone SE(GSM+CDMA)",
      @"iPhone9,1":    @"iPhone 7(GSM+CDMA)",
      @"iPhone9,2":    @"iPhone 7+(GSM+CDMA)",
      @"iPhone9,3":    @"iPhone 7(GSM+CDMA)",
      @"iPhone9,4":    @"iPhone 7+(GSM+CDMA)",
      
      @"iPhone10,1":    @"iPhone 8",
      @"iPhone10,2":    @"iPhone 8+",
      @"iPhone10,3":    @"iPhone X",
      @"iPhone10,4":    @"iPhone 8",
      @"iPhone10,5":    @"iPhone 8+",
      @"iPhone10,6":    @"iPhone X",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini 1G (WiFi)",
      @"iPad2,6":  @"iPad Mini 1G (GSM)",
      @"iPad2,7":  @"iPad Mini 1G (GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPad4,1":  @"iPad Air(WiFi)",
      @"iPad4,2":  @"iPad Air(GSM)",
      @"iPad4,3":  @"iPad Air(GSM+CDMA)",
      
      @"iPad5,3":  @"iPad Air 2 (WiFi)",
      @"iPad5,4":  @"iPad Air 2 (GSM+CDMA)",
      
      @"iPad4,4":  @"iPad Mini 2G (WiFi)",
      @"iPad4,5":  @"iPad Mini 2G (GSM)",
      @"iPad4,6":  @"iPad Mini 2G (GSM+CDMA)",
      
      @"iPad4,7":  @"iPad Mini 3G (WiFi)",
      @"iPad4,8":  @"iPad Mini 3G (GSM)",
      @"iPad4,9":  @"iPad Mini 3G (GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      @"iPod7,1":  @"iPod 6th Gen",
      };
    
    deviceName = commonNamesDictionary[machineName];
    if (deviceName == nil) {
        deviceName = machineName;
    }
    return deviceName;
}


@end
