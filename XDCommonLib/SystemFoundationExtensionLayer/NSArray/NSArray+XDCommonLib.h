//
//  NSArray+XDCommonLib.h
//  XDCommonLib
//
//  Created by suxinde on 16/4/11.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <stdarg.h>

typedef id (^MapBlock)(id object);
typedef BOOL (^TestingBlock)(id object);

@interface NSArray (SafeAccess)

- (id)firstObject;

- (id)objectWithIndex:(NSUInteger)index;

- (NSString*)stringWithIndex:(NSUInteger)index;

- (NSNumber*)numberWithIndex:(NSUInteger)index;

- (NSDecimalNumber *)decimalNumberWithIndex:(NSUInteger)index;

- (NSArray*)arrayWithIndex:(NSUInteger)index;

- (NSDictionary*)dictionaryWithIndex:(NSUInteger)index;

- (NSInteger)integerWithIndex:(NSUInteger)index;

- (NSUInteger)unsignedIntegerWithIndex:(NSUInteger)index;

- (BOOL)boolWithIndex:(NSUInteger)index;

- (int16_t)int16WithIndex:(NSUInteger)index;

- (int32_t)int32WithIndex:(NSUInteger)index;

- (int64_t)int64WithIndex:(NSUInteger)index;

- (char)charWithIndex:(NSUInteger)index;

- (short)shortWithIndex:(NSUInteger)index;

- (float)floatWithIndex:(NSUInteger)index;

- (double)doubleWithIndex:(NSUInteger)index;

- (NSDate *)dateWithIndex:(NSUInteger)index dateFormat:(NSString *)dateFormat;
//CG
- (CGFloat)CGFloatWithIndex:(NSUInteger)index;

- (CGPoint)pointWithIndex:(NSUInteger)index;

- (CGSize)sizeWithIndex:(NSUInteger)index;

- (CGRect)rectWithIndex:(NSUInteger)index;
@end


#pragma --mark NSMutableArray setter

@interface NSMutableArray(SafeAccess)

-(void)addObj:(id)i;

-(void)addString:(NSString*)i;

-(void)addBool:(BOOL)i;

-(void)addInt:(int)i;

-(void)addInteger:(NSInteger)i;

-(void)addUnsignedInteger:(NSUInteger)i;

-(void)addCGFloat:(CGFloat)f;

-(void)addChar:(char)c;

-(void)addFloat:(float)i;

-(void)addPoint:(CGPoint)o;

-(void)addSize:(CGSize)o;

-(void)addRect:(CGRect)o;

@end

@interface NSArray (Block)

- (void)each:(void (^)(id object))block;

- (void)eachWithIndex:(void (^)(id object, NSUInteger index))block;

- (NSArray *)map:(id (^)(id object))block;

- (NSArray *)filter:(BOOL (^)(id object))block;

- (NSArray *)reject:(BOOL (^)(id object))block;

- (id)detect:(BOOL (^)(id object))block;

- (id)reduce:(id (^)(id accumulator, id object))block;

- (id)reduce:(id)initial withBlock:(id (^)(id accumulator, id object))block;

@end

@interface NSArray (XDCommonLib)

- (id)safeObjectAtIndex:(NSUInteger)index;

/**
 *  Create a reversed array from self
 *
 *  @return Returns the reversed array
 */
- (NSArray *)reversedArray;

/**
 *  Convert self to JSON as NSString
 *
 *  @return Returns the JSON as NSString or nil if error while parsing
 */
- (NSString *)arrayToJson;

/**
 *  Simulates the array as a circle. When it is out of range, begins again
 *
 *  @param index The index
 *
 *  @return Returns the object at a given index
 */
- (id)objectAtCircleIndex:(NSInteger)index;

/**
 *  Create a reversed array from the given array
 *
 *  @param array The array to be converted
 *
 *  @return Returns the reversed array
 */
+ (NSArray *)reversedArray:(NSArray *)array;

/**
 *  Convert the given array to JSON as NSString
 *
 *  @param array The array to be reversed
 *
 *  @return Returns the JSON as NSString or nil if error while parsing
 */
+ (NSString *)arrayToJson:(NSArray *)array;


@end


@interface NSMutableArray (XDCommonLib)

/**
 *  Move an object from an index to another
 *
 *  @param from The index to move from
 *  @param to   The index to move to
 */
- (void)moveObjectFromIndex:(NSUInteger)from
                    toIndex:(NSUInteger)to;

/**
 *  Create a reversed array from self
 *
 *  @return Returns the reversed array
 */
- (NSMutableArray *)reversedArray;

/**
 *  Sort an array by a given key with option for ascending or descending
 *
 *  @param key       The key to order the array
 *  @param array     The array to be ordered
 *  @param ascending A BOOL to choose if ascending or descending
 *
 *  @return Returns the given array ordered by the given key ascending or descending
 */
+ (NSMutableArray *)sortArrayByKey:(NSString *)key
                             array:(NSMutableArray *)array
                         ascending:(BOOL)ascending;

@end


#pragma mark - Utility
@interface NSArray (Utility)

// Transform array to va_list
//__builtin_va_list
- (void *)va_list;

// Random
@property (nonatomic, readonly) id randomItem;
@property (nonatomic, readonly) NSArray *scrambled;

// Utility
@property (nonatomic, readonly) NSArray *reversed;
@property (nonatomic, readonly) NSArray *sorted;
@property (nonatomic, readonly) NSArray *sortedCaseInsensitive;

// Setification
@property (nonatomic, readonly) NSArray *uniqueElements;
- (NSArray *) unionWithArray: (NSArray *) anArray;
- (NSArray *) intersectionWithArray: (NSArray *) anArray;
- (NSArray *) differenceToArray: (NSArray *) anArray;

// Lisp
@property (nonatomic, readonly) id car;
@property (nonatomic, readonly) NSArray *cdr;
- (NSArray *) map: (MapBlock) aBlock;
- (NSArray *) collect: (TestingBlock) aBlock;
- (NSArray *) reject: (TestingBlock) aBlock;
@end

#pragma mark - Utility
@interface NSMutableArray (Frankenstein)
- (NSMutableArray *) reverseSelf;
@end

#pragma mark - Stacks and Queues
@interface NSMutableArray (StackAndQueueExtensions)
- (id) popObject;
- (id) pullObject;
- (NSMutableArray *) pushObject:(id)object;
- (NSMutableArray *) pushObjects:(id)object,...;
@end

#pragma Pseudo Dictionary
@interface NSArray (pseudodictionary)
- (id) objectForKey: (NSString *) aKey;
@end

@interface NSMutableArray (pseudodictionary)
- (void) setObject: (id) object forKey: (NSString *) aKey;
@end


#pragma mark - Safe Access Override
@interface NSArray (safeArray)
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
#if TARGET_OS_IPHONE
- (id) objectForKeyedSubscript: (id) subscript; // for IndexPath - iOS Only
#endif
@end

@interface NSMutableArray (safeArray)
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index;
@end


