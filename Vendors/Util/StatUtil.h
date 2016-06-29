#import <Foundation/Foundation.h>

NS_ROOT_CLASS
@interface StatUtil
+ (void)StatStart:(NSString *)channeId;
+ (void)StatEvent:(NSString *)event attrs:(NSDictionary *)attrs;
+ (void)StatEvent:(NSString *)event attr1:(NSString *)attr1 attr2:(NSString *)attr2;
+ (void)StatEvent:(NSString *)event attr:(NSString *)attr;
+ (void)StatPageBegin:(NSString *)page;
+ (void)StatPageEnded:(NSString *)page;
+ (void)StatViewLoad:(NSString *)view;
+ (void)StatViewUnLoad:(NSString *)view;
@end
