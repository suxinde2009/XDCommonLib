//
//  NSArray+XDCommonLib.m
//  XDCommonLib
//
//  Created by suxinde on 16/4/11.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import "NSArray+XDCommonLib.h"

@implementation NSArray (SafeAccess)

- (id)firstObject {
    return (self.count ? [self objectAtIndex:0] : nil);
}

- (id)objectWithIndex:(NSUInteger)index
{
    if (index <self.count) {
        return self[index];
    }else{
        return nil;
    }
}

- (NSString*)stringWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return @"";
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}


- (NSNumber*)numberWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (NSDecimalNumber *)decimalNumberWithIndex:(NSUInteger)index{
    id value = [self objectWithIndex:index];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber*)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString*)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    return nil;
}

- (NSArray*)arrayWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    return nil;
}


- (NSDictionary*)dictionaryWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    return nil;
}

- (NSInteger)integerWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    return 0;
}
- (NSUInteger)unsignedIntegerWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value unsignedIntegerValue];
    }
    return 0;
}
- (BOOL)boolWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    return NO;
}
- (int16_t)int16WithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (int32_t)int32WithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (int64_t)int64WithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    return 0;
}

- (char)charWithIndex:(NSUInteger)index{
    
    id value = [self objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value charValue];
    }
    return 0;
}

- (short)shortWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (float)floatWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    return 0;
}
- (double)doubleWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value doubleValue];
    }
    return 0;
}

- (NSDate *)dateWithIndex:(NSUInteger)index dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormat;
    id value = [self objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] && !dateFormat) {
        return [formater dateFromString:value];
    }
    return nil;
}

//CG
- (CGFloat)CGFloatWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    CGFloat f = [value doubleValue];
    
    return f;
}

- (CGPoint)pointWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    CGPoint point = CGPointFromString(value);
    
    return point;
}
- (CGSize)sizeWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    CGSize size = CGSizeFromString(value);
    
    return size;
}
- (CGRect)rectWithIndex:(NSUInteger)index
{
    id value = [self objectWithIndex:index];
    
    CGRect rect = CGRectFromString(value);
    
    return rect;
}
@end


#pragma --mark NSMutableArray setter
@implementation NSMutableArray (SafeAccess)
-(void)addObj:(id)i{
    if (i!=nil) {
        [self addObject:i];
    }
}
-(void)addString:(NSString*)i
{
    if (i!=nil) {
        [self addObject:i];
    }
}
-(void)addBool:(BOOL)i
{
    [self addObject:@(i)];
}
-(void)addInt:(int)i
{
    [self addObject:@(i)];
}
-(void)addInteger:(NSInteger)i
{
    [self addObject:@(i)];
}
-(void)addUnsignedInteger:(NSUInteger)i
{
    [self addObject:@(i)];
}
-(void)addCGFloat:(CGFloat)f
{
    [self addObject:@(f)];
}
-(void)addChar:(char)c
{
    [self addObject:@(c)];
}
-(void)addFloat:(float)i
{
    [self addObject:@(i)];
}
-(void)addPoint:(CGPoint)o
{
    [self addObject:NSStringFromCGPoint(o)];
}
-(void)addSize:(CGSize)o
{
    [self addObject:NSStringFromCGSize(o)];
}
-(void)addRect:(CGRect)o
{
    [self addObject:NSStringFromCGRect(o)];
}
@end



@implementation NSArray (Block)
- (void)each:(void (^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (void)eachWithIndex:(void (^)(id object, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

- (NSArray *)map:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        [array addObject:block(object) ?: [NSNull null]];
    }
    
    return array;
}

- (NSArray *)filter:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }]];
}

- (NSArray *)reject:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !block(evaluatedObject);
    }]];
}

- (id)detect:(BOOL (^)(id object))block {
    for (id object in self) {
        if (block(object))
            return object;
    }
    return nil;
}

- (id)reduce:(id (^)(id accumulator, id object))block {
    return [self reduce:nil withBlock:block];
}

- (id)reduce:(id)initial withBlock:(id (^)(id accumulator, id object))block {
    id accumulator = initial;
    
    for(id object in self)
        accumulator = accumulator ? block(accumulator, object) : object;
    
    return accumulator;
}
@end


@implementation NSArray (XDCommonLib)

- (id _Nullable)safeObjectAtIndex:(NSUInteger)index {
    if ([self count] > 0 && [self count] > index) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}

- (NSArray *)reversedArray {
    return [NSArray reversedArray:self];
}

