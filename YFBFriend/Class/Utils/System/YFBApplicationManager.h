//
//  YFBApplicationManager.h
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFBApplication.h"

@interface YFBApplicationManager : NSObject

+(instancetype)defaultManager;
-(instancetype)initWithApplicationWorkspace:(id)appWorkspace;

-(NSArray *)allApplications;
-(NSArray *)allInstalledApplications;

-(NSArray *)allApplicationIdentifiers;
-(NSArray *)allInstalledAppIdentifiers;

@end
