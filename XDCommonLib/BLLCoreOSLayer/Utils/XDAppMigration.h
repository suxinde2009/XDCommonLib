//
//  XDAppMigration.h
//  XDCommonLib
//
//  Created by SuXinDe on 2018/1/22.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^xd_block_t)(void);

@interface XDAppMigration : NSObject

/**
 Executes a block of code for a specific version number and remembers this version as the latest migration done by XDAppMigration.
 
 @param version A string with a specific version number
 @param migrationBlock A block object to be executed when the application version matches the string 'version'. This parameter can't be nil.
 
 */

+ (void) migrateToVersion:(NSString *)version block:(xd_block_t)migrationBlock;

/**
 Executes a block of code for a specific build number and remembers this build as the latest migration done by XDAppMigration.
 
 @param buildNumber A string with a specific build number
 @param migrationBlock A block object to be executed when the application build matches the string 'build'. This parameter can't be nil.
 
 */

+ (void) migrateToBuild:(NSString *)build block:(xd_block_t)migrationBlock;

/**
 
 Executes a block of code for every time the application version changes.
 
 @param updateBlock A block object to be executed when the application version changes. This parameter can't be nil.
 
 */

+ (void) applicationUpdateBlock:(xd_block_t)updateBlock;

/**
 
 Executes a block of code for every time the application build number changes.
 
 @param updateBlock A block object to be executed when the application build number changes. This parameter can't be nil.
 
 */

+ (void) buildNumberUpdateBlock:(xd_block_t)updateBlock;

/** Clears the last migration remembered by XDAppMigration. Causes all migrations to run from the beginning. */

+ (void) reset;

@end
