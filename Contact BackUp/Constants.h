

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

#define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 812 ? 10 : ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 : ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : 999))))

#define URL_GET_MORE_APPS               @"http://itunes.apple.com/WebObjects/MZStoreServices.woa/ws/wsSearch?term=nikunj+surati&entity=software,iPadSoftware&limit=50&version=2&output=json"

#define SUB_CAT_TYPE_PORTRAIT           @"portrait"
#define SUB_CAT_TYPE_LANDSCAPE          @"landscape"

#define ALERT_TITLE_ERROR               @"Oops!"
#define ALERT_TITLE_SUCCESS             @"Success!"


#define APP_ITUNES_LINK                 @"https://itunes.apple.com/us/app/live-ghost-camera/id1253878338?ls=1&mt=8"

#define APP_ITUNES_CUST_REVIEWS            @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=510440204"

#define URL_BASE    @"http://adp.nestcodeinfo.com/api/advDetail"


typedef enum
{
    CALL_TYPE_NONE,
    CALL_TYPE_BASE,
    CALL_TYPE_GET_MORE_APPS
}CallTypeEnum;
