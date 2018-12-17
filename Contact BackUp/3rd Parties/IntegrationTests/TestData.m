//
//  TestData.m
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestData.h"

@implementation TestData

- (instancetype)init {
  self = [super init];
  if (self) {
    // generic user data
    _testId = [NSString stringWithFormat:@"%d", arc4random_uniform(1000)];
    _baseFolder = @"/Testing/ObjectiveDropboxTests";
    _testFolderName = @"testFolder";
    _testFolderPath = [NSString stringWithFormat:@"%@%@%@%@%@", _baseFolder, @"/", _testFolderName, @"_", _testId];
    _testShareFolderName = @"testShareFolder";
    _testShareFolderPath =
        [NSString stringWithFormat:@"%@%@%@%@%@", _baseFolder, @"/", _testShareFolderName, @"_", _testId];
    _testFileName = @"testFile";
    _testFilePath = [NSString stringWithFormat:@"%@%@%@", _testFolderPath, @"/", _testFileName];
    _testData = @"testing data example";
    _fileData = [_testData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    _fileManager = [NSFileManager defaultManager];
    _directoryURL = [_fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    _destURL = [_directoryURL URLByAppendingPathComponent:_testFileName];
    _destURLException = [_directoryURL
        URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", _testFileName, @"_does_not_exist"]];

    // generic team data
    _testIdTeam = [NSString stringWithFormat:@"%d", arc4random_uniform(1000)];
    _groupName = [NSString stringWithFormat:@"%@%@", @"GroupName", _testIdTeam];
    _groupExternalId = [NSString stringWithFormat:@"%@%@", @"group-", _testIdTeam];

    // personal user data
    _accountId = @"dbid:<ID1>";
    _accountId2 = @"dbid:<ID2>";
    _accountId3 = @"dbid:<ID3>";
    _accountId3Email = @"maulik@nestcodeinfo.com";

    // personal team data
    _teamMemberEmail = @"maulik@nestcodeinfo.com";
    _teamMemberNewEmail = @"maulik@nestcodeinfo.com";
    
    // OAuth 1.0 token
    _oauth1Token = @"ec7sGmkK16AAAAAAAAABN7J4Z_Zppl0waQbJpRq4cv1k_5V-qkGi7y1wE3i7qmI3";
    _oauth1TokenSecret = @"<OAUTH_1_TOKEN_SECRET>";
    
    // App key and secret
    _fullDropboxAppKey = @"9e8tpday8x8acxd";
    _fullDropboxAppSecret = @"mjqp5bamm6r71bg";
  }
  return self;
}

@end
