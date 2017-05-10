//
//  QBEncryptedURLRequest.m
//  QBNetworking
//
//  Created by Sean Yue on 15/9/14.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "NSDictionary+QBSign.h"
#import "NSString+crypt.h"
#import "QBNetworkingConfiguration.h"
#import "QBDefines.h"
#import "NSString+md5.h"

static NSString *const kEncryptionPasssword = @"f7@j3%#5aiG$4";
static NSString *const kNewEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";


@implementation QBEncryptedURLRequest

- (NSString *)signKey {
    return self.configuration.encryptionPasssword ?: kEncryptionPasssword;
}

- (NSDictionary *)commonParams {
    return @{@"appId":self.configuration.RESTAppId,
             kEncryptionKeyName:self.signKey,
             @"imsi":@"999999999999999",
             @"channelNo":self.configuration.channelNo,
             @"pV":self.configuration.RESTpV
             };
}

- (NSArray *)keyOrdersOfCommonParams {
    return @[@"appId",kEncryptionKeyName,@"imsi",@"channelNo",@"pV"];
}

- (id)encryptWithParams:(NSDictionary *)params {
    if (self.configuration.encryptedType == QBURLEncryptedTypeOriginal) {
        NSMutableDictionary *mergedParams = params ? params.mutableCopy : [NSMutableDictionary dictionary];
        NSDictionary *commonParams = [self commonParams];
        if (commonParams) {
            [mergedParams addEntriesFromDictionary:commonParams];
        }
        
        return [mergedParams encryptedDictionarySignedTogetherWithDictionary:commonParams keyOrders:[self keyOrdersOfCommonParams] passwordKeyName:kEncryptionKeyName];
    } else if (self.configuration.encryptedType == QBURLEncryptedTypeNew) {
        if (!params) {
            return nil;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        if (!jsonData) {
            return nil;
        }
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *encryptedKey = [jsonString encryptedStringWithPassword:[(self.configuration.encryptionPasssword ?: kNewEncryptionPassword).md5 substringToIndex:16]];
        return @{@"data":encryptedKey};
//        return [NSString stringWithFormat:@"data=%@",encryptedKey];
    }
}

- (BOOL)requestURLPath:(NSString *)urlPath withParams:(NSDictionary *)params responseHandler:(QBURLResponseHandler)responseHandler {
    return [self requestURLPath:urlPath standbyURLPath:nil withParams:params responseHandler:responseHandler];
}

- (BOOL)requestURLPath:(NSString *)urlPath standbyURLPath:(NSString *)standbyUrlPath withParams:(NSDictionary *)params responseHandler:(QBURLResponseHandler)responseHandler {
    if (standbyUrlPath) {
        //备用静态文件链接后加时间戳
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
        standbyUrlPath = [NSString stringWithFormat:@"%@?t=%@",standbyUrlPath,timeString];
    }
    return [super requestURLPath:urlPath standbyURLPath:standbyUrlPath withParams:[self encryptWithParams:params] responseHandler:responseHandler];
}

- (id)decryptResponse:(id)encryptedResponse {
    if (self.configuration.encryptedType == QBURLEncryptedTypeOriginal) {
        if (![encryptedResponse isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        NSDictionary *originalResponse = (NSDictionary *)encryptedResponse;
        NSArray *keys = [originalResponse objectForKey:kEncryptionKeyName];
        NSString *dataString = [originalResponse objectForKey:kEncryptionDataName];
        if (!keys || !dataString) {
            return nil;
        }
        
        NSString *decryptedString = [dataString decryptedStringWithKeys:keys];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:[decryptedString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if (jsonObject == nil) {
            jsonObject = decryptedString;
        }
        return jsonObject;
    } else if (self.configuration.encryptedType == QBURLEncryptedTypeNew) {
        NSString *str = [[NSString alloc] initWithData:encryptedResponse encoding:NSUTF8StringEncoding];
        str =  [str decryptedString];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        return responseJSON;
    }
}

- (void)processResponseObject:(id)responseObject withResponseHandler:(QBURLResponseHandler)responseHandler {

    if (![responseObject isKindOfClass:[NSDictionary class]] && self.configuration.encryptedType ==  QBURLEncryptedTypeOriginal) {
        [super processResponseObject:nil withResponseHandler:responseHandler];
        return ;
    }
    
    id decryptedResponse = [self decryptResponse:responseObject];

    QBLog(@"Decrypted response: %@", decryptedResponse);
    
    [super processResponseObject:decryptedResponse withResponseHandler:responseHandler];
}
@end
