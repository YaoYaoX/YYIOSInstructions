//
//  NSString+URL.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 16/9/8.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

+ (void)parseUrlWithString:(NSString *)urlString complete:(void(^)(NSString *scheme, NSString *domain, NSDictionary *params))complete{
    
    
    NSString *scheme = nil;
    NSString *domain = nil;
    NSMutableDictionary *paramArray = nil;
    
    NSArray *urlCompent = [urlString componentsSeparatedByString:@"://"];
    if (urlCompent.count>0) {
        
        scheme = urlCompent[0]; // scheme
        
        if (urlCompent.count > 1) {
            
            NSString *domainString = urlCompent[1];
            NSArray *domainComp = [domainString componentsSeparatedByString:@"?"];
            
            if (domainComp.count>0) {
                
                domain = domainComp[0]; // domain
                
                if (domainComp.count>1) {
                    
                    NSString *paramString = domainComp[1];
                    NSArray *paramComp = [paramString componentsSeparatedByString:@"&"];
                    
                    paramArray = [NSMutableDictionary dictionary]; // 参数
                    for (NSString *paramStr in paramComp) {
                        NSArray *singleParamComp = [paramStr componentsSeparatedByString:@"="];
                        if (singleParamComp.count>1) {
                            paramArray[singleParamComp[0]] = singleParamComp[1];
                        }
                    }
                }
            }
        }
    }
    
    if (complete) {
        complete(scheme, domain, paramArray);
    }
}
@end