- (NSString *)arrayToJson {
    return [NSArray arrayToJson:self];
}

- (NSInteger)superCircle:(NSInteger)index maxSize:(NSInteger)maxSize {
    if (index < 0) {
        index = index % maxSize;
        index += maxSize;
    }
    if (index >= maxSize) {
        index = index % maxSize;
    }
    
    return index;
}

- (id)objectAtCircleIndex:(NSInteger)index {
    return [self objectAtIndex:[self superCircle:index maxSize:self.count]];
}

+ (NSString *)arrayToJson:(NSArray *)array {
    NSString *json = nil;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:&error];
    if (!error) {
        json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return json;
    } else {
#if DEBUG
        NSLog(@"%s: %@", __func__, error.localizedDescription);
#endif
        return nil;
    }
}

+ (NSArray *)reversedArray:(NSArray *)array {
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:[array count]];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    
    for (id element in enumerator) [arrayTemp addObject:element];
    
    return arrayTemp;
}


@end

@implementation NSMutableArray (XDCommonLib)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    if (to != from) {
        id obj = [self safeObjectAtIndex:from];
        [self removeObjectAtIndex:from];
        
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
    }
}

- (NSMutableArray * _Nonnull)reversedArray {
    return (NSMutableArray *)[NSArray reversedArray:self];
}

+ (NSMutableArray * _Nonnull)sortArrayByKey:(NSString * _Nonnull)key array:(NSMutableArray * _Nonnull)array ascending:(BOOL)ascending {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray removeAllObjects];
    [tempArray addObjectsFromArray:array];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:@[descriptor]];
    
    [tempArray removeAllObjects];
    tempArray = (NSMutableArray *)sortedArray;
    
    [array removeAllObjects];
    [array addObjectsFromArray:tempArray];
    
    return array;
}

@end

#pragma mark - NSArray Utility -

@implementation NSArray (Utility)

#pragma mark - Custom description

- (NSString *) descriptionWithLocale:(id)locale
{
    NSMutableString *description = [NSMutableString string];
    NSArray *descriptionArray = [self map:^id(id object) {if ([object respondsToSelector:@selector(descriptionWithLocale:)]) return [object descriptionWithLocale:locale]; return [object description];}];
    
    [description appendString:@"["];
    [description appendString:[descriptionArray componentsJoinedByString:@", "]];
    [description appendString:@"]"];
    
    return description;
}

# pragma mark - va_list

- (void *)va_list {
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(id) * self.count)];
    [self getObjects:(__unsafe_unretained id *)data.mutableBytes range:NSMakeRange(0, self.count)];
    return data.mutableBytes;
}


#pragma mark - Random

- (id) randomItem {
    if (!self.count) return nil;
    static BOOL seeded = NO;
    if (!seeded) {seeded = YES; srandom((unsigned int) time(0));}
    NSInteger whichItem = (NSUInteger)(random() % self.count);
    return self[whichItem];
}

- (NSArray *) scrambled {
    static BOOL seeded = NO;
    if (!seeded) {seeded = YES; srandom((unsigned int) time(0));}
    NSMutableArray *resultArray = [self mutableCopy];
    for (int i = 0; i < (self.count - 2); i++) {
        [resultArray exchangeObjectAtIndex:i withObjectAtIndex:(i + (random() % (self.count - i)))];
    }
    return resultArray.copy;
}

#pragma mark - Utility

- (NSArray *)reversed {
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *) sorted {
    NSArray *resultArray = [self sortedArrayUsingComparator:
                            ^(id obj1, id obj2){return [obj1 compare:obj2];}];
    return resultArray;
}

- (NSArray *) sortedCaseInsensitive {
    NSArray *resultArray = [self sortedArrayUsingComparator:
                            ^(id obj1, id obj2){return [obj1 caseInsensitiveCompare:obj2];}];
    return resultArray;
}


#pragma mark - Set theory

- (NSArray *) uniqueElements {
    return [NSOrderedSet orderedSetWithArray:self].array.copy;
}

- (NSArray *) unionWithArray: (NSArray *) anArray {
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    [set1 unionOrderedSet:set2];
    return set1.array.copy;
}

- (NSArray *) intersectionWithArray: (NSArray *) anArray {
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 intersectOrderedSet:set2];
    
    return set1.array.copy;
}

- (NSArray *) differenceToArray: (NSArray *) anArray
{
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 minusOrderedSet:set2];
    
    return set1.array.copy;
}

