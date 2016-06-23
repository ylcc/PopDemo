//
//  ToolUtils.m
//  jieqianhua
//
//  Created by gozap11 on 15/3/11.
//  Copyright (c) 2015年 gozap. All rights reserved.
//

#import "ToolUtils.h"
#import "AFAppDotNetAPIClient.h"
#import <sys/sysctl.h>

@interface ToolUtils ()

@property (strong, nonatomic) UIWindow *alertView;

@end
@implementation ToolUtils

+ (instancetype)shareToolUtils {
    static ToolUtils *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ToolUtils alloc] init];
    });
    return _sharedClient;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)setObject:(id)value forkey:(NSString*)key;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(value != nil) {
        [userDefaults setObject:value  forKey:key];
        [userDefaults synchronize];
    }
}

- (id)obtainObjectWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

- (void)deleteObjectForKey:(NSString *)key
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

-(UIWindow *) intAlertViewWithFrame:(CGRect) rect message:(NSString *) msg withActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:rect];
    alertWindow.windowLevel = UIWindowLevelAlert;
    alertWindow.backgroundColor = [UIColor colorWithRed:0x00/0xff green:0x00/0xff blue:0x00/0xff alpha:0.5f];
    
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = [UIColor whiteColor];
    if(msg != nil) {
    label.text = msg;
    } else {
        label.text = @"网络错误，请重试";
    }
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    label.frame = CGRectMake(0, 0, rect.size.width, 30);
    label.center = CGPointMake(rect.size.width / 2, rect.size.height / 2 - 15);
    [alertWindow addSubview:label];
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    if(msg) {
        indicator.center = CGPointMake(rect.size.width / 2, rect.size.height / 2 + 15);
    } else {
        indicator.center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    }
    [indicator startAnimating];
    [alertWindow addSubview:indicator];
    return alertWindow;
}

- (void)clearUserData {
    [self deleteObjectForKey:@"access_token"];
    [self deleteObjectForKey:@"GestruePassword"];
    [self deleteObjectForKey:@"userdate"];
    Contants.access_token = nil;
}

- (BOOL) hasLogin {
    if ([self obtainObjectWithKey:@"access_token"]) {
        return YES;
    }
    return NO;
}

- (UIImage *) getImageFromDisk:(NSString *)imageURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[imageURL stringByReplacingOccurrencesOfString:@"/" withString:@""]];
    NSLog(@"getImageFromDisk filePath is %@", filePath);
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    return img;
}

- (void) showErrorMsg:(NSError *) error {
    NSData *errorStr = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    NSLog(@"errorStr == %@", errorStr);
    if(!errorStr) return;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorStr options:NSJSONReadingMutableContainers error:&error];
    if(!dic) return;
    Type_error *typeError = [Type_error setupError:[dic objectForKey:@"error"]];
    if(!typeError) return;
    
    if(![self isBlankString:typeError.message]) {
        [CustomToast showMsg:typeError.message withImage:[UIImage imageNamed:@"overlay_error"] byOrientation:ViewOrientationTop];
    } else {
        [CustomToast showMsg:@"网络错误，请重试" withImage:[UIImage imageNamed:@"overlay_error"] byOrientation:ViewOrientationTop];
    }
}

- (void) showMsg:(NSString *) msg {
    [CustomToast showMsg:msg];
}

- (NSString *) getDateStrByTimestamp:(double) timestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSString *nowtimeStr = [formatter stringFromDate:confromTimesp];
    return nowtimeStr;
}

- (NSString *)getDeviceModel {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

/**
 * 颜色转成图片
 */
+ (UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSMutableDictionary * ) footPointData {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:@"Apple" forKey: @"deviceBrand"];
    [postDic setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey: @"deviceId"];
    [postDic setObject:[[ToolUtils shareToolUtils] getDeviceModel] forKey: @"deviceModel"];
    [postDic setObject:@"iOS" forKey: @"sysPlatform"];
    [postDic setObject:[UIDevice currentDevice].systemVersion forKey: @"sysVersion"];
    [postDic setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey: @"jqhVersion"];
    return postDic;

}
@end