//
//  NSDate+XD_NSDateRFC1123.h
//  XDCommonLib
//
//  Created by suxinde on 2017/1/24.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Category on NSDate to support rfc1123 formatted date strings.
 http://blog.mro.name/2009/08/nsdateformatter-http-header/ and
 http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
 */

@interface NSDate (XD_NSDateRFC1123)

/**
 Convert a RFC1123 'Full-Date' string
 (http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1)
 into NSDate.
 */
+ (NSDate*)dateFromRFC1123:(NSString*)value;

/**
 Convert NSDate into a RFC1123 'Full-Date' string
 (http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1).
 */
- (NSString*)rfc1123String;


@end
