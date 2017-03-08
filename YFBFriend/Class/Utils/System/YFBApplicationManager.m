//
//  YFBApplicationManager.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBApplicationManager.h"
#import <objc/runtime.h>

#define SafelyPerformSelector(instance, sel, ret) \
if (instance && sel && [instance respondsToSelector:sel]) { \
ret = [instance performSelector:sel]; \
}

@interface YFBApplicationManager ()
@property (nonatomic,readonly,retain) id applicationWorkspace;

-(NSArray *)wrappedApplicationsFromRawApplications:(NSArray *)rawApps;
@end

@implementation YFBApplicationManager
+(instancetype)defaultManager {
    static YFBApplicationManager *defaultManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
        if (!LSApplicationWorkspace_class) {
            return;
        }
        NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
        defaultManager = [[YFBApplicationManager alloc] initWithApplicationWorkspace:workspace];
#pragma clang diagnostic pop
    });
    return defaultManager;
}

-(instancetype)initWithApplicationWorkspace:(id)appWorkspace {
    self = [super init];
    if (self) {
        _applicationWorkspace = appWorkspace;
    }
    return self;
}

-(NSArray *)wrappedApplicationsFromRawApplications:(NSArray *)rawApps {
    if (!rawApps) {
        return nil;
    }
    
    NSMutableArray *wrappedApps = [NSMutableArray array];
    for (id rawApp in rawApps) {
        YFBApplication *wrappedApp = [YFBApplication applicationFromApplicationProxy:rawApp];
        if (wrappedApp) {
            [wrappedApps addObject:wrappedApp];
        }
    }
    return wrappedApps.count > 0 ? wrappedApps : nil;
}

-(NSArray *)allApplications {
    NSArray *rawApps;
    SafelyPerformSelector(_applicationWorkspace, @selector(allApplications), rawApps);
    return [self wrappedApplicationsFromRawApplications:rawApps];
}

-(NSArray *)allInstalledApplications {
    NSArray *rawApps;
    SafelyPerformSelector(_applicationWorkspace, @selector(allInstalledApplications), rawApps);
    return [self wrappedApplicationsFromRawApplications:rawApps];
}

-(NSArray *)allApplicationIdentifiers {
    NSMutableArray *appIds = [NSMutableArray array];
    NSArray *allApplications = [self allApplications];
    for (YFBApplication *application in allApplications) {
        [appIds addObject:application.applicationIdentifier];
    }
    return appIds.count > 0 ? appIds : nil;
}

-(NSArray *)allInstalledAppIdentifiers {
    NSMutableArray *appIds = [NSMutableArray array];
    NSArray *allInstalledApps = [self allInstalledApplications];
    for (YFBApplication *app in allInstalledApps) {
        [appIds addObject:app.applicationIdentifier];
    }
    return appIds.count > 0 ? appIds : nil;
}


@end
