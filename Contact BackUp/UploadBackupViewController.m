//
//  UploadBackupViewController.m
//  Contact BackUp
//
//  Created by nestcode on 8/3/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "UploadBackupViewController.h"
#import "TestAppType.h"
#import "TestClasses.h"
#import "TestData.h"

/// OpenWith data
static DBOpenWithInfo *s_openWithInfoNSURL = nil;


@interface UploadBackupViewController ()

@end

@implementation UploadBackupViewController{
    NSUserDefaults *userFilePath, *userBackupCount;
    NSString *filePath;
    NSURL *ubiquitousURL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userFilePath = [NSUserDefaults standardUserDefaults];
    userBackupCount = [NSUserDefaults standardUserDefaults];
    
    NSString *strCount = [NSString stringWithFormat:@"%ld",[userBackupCount integerForKey:@"userBackupCount"]];
    _lblContactCount.text = strCount;
    
    BOOL authorizedUser = [DBClientsManager authorizedClient].isAuthorized;
    NSLog(@"%s", authorizedUser ? "user client authorized" : "user client not authorized");
    
    BOOL authorizedTeam = [DBClientsManager authorizedTeamClient].isAuthorized;
    NSLog(@"%s", authorizedTeam ? "team client authorized" : "team client not authorized");
}

- (void)setOpenWithInfoNSURL:(DBOpenWithInfo *)openWithInfoNSURL {
    s_openWithInfoNSURL = openWithInfoNSURL;
}


-(void)Mail{

    filePath = [NSString stringWithFormat:@"%@",[userFilePath objectForKey:@"userFilePath"]];
    //Contacts_Vcard.vcf
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Contacts_Vcard.vcf"];
   // NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSData *vcfData = [NSData dataWithContentsOfFile:filePath];
    
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Am not able send any mails. :( ");
        return;
    }
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"My Contacts Backup through Contact Backup App"];
    [controller setMessageBody:@"Got my vcf file here." isHTML:NO];
    [controller addAttachmentData:vcfData mimeType:@"text/x-vcard" fileName:@"MyContacts.vcf"];
    //    [self presentModalViewController:controller animated:YES];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onMailClicked:(id)sender {
     [self Mail];
}

- (NSString *)generateFileNameWithExtension:(NSString *)extensionString {
    NSDate *time = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh.mm"];
    NSString *timeString = [dateFormatter stringFromDate:time];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", timeString, extensionString];
    return fileName;
}

- (IBAction)oniCloudClicked:(id)sender {
    filePath = [NSString stringWithFormat:@"%@",[userFilePath objectForKey:@"userFilePath"]];
    NSURL *urlFilePath = [NSURL fileURLWithPath:[filePath stringByAppendingPathComponent:@"Contacts_Vcard.vcf"]];
    NSString *newFileName = [self generateFileNameWithExtension:@"vcf"];
    [self iCloudeUplodFile:urlFilePath destFileNameStr:newFileName];
}

- (void)iCloudeUplodFile:(NSURL *)sourchPath destFileNameStr:(NSString *)fileName
{
    ubiquitousURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSURL *destinationURL = [ubiquitousURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:sourchPath toURL:destinationURL error:&error];
    if (success){
        _btniCloud.userInteractionEnabled = NO;
        _imgCloud.image = [UIImage imageNamed:@"icloud-Done.png"];
        _lblCloud.textColor = [UIColor grayColor];
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageColor = [UIColor whiteColor];
        style.backgroundColor = [UIColor greenColor];
        style.messageAlignment = NSTextAlignmentCenter;
        
        [self.view makeToast:@"Backup Uploaded Sucessfully To iCloud"
                    duration:3.0
                    position:CSToastPositionBottom
                       style:style];
        
        [CSToastManager setSharedStyle:style];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:YES];
        NSLog(@"%@ copied to icloud",fileName);
    }
    else{
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageColor = [UIColor whiteColor];
        style.backgroundColor = [UIColor redColor];
        style.messageAlignment = NSTextAlignmentCenter;
        
        [self.view makeToast:@"Error While Saving Data To iCloud"
                    duration:3.0
                    position:CSToastPositionBottom
                       style:style];
        
        [CSToastManager setSharedStyle:style];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:YES];
    }
    
}

