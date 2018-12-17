//
//  ContactTableViewCell.m
//  Merger
//
//  Created by Sri Ram on 12/23/16.
//  Copyright © 2016 Sri Ram. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell
@synthesize lblDuplicates,textlbl,detailTextlbl;
- (void)awakeFromNib {
    [super awakeFromNib];

    _viewBack.layer.borderColor = [UIColor colorWithRed:0 green:104.0f/255.0f blue:140.0f/255.0f alpha:1.0].CGColor;
    _viewBack.layer.borderWidth = 1.0f;
    _viewBack.layer.cornerRadius = 5.0f;
    
    _imgAvatar.layer.borderColor = [UIColor colorWithRed:0 green:104.0f/255.0f blue:140.0f/255.0f alpha:1.0].CGColor;
    _imgAvatar.layer.borderWidth = 0.5f;
    _imgAvatar.layer.cornerRadius = 20.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
