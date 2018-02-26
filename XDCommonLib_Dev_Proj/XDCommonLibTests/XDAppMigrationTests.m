//
//  XDAppMigrationTests.m
//  XDCommonLibTests
//
//  Created by SuXinDe on 2018/1/22.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import "XDAppMigrationTests.h"
#import "XDAppMigration.h"

#define kDefaultWaitForExpectionsTimeout 2.0

@implementation XDAppMigrationTests

- (void)setUp {
    
    [super setUp];
    [XDAppMigration reset];
}

- (void)testMigrationReset
{
    
    XCTestExpectation *expectingBlock1Run = [self expectationWithDescription:@"Expecting block to be run for version 0.9"];
    [XDAppMigration migrateToVersion:@"0.9" block:^{
        [expectingBlock1Run fulfill];
    }];
    
    XCTestExpectation *expectingBlock2Run = [self expectationWithDescription:@"Expecting block to be run for version 1.0"];
    [XDAppMigration migrateToVersion:@"1.0" block:^{
        [expectingBlock2Run fulfill];
    }];
    
    [XDAppMigration reset];
    
    XCTestExpectation *expectingBlock3Run = [self expectationWithDescription:@"Expecting block to be run AGAIN for version 0.9"];
    [XDAppMigration migrateToVersion:@"0.9" block:^{
        [expectingBlock3Run fulfill];
    }];
    
    XCTestExpectation *expectingBlock4Run = [self expectationWithDescription:@"Expecting block to be run AGAIN for version 1.0"];
    [XDAppMigration migrateToVersion:@"1.0" block:^{
        [expectingBlock4Run fulfill];
    }];
    
    [self waitForAllExpectations];
}

- (void)testMigratesOnFirstRun
{
    
    XCTestExpectation *expectationBlockRun = [self expectationWithDescription:@"Should execute migration after reset"];
    [XDAppMigration migrateToVersion:@"1.0" block:^{
        [expectationBlockRun fulfill];
    }];
    
    [self waitForAllExpectations];
}

- (void)testMigratesOnce
{
    
    XCTestExpectation *expectationBlockRun = [self expectationWithDescription:@"Expecting block to be run"];
    [XDAppMigration migrateToVersion:@"1.0" block:^{
        [expectationBlockRun fulfill];
    }];
    
    [XDAppMigration migrateToVersion:@"1.0" block:^{
        XCTFail(@"Should not execute a block for the same version twice.");
    }];
    
    [self waitForAllExpectations];
}

- (void)testMigratesPreviousBlocks
{
    
    XCTestExpectation *expectingBlock1Run = [self expectationWithDescription:@"Expecting block to be run for version 0.9"];
    [XDAppMigration migrateToVersion:@"0.9" block:^{
        [expectingBlock1Run fulfill];
    }];
    
    XCTestExpectation *expectingBlock2Run = [self expectationWithDescription:@"Expecting block to be run for version 1.0"];
    [XDAppMigration migrateToVersion:@"1.0" block:^{
        [expectingBlock2Run fulfill];
    }];
    
    [self waitForAllExpectations];
}

- (void)testMigratesInNaturalSortOrder
{
    
    XCTestExpectation *expectingBlock1Run = [self expectationWithDescription:@"Expecting block to be run for version 0.9"];
    [XDAppMigration migrateToVersion:@"0.9" block:^{
        [expectingBlock1Run fulfill];
    }];
    
    [XDAppMigration migrateToVersion:@"0.1" block:^{
        XCTFail(@"Should use natural sort order, e.g. treat 0.10 as a follower of 0.9");
    }];
    
    XCTestExpectation *expectingBlock2Run = [self expectationWithDescription:@"Expecting block to be run for version 0.10"];
    [XDAppMigration migrateToVersion:@"0.10" block:^{
        [expectingBlock2Run fulfill];
    }];
    
    [self waitForAllExpectations];
}

- (void)testRunsApplicationUpdateBlockOnce
{
    
    XCTestExpectation *expectationBlockRun = [self expectationWithDescription:@"Should only call block once"];
    [XDAppMigration applicationUpdateBlock:^{
        [expectationBlockRun fulfill];
    }];
    
    [XDAppMigration applicationUpdateBlock:^{
        XCTFail(@"Expected applicationUpdateBlock to be called only once");
    }];
    
    [self waitForAllExpectations];
}

- (void)testRunsApplicationUpdateBlockeOnlyOnceWithMultipleMigrations
{
    
    [XDAppMigration migrateToVersion:@"0.8" block:^{
        // Do something
    }];
    
    [XDAppMigration migrateToVersion:@"0.9" block:^{
        // Do something
    }];
    
    [XDAppMigration migrateToVersion:@"0.10" block:^{
        // Do something
    }];
    
    XCTestExpectation *expectationBlockRun = [self expectationWithDescription:@"Should call the applicationUpdateBlock only once no matter how many migrations have to be done"];
    [XDAppMigration applicationUpdateBlock:^{
        [expectationBlockRun fulfill];
    }];
    
    [self waitForAllExpectations];
}

- (void)waitForAllExpectations {
    
    [self waitForExpectationsWithTimeout:kDefaultWaitForExpectionsTimeout handler:^(NSError *error) {
        //do nothing
    }];
}

@end
