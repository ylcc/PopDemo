
#import "UIUtil.h"

static NSUInteger _networkIndicatorRef = 0;

@implementation UIUtil
#pragma mark Device methods
+ (UIDevice *)Device{
    return [UIDevice currentDevice];
}

+ (NSString *)DeviceID{
    if ([[UIUtil Device] respondsToSelector:@selector(identifierForVendor)])
    {
        return [UIUtil Device].identifierForVendor.UUIDString;
    }
    return [[UIUtil Device] uniqueIdentifier];
}

+ (float)SystemVersion{
    return [[[UIUtil Device] systemVersion] floatValue];
}

+ (BOOL)IsPad{
    return [[UIUtil Device] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

+ (BOOL)IsRetina{
    return [UIUtil ScreenScale] == 2;
}

+ (BOOL)IsPhone5{
    return [UIUtil ScreenBounds].size.height > 480;
}

+ (BOOL)IsOS7{
    return [UIUtil SystemVersion] >= 7.0;
}

+ (UIScreen *)Screen{
    return [UIScreen mainScreen];
}

+ (CGFloat)ScreenScale{
    return [UIUtil Screen].scale;
}

+ (CGRect)AppFrame{
    return [UIUtil Screen].applicationFrame;
}

+ (CGSize)ScreenSize{
    CGRect frame = [UIUtil AppFrame];
    return CGSizeMake(frame.size.width, frame.size.height + frame.origin.y);
}

+ (CGRect)ScreenBounds{
    return [UIUtil Screen].bounds;
}

#pragma mark Application methods

+ (UIApplication *)Application{
    return UIApplication.sharedApplication;
}

+ (AppDelegate *)Delegate{
    return (AppDelegate *)[UIUtil Application].delegate;
}

+ (UIViewController *)RootViewController{
    return UIApplication.sharedApplication.delegate.window.rootViewController;
}

+ (UIViewController *)FrontViewController{
    UIViewController *controller = [UIUtil RootViewController];
    UIViewController *presented = controller.presentedViewController;
    return presented ? presented : controller;
}

+ (UIViewController *)VisibleViewController{
    UIViewController *controller = [UIUtil FrontViewController];
    while (YES)
    {
        if ([controller isKindOfClass:[UINavigationController class]])
        {
            controller = ((UINavigationController *)controller).visibleViewController;
        }
        else if ([controller isKindOfClass:[UITabBarController class]])
        {
            controller = ((UITabBarController *)controller).selectedViewController;
        }
        else
        {
            return controller;
        }
    }
}

+ (BOOL) CanOpenUrl:(NSString *)url{
    return [[UIUtil Application] canOpenURL:[NSURL URLWithString:url]];
}

+ (BOOL) OpenUrl:(NSString *)url{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL ret = [[UIUtil Application] openURL:[NSURL URLWithString:url]];
    if (ret == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not open", @"无法打开")
                                                            message:url
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Dismiss", @"关闭")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    return ret;
}

+ (BOOL)MakeCall:(NSString *)number direct:(BOOL)direct{
    NSString *url = [NSString stringWithFormat:(direct ? @"tel://%@" : @"telprompt://%@"), [number stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *URL = [NSURL URLWithString:url];
    
    BOOL ret = [[UIUtil Application] openURL:URL];
    if (ret == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not make call", @"无法拨打电话")
                                                            message:number
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Dismiss", @"关闭")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    return ret;
}

+ (UIWindow *)KeyWindow{
    return [UIUtil Application].keyWindow;
}

+ (BOOL)IsWindowLandscape{
    CGSize size = [UIUtil KeyWindow].frame.size;
    return size.width > size.height;
}

+ (BOOL)IsKeyboardInDisplay{
    Class keyboardClass = NSClassFromString(@"UIPeripheralHostView");
    for (UIWindow *window in [UIUtil Application].windows)
    {
        for (UIView *subview in window.subviews )
        {
            if ([subview isKindOfClass:keyboardClass])
            {
                return YES;
            }
        }
    }
    return NO;
}

+ (void)ShowStatusBar:(BOOL)show animated:(UIStatusBarAnimation)animated{
    [[UIUtil Application] setStatusBarHidden:!show withAnimation:animated];
}

+ (void)ShowNetworkIndicator:(BOOL)show{
    if (show)
    {
        if (_networkIndicatorRef == 0) [UIUtil Application].networkActivityIndicatorVisible = YES;
        _networkIndicatorRef++;
    }
    else
    {
        if (_networkIndicatorRef != 0) _networkIndicatorRef--;
        if (_networkIndicatorRef == 0) [UIUtil Application].networkActivityIndicatorVisible = NO;
    }
}

+ (UIImageView *)ShowSplashView:(UIView *)fadeInView duration:(CGFloat)duration{
	//
	CGRect frame = [UIUtil ScreenBounds];
	UIImageView *splashView = [[UIImageView alloc] initWithFrame:frame];
	splashView.image = [UIImage imageNamed:[UIUtil IsPad]? @"Default@iPad.png" : [UIUtil IsPhone5] ? @"Default-568h.png" : @"Default.png"];
	splashView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[[UIUtil KeyWindow] addSubview:splashView];
    
	//
	//UIImage *logoImage = [UIImage imageWithContentsOfFile:NSUtil::BundlePath(UIUtil::IsPad() ? @"Splash@2x.png" : @"Splash.png")];
	//UIImageView *logoView = [[[UIImageView alloc] initWithImage:logoImage] autorelease];
	//logoView.center = CGPointMake(frame.size.width / 2, (frame.size.height / 2));
	//logoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	//splashView.tag = (NSInteger)logoView;
	//[splashView addSubview:logoView];
    
	//
	fadeInView.alpha = 0;
	
	[UIView animateWithDuration:duration animations:^()
	 {
		 //
		 fadeInView.alpha = 1;
		 splashView.alpha = 0;
		 //splashView.frame = CGRectInset(frame, -frame.size.width / 2, -frame.size.height / 2);
		 //splashView.frame = CGRectInset(frame, frame.size.width / 2, frame.size.height / 2);
	 } completion:^(BOOL finished)
	 {
		 [splashView removeFromSuperview];
	 }];
    
	return splashView;
}

#pragma mark Misc methods

+ (UIImage *)Image:(NSString *)file{
#ifdef _UncacheImage
    // 支持无 @1x 时使用
    if (![file hasPrefix:@".png"]) file = [file stringByAppendingString:@"@2x.png"];
    return [UIImage imageWithContentsOfFile:NSUtil::AssetPath(file)];
#else
    return [UIUtil ImageNamed:file];
#endif
}

+ (UIImage *)ImageNamed:(NSString *)name{
#ifdef kAssetBundle
    name = [kAssetBundle stringByAppendingPathComponent:name];
#endif
    return [UIImage imageNamed:name];
}

+ (UIImage *)ImageNamed2X:(NSString *)name{
    return [UIUtil ImageNamed:[name stringByAppendingString:[UIUtil IsPad] ? @"@2x.png" : @".png"]];
}

#define DEFAULT_VOID_COLOR  [UIColor colorWithRed:49/255 green:186/255 blue:138/255 alpha:1.0]
+ (UIColor *)ColorWithHexString:(NSString *)code{
    NSString *cString = [[code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)ColorWithInt:(NSUInteger)rgbt{
    NSUInteger transparent = (rgbt & 0xFF000000) >> 24;
    NSUInteger alpha = 0xFF - transparent;
    return [UIColor colorWithRed:((rgbt & 0x00FF0000) >> 16) / 255.0
                           green:((rgbt & 0x0000FF00) >> 8) / 255.0
                            blue:((rgbt & 0x000000FF)) / 255.0
                           alpha:alpha / 255.0];
}

+ (UIColor *)ColorRGBA:(unsigned char)r g:(unsigned char)g b:(unsigned char)b a:(CGFloat)a{
    return [UIColor colorWithRed:r / 255.0
                           green:g / 255.0
                            blue:b / 255.0
                           alpha:a];
}

+ (CGSize)sizeOfString:(NSAttributedString *)str width:(float)width{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}

+ (CGSize)sizeOfString:(NSString *)str font:(UIFont *)font width:(float)width{
    NSString *aLabelTextString = str;
    UIFont *aLabelFont = font;
    CGFloat aLabelSizeWidth = width;
    if (str&&[str length] > 0) {
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
            //version < 7.0
            return [aLabelTextString sizeWithFont:aLabelFont
                                constrainedToSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        }
        else{
            //version >= 7.0
            //Return the calculated size of the Label
            return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{
                                                            NSFontAttributeName : aLabelFont
                                                            }
                                                  context:nil].size;
        }
    }
    return CGSizeZero;
}

+ (CGSize)sizeOfString:(NSString *)str font:(UIFont *)font width:(float)width height:(float)height{
    NSString *aLabelTextString = str;
    UIFont *aLabelFont = font;
    CGFloat aLabelSizeWidth = width;
    if (str&&[str length] > 0) {
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
            //version < 7.0
            return [aLabelTextString sizeWithFont:aLabelFont
                                constrainedToSize:CGSizeMake(aLabelSizeWidth, height)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        }
        else{
            //version >= 7.0
            //Return the calculated size of the Label
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize labelSize = [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, height)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:attributes
                                                              context:nil].size;
            labelSize.height = ceil(labelSize.height);
            labelSize.width = ceil(labelSize.width);
            
            return labelSize;
        }
    }
    
    return CGSizeZero;
}

+ (CGSize)constrictImgViewSize:(float)width height:(float)height maxWidth:(float)maxWidth{
    float resultWidth = 0.0f;
    float resultHeight = 0.0f;
    if (width/2 < maxWidth) {
        resultWidth = width/2;
        resultHeight = height/2;
    }else{
        resultWidth = maxWidth;
        float ratio = maxWidth/(width/2);
        resultHeight = height/2*ratio;
    }
    return CGSizeMake(resultWidth, resultHeight);
}

+ (CGSize)constrictImgSize:(float)width height:(float)height maxWidth:(float)maxWidth{
    float resultWidth = 0.0f;
    float resultHeight = 0.0f;
    if (width < maxWidth) {
        resultWidth = width;
        resultHeight = height;
    }else{
        resultWidth = maxWidth;
        float ratio = maxWidth/width;
        resultHeight = height*ratio;
    }
    return CGSizeMake(resultWidth, resultHeight);
}

#pragma mark Debug methods
+ (void)PrintRect:(CGRect)rect{
    //_Log(@"rect:[%f,%f,%f,%f]", rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}

+ (void)ShowBorder:(id)view{
    if([view isKindOfClass:[UIView class]]){
        UIView *v = (UIView *)view;
        v.layer.borderWidth = 1;
        v.layer.borderColor = [UIColor greenColor].CGColor;
    }
}

+ (void)PrintIndentString:(NSUInteger)indent str:(NSString *)str{
	NSString *log = @"";
	for (NSUInteger i = 0; i < indent; i++)
	{
		log = [log stringByAppendingString:@"\t"];
	}
	log = [log stringByAppendingString:str];
	NSLog(@"%@", log);
}

+ (void)PrintController:(UIViewController *)controller indent:(NSUInteger)indent{
    [UIUtil PrintIndentString:indent str:[NSString stringWithFormat:@"<Controller Description=\"%@\">", [controller description]]];
	if (controller.presentedViewController)
	{
        [UIUtil PrintController:controller indent:indent + 1];
	}
	
	if ([controller isKindOfClass:[UINavigationController class]])
	{
		for (UIViewController *child in ((UINavigationController *)controller).viewControllers)
		{
            [UIUtil PrintController:child indent:indent + 1];
		}
	}
	else if ([controller isKindOfClass:[UITabBarController class]])
	{
		UITabBarController *tabBarController = (UITabBarController *)controller;
		for (UIViewController *child in tabBarController.viewControllers)
		{
			[UIUtil PrintController:child indent:indent + 1];
		}
        
		if (tabBarController.moreNavigationController)
		{
            [UIUtil PrintController:tabBarController.moreNavigationController indent:indent + 1];
		}
	}
    
    [UIUtil PrintIndentString:indent str:@"</Controller>"];
}

+ (void)PrintView:(UIView *)view indent:(NSUInteger)indent{
    [UIUtil PrintIndentString:indent str:[NSString stringWithFormat:@"<View Description=\"%@\">", [view description]]];
    
	for (UIView *child in view.subviews)
	{
        [UIUtil PrintView:child indent:indent + 1];
	}
	
    [UIUtil PrintIndentString:indent str:@"</View>"];
}

+ (BOOL)NormalizePngFile:(NSString *)dst src:(NSString *)src{
	NSString *dir = dst.stringByDeletingLastPathComponent;
	if ([[NSFileManager defaultManager] fileExistsAtPath:dir] == NO)
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	UIImage *image = [UIImage imageWithContentsOfFile:src];
	if (image == nil) return NO;
	
	NSData *data = UIImagePNGRepresentation(image);
	if (data == nil) return NO;
	
	return [data writeToFile:dst atomically:NO];
}

+ (void)NormalizePngFolder:(NSString *)dst src:(NSString *)src{
	NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:src];
	for (NSString *file in files)
	{
		if ([file.lowercaseString hasSuffix:@".png"])
		{
            [UIUtil NormalizePngFile:[dst stringByAppendingPathComponent:file] src:[src stringByAppendingPathComponent:file]];
		}
	}
}
@end
