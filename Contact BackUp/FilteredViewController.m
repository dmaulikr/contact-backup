//
//  FilteredViewController.m
//  Contact BackUp
//
//  Created by nestcode on 8/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "FilteredViewController.h"

@interface FilteredViewController ()
{
    NSMutableDictionary *contactDict;
    NSUserDefaults *userContactArr;
    NSMutableArray *contactArray;
    NSMutableArray *arrData;
    NSMutableArray *fullarrData;
    NSMutableArray *arraySearchContactData;
}
@property (nonatomic) NSMutableArray<CNContact *> *contacts;

@end

@implementation FilteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrData = [[NSMutableArray alloc]init];
    fullarrData = [[NSMutableArray alloc]init];
    [self getContact];
}

-(void)getContact
{
    // Request authorization to Contacts
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES)
        {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey, CNContactBirthdayKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSString *phone;
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
                NSArray *arrEmail = [[NSArray alloc]init];
                UIImage *profileImage;
                NSMutableArray *contactNumbersArray = [[NSMutableArray alloc]init];
                NSMutableArray *arrContacts = [[NSMutableArray alloc]init];
                
                NSMutableArray *fullarrContacts = [[NSMutableArray alloc]init];
                
                for (CNContact *contact in cnContacts)
                {
                    // copy data to my custom Contacts class.
                    NSString *strEmail;
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    arrEmail = contact.emailAddresses;
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
                        profileImage = [UIImage imageNamed:@"user.png"];
                    }
                    for (CNLabeledValue *label in contact.phoneNumbers)
                    {
                        phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            [contactNumbersArray addObject:phone];
                        }
                    }
                    
                    for (CNLabeledValue *label in contact.emailAddresses)
                    {
                        strEmail = label.value;
                    }
                    if (strEmail == nil) {
                        strEmail = @"Mail Address Not Found";
                    }
                    
                    NSDictionary* personDict = [[NSDictionary alloc] initWithObjectsAndKeys: fullName,@"fullName",profileImage,@"userImage",phone,@"PhoneNumbers", nil];
                    
                    
                    NSDictionary *tmpDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                             fullName,@"fullName",
                                             phone,@"PhoneNumbers",
                                             strEmail,@"Email",
                                             profileImage,@"userImage",
                                             nil];
                    
              //      NSLog(@"%@",tmpDict);
               //     NSLog(@"%@,%@,%@",firstName,lastName,phone);
                    [arrContacts addObject:[NSString stringWithFormat:@"%@",[personDict objectForKey:@"fullName"]]];
                    
                    [fullarrContacts addObject:tmpDict];
                }
                //Removing Duplicate Contacts from array
                NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrContacts];
                NSArray *arrayWithoutDuplicates = [orderedSet array];
                arrData = [arrayWithoutDuplicates mutableCopy];
                
                NSOrderedSet *fullorderedSet = [NSOrderedSet orderedSetWithArray:fullarrContacts];
                NSArray *fullarrayWithoutDuplicates = [fullorderedSet array];
                fullarrData = [fullarrayWithoutDuplicates mutableCopy];
                
                NSLog(@"The contacts are - %@",fullarrData);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tblConcacts reloadData];
                });
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return  fullarrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    //CustomTableview Cell.
    ContactTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *dictTemp = [fullarrData objectAtIndex:indexPath.row];
    cell.lblFullName.text = [dictTemp valueForKey:@"fullName"];
    cell.lblContactNum.text = [dictTemp valueForKey:@"PhoneNumbers"];
    cell.imgAvatar.image = [dictTemp valueForKey:@"userImage"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
    // This is just Programatic method you can also do that by xib !
}

#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictTemp = [fullarrData objectAtIndex:indexPath.row];
    
}



@end
