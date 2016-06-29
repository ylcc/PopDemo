#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

//
@interface UIDevice (UDID)
- (NSString *)uniqueIdentifier;
@end

//
@class AppDelegate;

//
NS_ROOT_CLASS
@interface UIUtil

#pragma mark Device methods
+ (UIDevice *)Device;
+ (NSString *)DeviceID;
+ (float)SystemVersion;
+ (BOOL)IsPad;
+ (BOOL)IsRetina;
+ (BOOL)IsPhone5;
+ (BOOL)IsOS7;
+ (UIScreen *)Screen;
+ (CGFloat)ScreenScale;
+ (CGRect)AppFrame;
+ (CGSize)ScreenSize;
+ (CGRect)ScreenBounds;

#pragma mark Application methods
+ (UIApplication *)Application;
+ (AppDelegate *)Delegate;
+ (UIViewController *)RootViewController;
+ (UIViewController *)FrontViewController;
+ (UIViewController *)VisibleViewController;
+ (BOOL)CanOpenUrl:(NSString *)url;
+ (BOOL)OpenUrl:(NSString *)url;
+ (BOOL)MakeCall:(NSString *)number direct:(BOOL)direct;
+ (UIWindow *)KeyWindow;
+ (BOOL)IsWindowLandscape;
+ (BOOL)IsKeyboardInDisplay;
+ (void)ShowStatusBar:(BOOL)show animated:(UIStatusBarAnimation)animated;
+ (void)ShowNetworkIndicator:(BOOL)show;
+ (UIImageView *)ShowSplashView:(UIView *)fadeInView duration:(CGFloat)duration;

#pragma mark Misc methods
+ (UIImage *)Image:(NSString *)file;
+ (UIImage *)ImageNamed:(NSString *)name;
+ (UIImage *)ImageNamed2X:(NSString *)name;
+ (UIColor *)ColorWithHexString:(NSString *)code;
+ (UIColor *)ColorWithInt:(NSUInteger)rgbt;
+ (UIColor *)ColorRGBA:(unsigned char)r g:(unsigned char)g b:(unsigned char)b a:(CGFloat)a;
+ (CGSize)sizeOfString:(NSAttributedString *)str width:(float)width;
+ (CGSize)sizeOfString:(NSString *)str font:(UIFont *)font width:(float)width;
+ (CGSize)sizeOfString:(NSString *)str font:(UIFont *)font width:(float)width height:(float)height;
+ (CGSize)constrictImgViewSize:(float)width height:(float)height maxWidth:(float)maxWidth;
+ (CGSize)constrictImgSize:(float)width height:(float)height maxWidth:(float)maxWidth;

#pragma mark Debug methods
+ (void)PrintRect:(CGRect)rect;
+ (void)ShowBorder:(id)view;
+ (void)PrintIndentString:(NSUInteger)indent str:(NSString *)str;
+ (void)PrintController:(UIViewController *)controller indent:(NSUInteger)indent;
+ (void)PrintView:(UIView *)view indent:(NSUInteger)indent;
+ (BOOL)NormalizePngFile:(NSString *)dst src:(NSString *)src;
+ (void)NormalizePngFolder:(NSString *)dst src:(NSString *)src;
@end




