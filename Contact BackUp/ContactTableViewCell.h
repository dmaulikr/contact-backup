//
//  ContactTableViewCell.h
//  Merger
//
//  Created by Sri Ram on 12/23/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textlbl
;
@property (weak, nonatomic) IBOutlet UILabel *detailTextlbl;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *lblDuplicates;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblContactNum;
@property (weak, nonatomic) IBOutlet UIView *viewBack;


@end
