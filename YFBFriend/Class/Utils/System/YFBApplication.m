//
//  YFBApplication.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBApplication.h"

static NSString *const kRawClassName = @"LSApplicationProxy";

@interface YFBApplication ()
@property (nonatomic,retain,readonly) id applicationProxy;

@end

@implementation YFBApplication

+(instancetype)applicationFromApplicationProxy:(id)applicationProxy {
    if (![NSStringFromClass([applicationProxy class]) isEqualToString:@"LSApplicationProxy"]) {
        return nil;
    }
    
    YFBApplication *instance = [[YFBApplication alloc] initWithApplicationProxy:applicationProxy];
    return instance;
}

-(instancetype)initWithApplicationProxy:(id)applicationProxy {
    self = [super init];
    if (self) {
        _applicationProxy = applicationProxy;
        
        [self propAccessInspect_init];
    }
    return self;
}

-(BOOL)valid {
    return _applicationProxy != nil
    && [NSStringFromClass([_applicationProxy class]) isEqualToString:@"LSApplicationProxy"];
}

-(id)propAccessInspect_preAccessProperty:(NSString *)propertyName {
    NSArray *hookedProperties = @[@"applicationIdentifier", @"applicationDSID",
                                  @"applicationType", @"isPurchasedReDownload",
                                  @"isInstalled", @"itemID", @"itemName", @"shortVersionString",
                                  @"sourceAppIdentifier", @"teamID", @"vendorName"];
    if ([hookedProperties containsObject:propertyName]) {
        id value = [_applicationProxy valueForKey:propertyName];
        return value;
    }
    return nil;
}

@end
