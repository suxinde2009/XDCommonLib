//
//  NSFetchRequest+Extensions.m
//
//  Created by Wess Cope on 9/23/11.
//  Copyright 2012. All rights reserved.
//

#import "NSFetchRequest+Extensions.h"

@implementation NSFetchRequest (Extensions)

+ (id)fetchRequestWithEntity:(NSEntityDescription *)entity
{
  return [[[self class] alloc] initWithEntity:entity
                            predicate:nil
                      sortDescriptors:nil];
}

+ (id)fetchRequestWithEntity:(NSEntityDescription *)entity
                   predicate:(NSPredicate *)predicate
{
  return [[[self class] alloc] initWithEntity:entity
                            predicate:predicate
                      sortDescriptors:nil];
}

+ (id)fetchRequestWithEntity:(NSEntityDescription *)entity
             sortDescriptors:(NSArray *)sortDescriptors
{
  return [[[self class] alloc] initWithEntity:entity
                                    predicate:nil
                              sortDescriptors:sortDescriptors];
}

+ (id)fetchRequestWithEntity:(NSEntityDescription *)entity
                   predicate:(NSPredicate *)predicate
             sortDescriptors:(NSArray *)sortDescriptors
{
  return [[[self class] alloc] initWithEntity:entity
                                    predicate:predicate
                              sortDescriptors:sortDescriptors];
}


- (id)initWithEntity:(NSEntityDescription *)entity
           predicate:(NSPredicate *)predicate
     sortDescriptors:(NSArray *)sortDescriptors
{
  if(self = [self init]) {
    self.entity = entity;
    self.predicate = predicate;
    self.sortDescriptors = sortDescriptors;
  }
  return self;
}

@end