//
//  ContactsViewController.h
//  Contact BackUp
//
//  Created by nestcode on 7/28/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactsViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate,ABNewPersonViewControllerDelegate>

@property (nonatomic, assign) ABAddressBookRef addressBook;

- (IBAction)onAllContactsClicked:(id)sender;
- (IBAction)onCreateNewClicked:(id)sender;


@end
