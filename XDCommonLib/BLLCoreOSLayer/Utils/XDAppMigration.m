//
//  XDAppMigration.m
//  XDCommonLib
//
//  Created by SuXinDe on 2018/1/22.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import "XDAppMigration.h"

static NSString * const XDAppMigrationLastVersionKey      = @"XDAppMigration.lastMigrationVersion";
static NSString * const XDAppMigrationLastAppVersionKey   = @"XDAppMigration.lastAppVersion";

static NSString * const XDAppMigrationLastBuildKey      = @"XDAppMigration.lastMigrationBuild";
static NSString * const XDAppMigrationLastAppBuildKey   = @"XDAppMigration.lastAppBuild";

@implementation XDAppMigration


+ (void) migrateToVersion:(NSString *)version block:(xd_block_t)migrationBlock {
    // version > lastMigrationVersion && version <= appVersion
    if ([version compare:[self lastMigrationVersion] options:NSNumericSearch] == NSOrderedDescending &&
        [version compare:[self appVersion] options:NSNumericSearch]           != NSOrderedDescending) {
        migrationBlock();
        
#if DEBUG
        NSLog(@"XDAppMigration: Running migration for version %@", version);
#endif
        
        [self setLastMigrationVersion:version];
    }
}


+ (void) migrateToBuild:(NSString *)build block:(xd_block_t)migrationBlock
{
    // build > lastMigrationBuild && build <= appVersion
    if ([build compare:[self lastMigrationBuild] options:NSNumericSearch] == NSOrderedDescending &&
        [build compare:[self appBuild] options:NSNumericSearch]           != NSOrderedDescending) {
        migrationBlock();
        
#if DEBUG
        NSLog(@"XDAppMigration: Running migration for build %@", build);
#endif
        
        [self setLastMigrationBuild:build];
    }
}


+ (void) applicationUpdateBlock:(xd_block_t)updateBlock {
    if (![[self lastAppVersion] isEqualToString:[self appVersion]]) {
        updateBlock();
        
#if DEBUG
        NSLog(@"XDAppMigration: Running update Block for version %@", [self appVersion]);
#endif
        
        [self setLastAppVersion:[self appVersion]];
    }
}


+ (void) buildNumberUpdateBlock:(xd_block_t)updateBlock {
    if (![[self lastAppBuild] isEqualToString:[self appBuild]]) {
        updateBlock();
        
#if DEBUG
        NSLog(@"XDAppMigration: Running update Block for build %@", [self appBuild]);
#endif
        
        [self setLastAppBuild:[self appBuild]];
    }
}


+ (void) reset {
    [self setLastMigrationVersion:nil];
    [self setLastAppVersion:nil];
    [self setLastMigrationBuild:nil];
    [self setLastAppBuild:nil];
}


+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}


+ (NSString *)appBuild {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}


+ (void) setLastMigrationVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:XDAppMigrationLastVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void) setLastMigrationBuild:(NSString *)build {
    [[NSUserDefaults standardUserDefaults] setValue:build forKey:XDAppMigrationLastBuildKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *) lastMigrationVersion {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:XDAppMigrationLastVersionKey];
    
    return (res ? res : @"");
}


+ (NSString *) lastMigrationBuild {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:XDAppMigrationLastBuildKey];
    
    return (res ? res : @"");
}


+ (void)setLastAppVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:XDAppMigrationLastAppVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)setLastAppBuild:(NSString *)build {
    [[NSUserDefaults standardUserDefaults] setValue:build forKey:XDAppMigrationLastAppBuildKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *) lastAppVersion {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:XDAppMigrationLastAppVersionKey];
    
    return (res ? res : @"");
}


+ (NSString *) lastAppBuild {
    NSString *res = [[NSUserDefaults standardUserDefaults] valueForKey:XDAppMigrationLastAppBuildKey];
    
    return (res ? res : @"");
}

@end
