//
//  FilteredViewController.h
//  Contact BackUp
//
//  Created by nestcode on 8/9/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import "ContactTableViewCell.h"

@interface FilteredViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblConcacts;

@end
