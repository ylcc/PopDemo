#import "StatUtil.h"

@implementation StatUtil

+ (void)StatStart:(NSString *)channeId{
#ifdef kAppStatKey
	[MobClick startWithAppkey:kAppStatKey reportPolicy:BATCH channelId:channeId];
#endif
}
+ (void)StatEvent:(NSString *)event attrs:(NSDictionary *)attrs{
#ifdef kAppStatKey
	if (attrs) [MobClick event:event attributes:attrs];
	else [MobClick event:event];
#endif
}
+ (void)StatEvent:(NSString *)event attr1:(NSString *)attr1 attr2:(NSString *)attr2{
#ifdef kAppStatKey
	NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:attr1, @"u", attr2, @"a", nil];
    [StatUtil StatEvent:event,attrs];
#endif
}
+ (void)StatEvent:(NSString *)event attr:(NSString *)attr
{
#ifdef kAppStatKey
	NSDictionary *attrs = [NSDictionary dictionaryWithObject:attr forKey:@"u"];
	[StatUtil StatEvent:event,attrs];
#endif
}

+ (void)StatViewLoad:(NSString *)view
{
	NSLog(@"Load Page: %@", view);
}
+ (void)StatViewUnLoad:(NSString *)view{
	NSLog(@"UnLoad Page: %@", view);
}

+ (void)StatPageBegin:(NSString *)page
{
#ifdef kAppStatKey
	[MobClick beginLogPageView:page];
#endif
	NSLog(@"Enter Page: %@", page);
}
+ (void)StatPageEnded:(NSString *)page{
	NSLog(@"Leave Page: %@", page);
#ifdef kAppStatKey
	[MobClick endLogPageView:page];
#endif
}

@end
