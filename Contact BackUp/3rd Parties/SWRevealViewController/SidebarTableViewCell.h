//
//  SidebarTableViewCell.h
//  Redbull_11
//
//  Created by Trainee 11 on 14/04/17.
//  Copyright © 2017 Trainee 11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SidebarTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *logoutbtn;

@property (weak, nonatomic) IBOutlet UIImageView *user_profile;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_email;

@property (weak, nonatomic) IBOutlet UIImageView *imgHome;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgPurchase;
@property (weak, nonatomic) IBOutlet UIImageView *imgSettings;
@property (weak, nonatomic) IBOutlet UIImageView *imgAboutUs;
@property (weak, nonatomic) IBOutlet UIImageView *imgShare;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogout;

@property (weak, nonatomic) IBOutlet UIImageView *imgFaq;
@property (weak, nonatomic) IBOutlet UIImageView *imgContact;


@end