- (IBAction)onDriveClicked:(id)sender {
    GIDGoogleUser *currentUser = [GIDSignIn sharedInstance].currentUser;
    NSLog(@"user = %@", currentUser);
    if (!currentUser) {
        GIDSignIn* signIn = [GIDSignIn sharedInstance];
        signIn.delegate = self;
        signIn.uiDelegate = self;
        signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeDrive, nil];
        [signIn signInSilently];
        
        self.driveService = [[GTLRDriveService alloc] init];
        [self showSignIn];
    }
    else
    {
        [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
        [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0 green:104.0f/255.0f blue:140.0f/255.0f alpha:1.0]];
        [SVProgressHUD show];
        self.view.userInteractionEnabled = NO;
        
        GTLRUploadParameters *uploadParameters = nil;
       // NSData *fileContent = imageData;
        filePath = [NSString stringWithFormat:@"%@",[userFilePath objectForKey:@"userFilePath"]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *strfilePath = [documentsDirectory stringByAppendingPathComponent:@"Contacts_Vcard.vcf"];
        NSData *vcfData = [NSData dataWithContentsOfFile:strfilePath];
        NSString *newFileName = [self generateFileNameWithExtension:@"vcf"];
        NSString *savePath = [NSString stringWithFormat:@"/Contact Backup/%@",newFileName];
        
        uploadParameters = [GTLRUploadParameters uploadParametersWithData:vcfData MIMEType:@"text/x-vcard"];
        
        GTLRDrive_File *metadata = [[GTLRDrive_File alloc] init];
        metadata.name = newFileName;
        
        GTLRDriveQuery *query = nil;
        if (self.driveFile.identifier == nil || self.driveFile.identifier.length == 0) {
            // This is a new file, instantiate an insert query.
            query = [GTLRDriveQuery_FilesCreate queryWithObject:metadata
                                               uploadParameters:uploadParameters];
        } else {
            // This file already exists, instantiate an update query.
            query = [GTLRDriveQuery_FilesUpdate queryWithObject:metadata
                                                         fileId:self.driveFile.identifier
                                               uploadParameters:uploadParameters];
        }
        query.fields = @"id,name,modifiedTime,mimeType";
      
        [self.driveService executeQuery:query
                      completionHandler:^(GTLRServiceTicket *ticket,
                                          GTLRDrive_File *updatedFile,
                                          NSError *error) {
                          if (error == nil) {
                              [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
                              [SVProgressHUD setForegroundColor:[UIColor greenColor]];
                              [SVProgressHUD showSuccessWithStatus:@"Backup Uploaded To Google Drive Successfully"];
                              _imgDrive.image = [UIImage imageNamed:@"Drive-Done.png"];
                              _lblDrive.textColor = [UIColor grayColor];
                              self.view.userInteractionEnabled = YES;
                              _btnDrive.userInteractionEnabled = NO;
                              self.driveFile = updatedFile;
                              
                          } else {
                              [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
                              [SVProgressHUD setForegroundColor:[UIColor redColor]];
                              [SVProgressHUD showErrorWithStatus:@"Error While Saving Data To Google Drive"];
                              self.view.userInteractionEnabled = YES;
                              NSLog(@"Error: %@", error);
                              NSDictionary *errorInfo = [error userInfo];
                              NSData *errData = errorInfo[kGTMSessionFetcherStatusDataKey];
                              if (errData) {
                                  NSString *dataStr = [[NSString alloc] initWithData:errData
                                                                            encoding:NSUTF8StringEncoding];
                              }
                          }
                      }];
    }
}
- (void)showSignIn {
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    GIDGoogleUser *currentUser = [GIDSignIn sharedInstance].currentUser;
    NSLog(@"user = %@", currentUser);
    
    if (currentUser) {
        self.driveService.authorizer = currentUser.authentication.fetcherAuthorizer;
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    NSLog(@"User signed-out");
}
- (UIImage *)resize:(UIImage *)image to:(CGFloat)width {
    CGFloat scale = width / image.size.width;
    CGFloat height = image.size.height * scale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), false, 0);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (IBAction)onDropBoxClicked:(id)sender {
    if ([DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient]) {
        
        filePath = [NSString stringWithFormat:@"%@",[userFilePath objectForKey:@"userFilePath"]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *strfilePath = [documentsDirectory stringByAppendingPathComponent:@"Contacts_Vcard.vcf"];
        NSData *vcfData = [NSData dataWithContentsOfFile:strfilePath];
        NSString *newFileName = [self generateFileNameWithExtension:@"vcf"];
        NSString *savePath = [NSString stringWithFormat:@"/Contact Backup/%@",newFileName];
        
        [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
        [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0 green:104.0f/255.0f blue:140.0f/255.0f alpha:1.0]];
        [SVProgressHUD show];
        self.view.userInteractionEnabled = NO;
        
        // For overriding on upload
        DBFILESWriteMode *mode = [[DBFILESWriteMode alloc] initWithOverwrite];
        DBUserClient *client = [DBClientsManager authorizedClient];
        [[[client.filesRoutes uploadData:savePath
                                    mode:mode
                              autorename:@(YES)
                          clientModified:nil
                                    mute:@(NO)
                          propertyGroups:nil
                               inputData:vcfData]
          setResponseBlock:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *networkError) {
              if (result) {
                  [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
                  [SVProgressHUD setForegroundColor:[UIColor greenColor]];
                  [SVProgressHUD showSuccessWithStatus:@"Backup Uploaded To DropBox Successfully"];
                  self.view.userInteractionEnabled = YES;
                  _btnDropBox.userInteractionEnabled = NO;
                  _imgDropBox.image = [UIImage imageNamed:@"Drop-Done"];
                  _lblDropBox.textColor = [UIColor grayColor];
                  NSLog(@"Done: %@\n", result);
              } else {
                  [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
                  [SVProgressHUD setForegroundColor:[UIColor redColor]];
                  [SVProgressHUD showErrorWithStatus:@"Error While Saving Data To Dropbox"];
                  self.view.userInteractionEnabled = YES;
                  NSLog(@"%@\n%@\n", routeError, networkError);
              }
          }] setProgressBlock:^(int64_t bytesUploaded, int64_t totalBytesUploaded, int64_t totalBytesExpectedToUploaded) {
              NSLog(@"\n%lld\n%lld\n%lld\n", bytesUploaded, totalBytesUploaded, totalBytesExpectedToUploaded);
          }];
    }
    else{
        [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                       controller:self
                                          openURL:^(NSURL *url) {
                                              [[UIApplication sharedApplication] openURL:url];
                                          }];
    }
}

-(void)initDropBoxService{
    
    filePath = [NSString stringWithFormat:@"%@",[userFilePath objectForKey:@"userFilePath"]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Contacts_Vcard.vcf"];
    NSData *vcfData = [NSData dataWithContentsOfFile:filePath];
    
    NSString *newFileName = [self generateFileNameWithExtension:@"vcf"];
    
    NSInputStream *inputPath = [NSInputStream inputStreamWithData:vcfData];
    NSString *strPAth = [NSString stringWithFormat:@"/%@",newFileName];
    
  
}

-(void)getDropBoxFiles{
    filePath = [NSString stringWithFormat:@"%@",[userFilePath objectForKey:@"userFilePath"]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Contacts_Vcard.vcf"];
    NSData *vcfData = [NSData dataWithContentsOfFile:filePath];
    
    NSString *newFileName = [self generateFileNameWithExtension:@"vcf"];
    
    NSInputStream *inputPath = [NSInputStream inputStreamWithData:vcfData];
    NSString *strPAth = [NSString stringWithFormat:@"/%@",newFileName];
    
    [_service uploadFileToPath:@"/" withStream:inputPath size:[NSNumber numberWithInt:1024] overwrite:true];

}



@end
