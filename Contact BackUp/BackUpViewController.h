//
//  BackUpViewController.h
//  Contact BackUp
//
//  Created by nestcode on 7/28/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SARAddressBookBackup.h"
#import <Contacts/Contacts.h>
#import "SVProgressHUD.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CloudKit/CloudKit.h>

@interface BackUpViewController : UIViewController<UIDocumentPickerDelegate>{
    SARAddressBookBackup *addressBook;
}

@property (weak, nonatomic) IBOutlet UILabel *lblContactCount;


@property (weak, nonatomic) IBOutlet UIView *viewUpload;
@property (weak, nonatomic) IBOutlet UIView *viewContacts;
@property (weak, nonatomic) IBOutlet UIView *viewCreateBackup;
@property (weak, nonatomic) IBOutlet UIView *viewDownloadBackUp;

@property (weak, nonatomic) IBOutlet UIButton *btnCreateBackups;
- (IBAction)onCreateBackupClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDownloadBackup;
- (IBAction)onDownloadBackupClicked:(id)sender;

@end