#pragma mark - Lisp

- (id) car
{
    if (self.count == 0) return nil;
    return self[0];
}

- (NSArray *) cdr
{
    if (self.count < 2) return nil;
    return [self subarrayWithRange:NSMakeRange(1, self.count - 1)];
}

- (NSArray *) map: (MapBlock) aBlock
{
    if (!aBlock) return self;
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (id object in self)
    {
        id result = aBlock(object);
        [resultArray addObject: result ? : [NSNull null]];
    }
    return [resultArray copy];
}

- (NSArray *) collect: (TestingBlock) aBlock {
    if (!aBlock) return self;
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (id object in self)
    {
        BOOL result = aBlock(object);
        if (result)
            [resultArray addObject:object];
    }
    return [resultArray copy];
}

- (NSArray *) reject: (TestingBlock) aBlock {
    if (!aBlock) return self;
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (id object in self)
    {
        BOOL result = aBlock(object);
        if (!result)
            [resultArray addObject:object];
    }
    return [resultArray copy];
}
@end


#pragma mark - NSMutableArray Utility -

@implementation NSMutableArray (Utility)

- (NSMutableArray *) reverseSelf {
    for (int i = 0; i < (floor(self.count/2.0)); i++)
        [self exchangeObjectAtIndex:i withObjectAtIndex:(self.count-(i+1))];
    return self;
}

@end

#pragma mark - Stack and Queue -

// Pull from start, pop from end, push onto end
@implementation NSMutableArray (StackAndQueueExtensions)
- (id) popObject {
    if (self.count == 0) return nil;
    id lastObject = [self lastObject];
    [self removeLastObject];
    return lastObject;
}

- (NSMutableArray *) pushObject:(id)object {
    [self addObject:object];
    return self;
}

- (NSMutableArray *) pushObjects:(id)object,... {
    if (!object) return self;
    id obj = object;
    va_list objects;
    va_start(objects, object);
    do {
        [self addObject:obj];
        obj = va_arg(objects, id);
    } while (obj);
    va_end(objects);
    return self;
}

- (id)pullObject {
    if (self.count == 0) return nil;
    id object = [self firstObject];
    [self removeObjectAtIndex:0];
    return object;
}
@end

#pragma mark - NSArray and NSMutableArray Pseudo Dictionary -

// Primarily used for key path for property list utilities

@implementation NSArray (pseudodictionary)
- (id) objectForKey: (NSString *) aKey {
    int key = [aKey intValue];
    if ((key < 0) || (key >= self.count)) return nil;
    return self[key];
}
@end

@implementation NSMutableArray (pseudodictionary)
- (void) setObject: (id) object forKey: (NSString *) aKey {
    int key = [aKey intValue];
    if ((key < 0)  || (key >= self.count))
    {
        NSLog(@"Error: Array index (%d) out of bounds for array with %ld items", key, (long) self.count);
        return;
    }
    [self replaceObjectAtIndex:key withObject:object];
}
@end

#pragma mark - Safe Arrays -

@implementation NSArray (safeArray)

// Consider using Sparse Array instead
- (id) safeObjectAtIndex: (NSUInteger) index {
    if (index < self.count)
    {
        id object = [self objectAtIndex:index];
        if ([object isKindOfClass:[NSNull class]])
            return nil;
        return object;
    }
    return nil;
}

#if TARGET_OS_IPHONE
- (id) objectForKeyedSubscript: (id) subscript {
    if (![subscript isKindOfClass:[NSIndexPath class]])
        return nil;
    NSIndexPath *path = (NSIndexPath *) subscript;
    NSArray *sub = [self safeObjectAtIndex:path.section];
    if (![sub isKindOfClass:[NSArray class]])
        return nil;
    return [sub safeObjectAtIndex:path.row];
}
#endif

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self safeObjectAtIndex:idx];
}
@end

@implementation NSMutableArray (safeArray)

// Consider using Sparse Array instead
- (void) safeSetObject: (id) object atIndex: (NSUInteger) index {
    if (index < self.count)
    {
        if (object)
        {
            self[index] = object;
            return;
        }
        
        // Insert nil as a null object
        self[index] = [NSNull null];
        return;
    }
    
    // out of bounds
    for (NSInteger i = self.count; i < index; i++)
        [self addObject:[NSNull null]];
    
    [self addObject:object];
}

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index {
    [self safeSetObject:anObject atIndex:index];
}
@end


