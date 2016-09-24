//
//  NSString+URL.h
//  Liveman
//
//  Created by YaoYaoX on 16/9/8.
//  Copyright © 2016年 LeSports. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

+ (void)parseUrlWithString:(NSString *)urlString complete:(void(^)(NSString *scheme, NSString *domain, NSDictionary *params))complete;

@end
