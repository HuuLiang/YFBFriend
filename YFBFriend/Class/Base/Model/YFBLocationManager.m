//
//  YFBLocationManager.m
//  YFBFriend
//
//  Created by Liang on 2017/5/24.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "YFBLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation YFBLocationModel

@end



@interface YFBLocationManager () <CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic) CLLocation *location;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end

@implementation YFBLocationManager

+ (instancetype)manager {
    static YFBLocationManager *_locationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationManager = [[YFBLocationManager alloc] init];
    });
    return _locationManager;
}

- (void)loadLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

}

- (BOOL)checkLocationIsEnable {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse;
}

- (void)getUserLacationNameWithUserId:(NSString *)userId locationName:(void (^)(BOOL success,NSString *))handler {
    if (!self.location) {
        handler(NO,nil);
    }
    
    __block YFBLocationModel *locationModel = [YFBLocationModel findFirstByCriteria:[NSString stringWithFormat:@"where userId=\'%@\'",userId]];
    if (!locationModel) {
        [self getNearLocationName:^(NSString *locationName) {
            locationModel = [[YFBLocationModel alloc] init];
            locationModel.userId = userId;
            locationModel.locationName = locationName;
            locationModel.locationTime = [[NSDate date] timeIntervalSince1970];
            [locationModel saveOrUpdate];
            
            handler(YES,locationModel.locationName);
        }];
    } else {
        if ([[NSDate dateWithTimeIntervalSince1970:locationModel.locationTime] isToday]) {
            handler(YES,locationModel.locationName);
        } else {
            [self getNearLocationName:^(NSString *locationName) {
                locationModel.locationName = locationName;
                locationModel.locationTime = [[NSDate date] timeIntervalSince1970];
                [locationModel saveOrUpdate];
                handler(YES,locationModel.locationName);
            }];
        }
    }
}

- (void)getNearLocationName:(void(^)(NSString * locationName))handler {
    double randomLatitude = ((arc4random() % 2 == 1) ? -1 : 1) * (double)(arc4random() % 70 + 30) * 0.0001;
    double randomLongitude = ((arc4random() % 2 == 1) ? -1 : 1) * (double)(arc4random() % 70 + 30) * 0.0001;
    
    CLLocationDegrees latitude  = self.coordinate.latitude  + randomLatitude;
    CLLocationDegrees longitude = self.coordinate.longitude + randomLongitude;
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//    double dis = [self.location distanceFromLocation:newLocation];
    
    [self getLocationNameWithLocationWihtNewLacation:newLocation locationName:^(NSString *locationName) {
        handler(locationName);
    }];
}

- (void)getLocationNameWithLocationWihtNewLacation:(CLLocation *)newLocation locationName:(void(^)(NSString *locationName))handler {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            QBLog(@"placemark = %@",placemark.name);
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSString *nameStr = [NSString stringWithFormat:@"%@%@",city,placemark.name];
            handler(nameStr);
            NSLog(@"city = %@", city);
        } else if (error == nil && [array count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

#pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    self.location = [locations lastObject];
    self.coordinate = self.location.coordinate;
    NSLog(@"纬度:%f 经度:%f", _coordinate.latitude, _coordinate.longitude);
    
    // 2.停止定位
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    QBLog(@"%ld",error.code);
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

@end
