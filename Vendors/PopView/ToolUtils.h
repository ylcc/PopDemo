//
//  ToolUtils.h
//  jieqianhua
//
//  Created by gozap11 on 15/3/11.
//  Copyright (c) 2015年 gozap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Type_user.h"

@interface ToolUtils : NSObject

+ (instancetype)shareToolUtils;

- (BOOL) isBlankString:(NSString *)string;
- (void)setObject:(id)value forkey:(NSString *)key;
- (id) obtainObjectWithKey:(NSString *)key;
- (void)deleteObjectForKey:(NSString *)key;
- (void)clearUserData;

- (UIWindow *) intAlertViewWithFrame:(CGRect) rect message:(NSString *) msg withActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;

- (BOOL) hasLogin;
- (UIImage *) getImageFromDisk:(NSString *)imageURL;
- (NSString *) getDateStrByTimestamp:(double) timestamp;

/**
 * 显示请求错误信息
 */
- (void) showErrorMsg:(NSError *) error;
- (void) showMsg:(NSString *) msg;

- (NSString *)getDeviceModel;

/**
 * 颜色转成图片
 */
+(UIImage *) createImageWithColor:(UIColor*) color;

/**
 * 用户足迹数据
 */
+ (NSMutableDictionary * ) footPointData;
@end
