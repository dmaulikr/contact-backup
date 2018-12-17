//
//  UploadBackupViewController.h
//  Contact BackUp
//
//  Created by nestcode on 8/3/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CloudKit/CloudKit.h>
#import "iCloud.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIView+Toast.h"
#import <CloudrailSI/CloudrailSI.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "SVProgressHUD.h"
#import <GoogleAPIClientForREST/GTLRService.h>
#import <Google/SignIn.h>
#import <GoogleAPIClientForREST/GTLRDrive.h>

@class DBOpenWithInfo;

@interface UploadBackupViewController : UIViewController<MFMailComposeViewControllerDelegate,UIDocumentPickerDelegate,GIDSignInDelegate, GIDSignInUIDelegate>

@property GTLRDriveService *driveService;
@property GTLRDrive_File *driveFile;

- (void)setOpenWithInfoNSURL:(DBOpenWithInfo * _Nonnull)openWithInfoNSURL;

@property (nonatomic,strong) NSString* serviceName;
@property (nonatomic,strong) id<CRCloudStorageProtocol> service;
@property (nonatomic,strong) NSString* currentPath;
@property (nonatomic,strong) NSMutableArray<CRCloudMetaData*>* files;


@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *lblContactCount;


@property (weak, nonatomic) IBOutlet UIView *viewMail;
@property (weak, nonatomic) IBOutlet UIView *viewiCloud;
@property (weak, nonatomic) IBOutlet UIView *viewDrive;
@property (weak, nonatomic) IBOutlet UIView *viewDropbox;


- (IBAction)onMailClicked:(id)sender;
- (IBAction)oniCloudClicked:(id)sender;
- (IBAction)onDriveClicked:(id)sender;
- (IBAction)onDropBoxClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btniCloud;
@property (weak, nonatomic) IBOutlet UIButton *btnDropBox;
@property (weak, nonatomic) IBOutlet UIButton *btnDrive;

@property (weak, nonatomic) IBOutlet UIImageView *imgCloud;
@property (weak, nonatomic) IBOutlet UIImageView *imgDrive;
@property (weak, nonatomic) IBOutlet UIImageView *imgDropBox;


@property (weak, nonatomic) IBOutlet UILabel *lblCloud;
@property (weak, nonatomic) IBOutlet UILabel *lblDropBox;
@property (weak, nonatomic) IBOutlet UILabel *lblDrive;



@end
