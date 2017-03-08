//
//  YFBSystemConfigModel.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBSystemConfigModel.h"

static NSString *const kPPVideoSystemConfigPayMonthKeyName       = @"PP_SystemConfigPayAmount_KeyName";
static NSString *const kPPVideoSystemConfigPayQuarterKeyName     = @"PP_SystemConfigPayzsAmount_KeyName";
static NSString *const kPPVideoSystemConfigPayYearKeyName     = @"PP_SystemConfigPayhjAmount_KeyName";

@implementation YFBSystemConfigResponse

- (Class)configsElementClass {
    return [YFBSystemConfig class];
}

@end

@implementation YFBSystemConfigModel

+ (instancetype)sharedModel {
    static YFBSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[YFBSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [YFBSystemConfigResponse class];
}

- (QBURLRequestMethod)requestMethod {
    
    return QBURLPostRequest;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.vipPriceA = [[coder decodeObjectForKey:kPPVideoSystemConfigPayMonthKeyName] integerValue];
        self.vipPriceB = [[coder decodeObjectForKey:kPPVideoSystemConfigPayQuarterKeyName] integerValue];
        self.vipPriceC = [[coder decodeObjectForKey:kPPVideoSystemConfigPayYearKeyName] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.vipPriceA] forKey:kPPVideoSystemConfigPayMonthKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.vipPriceB] forKey:kPPVideoSystemConfigPayQuarterKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.vipPriceC] forKey:kPPVideoSystemConfigPayYearKeyName];
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(YFBFetchSystemConfigCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:YFB_SYSTEM_CONFIG_URL
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        if (respStatus == QBURLResponseSuccess) {
                            YFBSystemConfigResponse *resp = self.response;
                            
                            [resp.configs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                YFBSystemConfig *config = obj;
                                
                                if ([config.name isEqualToString:YFB_SYSTEM_IMAGE_TOKEN]) {
                                    [YFBSystemConfigModel sharedModel].imageToken = config.value;
                                } else if ([config.name isEqualToString:YFB_SYSTEM_PAYPOINT_INFO]) {
                                    [[config.value componentsSeparatedByString:@"|"] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        NSArray *array = [obj componentsSeparatedByString:@":"];
                                        if (idx == 0) {
                                            [YFBSystemConfigModel sharedModel].vipMonthA = [[array lastObject] integerValue];
                                            [YFBSystemConfigModel sharedModel].vipPriceA = [[array firstObject] integerValue];
                                        } else if (idx == 1) {
                                            [YFBSystemConfigModel sharedModel].vipMonthB = [[array lastObject] integerValue];
                                            [YFBSystemConfigModel sharedModel].vipPriceB = [[array firstObject] integerValue];
                                        } else if (idx == 2) {
                                            [YFBSystemConfigModel sharedModel].vipMonthC = [[array lastObject] integerValue];
                                            [YFBSystemConfigModel sharedModel].vipPriceC = [[array firstObject] integerValue];
                                        }
                                    }];
                                }
                            }];
                            _loaded = YES;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess);
                        }
                    }];
    return success;
}

@end
