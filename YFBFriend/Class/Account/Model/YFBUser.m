//
//  YFBUser.m
//  YFBFriend
//
//  Created by Liang on 2017/3/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBUser.h"

static YFBUser *_currentUser;

static NSString *const kYFBFriendCurrentUserKeyName      = @"kYFBFriendCurrentUserKeyName";
static NSString *const kYFBFriendCurrentUserIdKeyName    = @"kYFBFriendCurrentUserIdKeyName";

@implementation YFBUser

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kYFBFriendCurrentUserKeyName]];
        if (!_currentUser) {
            _currentUser = [[YFBUser alloc] init];
        }
    });
    return _currentUser;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.userId = [coder decodeObjectForKey:kYFBFriendCurrentUserIdKeyName];;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userId forKey:kYFBFriendCurrentUserIdKeyName];
}

- (void)saveOrUpdate {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kYFBFriendCurrentUserKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




#pragma mark - 用户注册信息选择

+ (NSArray *)allUserJob {
    return @[@"在校学生",@"军人",@"私营业主",@"企业职工",@"农业劳动者",@"政府机关／事业单位工作者",@"其他"];
}

+ (NSArray *)allUserEdu {
    return @[@"初中及以下",@"高中及中专",@"大专",@"本科",@"硕士及以上"];
}

+ (NSArray *)allUserIncome {
    return @[@"小于2000",@"2000-5000",@"5000-10000",@"10000-20000",@"20000以上"];
}

+ (NSArray *)allUserHeight {
    NSMutableArray *allHeights = [NSMutableArray array];
    for (NSInteger height = 150; height <= 190; height++) {
        NSString *str = [NSString stringWithFormat:@"%ldcm",(long)height];
        [allHeights addObject:str];
    }
    return allHeights;
}

+ (NSArray *)allUserMarr {
    return @[@"未婚",@"离异",@"丧偶"];
}

@end
