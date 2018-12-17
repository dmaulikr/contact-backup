//
//  LaunchScreenViewController.m
//  Contact BackUp
//
//  Created by nestcode on 7/27/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "LaunchScreenViewController.h"

@interface LaunchScreenViewController ()

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self performSelector:@selector(toNewViewController) withObject:nil afterDelay:5.0];
}

- (void)toNewViewController {
    [self performSegueWithIdentifier:@"toHome" sender:self];
}


@end
