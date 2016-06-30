//
//  YLSegmentView.h
//  HLLSaasForiPad
//
//  Created by gozap11 on 16/6/13.
//  Copyright © 2016年 Gozap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLSegmentView;

NS_ASSUME_NONNULL_BEGIN

@protocol YLSegmentViewDelegate <NSObject>
- (void)segmentView:(YLSegmentView * __nullable)segmentView didSelectedIndex:(NSUInteger)selectedIndex;
@end

/**
 *  This is a SegmentView
 * @discussion This class supports iOS5 and above,you can create a segmentView like iOS7's style -- flatting.
 
 Example:
 
 YLSegmentView* segmentView = [[YLSegmentView alloc] initWithFrame:aRect items:@[@"spring",@"summer",@"autumn",@"winnter"]];
 
 segmentView.tintColor       = [UIColor orangeColor];
 segmentView.selectedIndex   = 2;
 segmentView.itemHeight      = 30.f;
 segmentView.leftRightMargin = 50.f;
 segmentView.handlder        = ^ (YLSegmentView * __nullable view, NSInteger selectedIndex) {
 // doSomething
 };
 
 [self.view addSubview:segmentView];
 
 Ps:It also support delegate style callback.
 
 */
@interface YLSegmentView : UIView

typedef void (^selectedHandler)(YLSegmentView * __nullable view, NSInteger selectedIndex);

#pragma mark - Accessing the Delegate
///=============================================================================
/// @name Accessing the Delegate
///=============================================================================

@property (nullable, nonatomic, weak) id<YLSegmentViewDelegate> delegate;

#pragma mark - Accessing the BlockHandler
///=============================================================================
/// @name Accessing the BlockHandler
///=============================================================================

@property (nullable, nonatomic, copy) selectedHandler handlder;

#pragma mark - Configuring the Text Attributes
///=============================================================================
/// @name Configuring the Text Attributes
///=============================================================================

@property (nonatomic, assign) CGFloat leftRightMargin; ///< set YLSegmentView left and right margin, default 15.f.
@property (nonatomic, assign) CGFloat itemHeight; ///< set YLSegmentView item height, default 30.f.
@property (nonatomic, assign) CGFloat cornerRadius; ///< set YLSegmentView's cornerRadius, default 3.f.
@property (nonatomic, assign, getter=currentSelectedIndex) NSUInteger selectedIndex; ///< set which item is seltected, default 0.

#pragma mark - Initializer
///=============================================================================
/// @name Initializer
///=============================================================================

/**
 *  Creates an YLSegmentView,designated initializer.
 *
 *  @param frame YLSegmentView's frame.
 *  @param items a array of titles.
 *
 *  @return a YLSegmentView instance, or nil if fail.
 */
- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray<NSString *> * _Nonnull)items
                       colors:( NSDictionary * _Nullable)colors;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
