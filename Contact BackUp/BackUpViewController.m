//
//  BackUpViewController.m
//  Contact BackUp
//
//  Created by nestcode on 7/28/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "BackUpViewController.h"

@interface BackUpViewController ()

@end

@implementation BackUpViewController{
    NSMutableArray *contactsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _btnCreateBackups.layer.borderColor = [UIColor colorWithRed:0 green:104.0f/255.0f blue:140.0f/255.0f alpha:1.0].CGColor;
    _btnCreateBackups.layer.borderWidth = 1.0f;
    _btnCreateBackups.layer.cornerRadius = 5.0f;

    
    _viewContacts.hidden = YES;
    _viewUpload.hidden = YES;
    
}

-(void)CreateBackup{
    contactsArray = [[NSMutableArray alloc]init];
    addressBook = [[SARAddressBookBackup alloc]init];
    addressBook.backupPath = [self applicationDocumentsDirectory];//(Optional). If not given, then the backup file is stored under the Documents directory.
    __weak SARAddressBookBackup *addressBook_weak = addressBook;
    __weak BackUpViewController *self_weak = self;
    
    
    addressBook.backupCompletionStatusBlock = ^(NSString *status){
        if ( status == ACCESSDENIED) {
            NSLog(@"ACCESSDENIED : %@",ACCESSDENIED);
        }
        else if ( status == BACKUPFAILED) {
            NSLog(@"BACKUPFAILED : %@",BACKUPFAILED);
        }
        else if ( status == BACKUPSUCCESS) {
            NSLog(@"BACKUPSUCCESS : %@",BACKUPSUCCESS);
            NSLog(@"addressBook.backupPath : %@",addressBook_weak.backupPath);
            
            //            [self_weak emailBackup:addressBook_weak.backupPath];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self_weak selector:@selector(Update:) userInfo:addressBook_weak.backupPath repeats:NO];
        }
    };
    [addressBook backupContacts];
}

- (IBAction)onCreateBackupClicked:(id)sender {
    [self.view setUserInteractionEnabled:NO];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0 green:104.0f/255.0f blue:140.0f/255.0f alpha:1.0]];
    [SVProgressHUD show];
    
    [self performSelector:@selector(CreateBackup) withObject:nil afterDelay:5.0];
}

-(void)Update:(id)timer {
   
    [self contactsFromAddressBook];
    NSTimer *timer_local = (NSTimer*)timer;
    NSString *filePath = (NSString*)[timer_local userInfo];
    
    NSUserDefaults *userFilePath = [NSUserDefaults standardUserDefaults];
    [userFilePath setObject:filePath forKey:@"userFilePath"];
    [userFilePath synchronize];
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(void)contactsFromAddressBook{
    //ios 9+
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
                [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
                [SVProgressHUD setForegroundColor:[UIColor redColor]];
                [SVProgressHUD showErrorWithStatus:@"Error While Fetching Contacts"];
                [self.view setUserInteractionEnabled:YES];
            } else {
                NSString *phone;
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
                UIImage *profileImage;
                NSMutableArray *contactNumbersArray;
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    if (lastName == nil) {
                        fullName=[NSString stringWithFormat:@"%@",firstName];
                    }else if (firstName == nil){
                        fullName=[NSString stringWithFormat:@"%@",lastName];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                    }
                    UIImage *image = [UIImage imageWithData:contact.imageData];
                    if (image != nil) {
                        profileImage = image;
                    }else{
                        profileImage = [UIImage imageNamed:@"person-icon.png"];
                    }
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            [contactNumbersArray addObject:phone];
                        }
                    }
                    NSDictionary* personDict = [[NSDictionary alloc] initWithObjectsAndKeys: fullName,@"fullName",profileImage,@"userImage",phone,@"PhoneNumbers", nil];
                    [contactsArray addObject:personDict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
                    [SVProgressHUD setForegroundColor:[UIColor greenColor]];
                    [SVProgressHUD showSuccessWithStatus:@"Backup Created Successfully"];
                    [self.view setUserInteractionEnabled:YES];
                 //   [SVProgressHUD dismiss];
                    _lblContactCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)contactsArray.count];
                    
                    NSUserDefaults *userBackupCount = [NSUserDefaults standardUserDefaults];
                    [userBackupCount setInteger:[contactsArray count] forKey:@"userBackupCount"];
                    [userBackupCount synchronize];
                    
                    _viewUpload.hidden = NO;
                    _viewContacts.hidden = NO;
                    _viewCreateBackup.hidden = YES;
                    _viewDownloadBackUp.hidden = YES;
                    //  [self.tableViewRef reloadData];
                    //    NSLog(@"%@",self->contactsArray);
                });
            }
        }
    }];
}

- (IBAction)onDownloadBackupClicked:(id)sender {
    NSArray *types = @[(__bridge NSString*)kUTTypeImage,(__bridge NSString*)kUTTypeSpreadsheet,(__bridge NSString*)kUTTypePresentation,(__bridge NSString*)kUTTypeFolder,(__bridge NSString*)kUTTypeZipArchive,(__bridge NSString*)kUTTypeVideo,(__bridge NSString*)kUTTypeText,(__bridge NSString *) kUTTypeContent, (__bridge NSString *) kUTTypePackage, @"com.apple.iwork.pages.pages", @"com.apple.iwork.numbers.numbers", @"com.apple.iwork.keynote.key", @"public.item"];
    
    //Create a object of document picker view and set the mode to Import
    UIDocumentPickerViewController *docPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
    
    //Set the delegate
    docPicker.delegate = self;
    //present the document picker
    [self presentViewController:docPicker animated:YES completion:nil];
}

@end
