//
//  YLSegmentView.m
//  HLLSaasForiPad
//
//  Created by gozap11 on 16/6/13.
//  Copyright © 2016年 Gozap. All rights reserved.
//

#import "YLSegmentView.h"
#import "UIUtil.h"

#define RGB(r,g,b)    RGBA(r,g,b,1)
#define RGBA(r,g,b,a) ([UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:a])
#define kDefaultTintColor       RGB(3, 116, 255)
#define KDefaultCornerRadius    3.f
#define kLeftRightMargin        0
#define kBorderLineWidth        1
#define kTitleSize              ([UIFont systemFontOfSize:14])

@class YLSegmentItem;
@protocol YLSegmentItemDelegate

- (void)ItemStateChanged:(YLSegmentItem *)item index:(NSInteger)index isSelected:(BOOL)isSelected;
@end

#pragma mark - YLSegmentItem
@interface YLSegmentItem : UIView

@property (nonatomic, strong) UIColor   *norColor;
@property (nonatomic, strong) UIColor   *selColor;
@property (nonatomic, strong) UIColor   *norTextColor;
@property (nonatomic, strong) UIColor   *selTextColor;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL      isSelected;
@property (nonatomic, assign) id        delegate;
@end

@implementation YLSegmentItem
- (id)initWithFrame:(CGRect)frame
              index:(NSInteger)index
              title:(NSString *)title
           norColor:(UIColor *)norColor
           selColor:(UIColor *)selColor
         isSelected:(BOOL)isSelected;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font            = kTitleSize;
        [self addSubview:_titleLabel];
        
        _norColor        = norColor;
        _selColor        = selColor;
        _titleLabel.text = title;
        _index           = index;
        _isSelected      = isSelected;
        self.layer.borderWidth = kBorderLineWidth;
        self.layer.borderColor = [UIUtil ColorWithHexString:@"abb7c6"].CGColor;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.titleLabel.frame = self.bounds;
}

- (void)setSelColor:(UIColor *)selColor
{
    if (_selColor != selColor) {
        _selColor = selColor;
        
        if (_isSelected) {
            self.titleLabel.textColor = self.selTextColor;
            self.backgroundColor      = self.selColor;
            self.layer.borderColor = [UIUtil ColorWithHexString:@"b4784c"].CGColor;
        } else {
            self.titleLabel.textColor = self.norTextColor;
            self.backgroundColor      = self.norColor;
            self.layer.borderColor = [UIUtil ColorWithHexString:@"abb7c6"].CGColor;
        }
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if (_isSelected) {
        self.titleLabel.textColor = self.selTextColor;
        self.backgroundColor      = self.selColor;
        self.layer.borderColor = [UIUtil ColorWithHexString:@"b4784c"].CGColor;
        [self.superview bringSubviewToFront:self];
    } else {
        self.titleLabel.textColor = self.norTextColor;
        self.backgroundColor      = self.norColor;
        self.layer.borderColor = [UIUtil ColorWithHexString:@"abb7c6"].CGColor;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.isSelected = !_isSelected;
    
    if (_delegate) {
        [_delegate ItemStateChanged:self index:self.index isSelected:self.isSelected];
    }
}

@end

#pragma mark - YLSegmentView

@interface YLSegmentView()

@property (nonatomic, strong) UIView         *bgView;
@property (nonatomic, strong) NSArray        *titles;
@property (nonatomic, strong) NSMutableArray *items;
//@property (nonatomic, strong) NSMutableArray *lines;
@end

@implementation YLSegmentView

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray<NSString *> * _Nonnull)items
                     norColor:(UIColor *)norColor
                     selColor:(UIColor *)selColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.norColor = norColor;
        self.selColor = selColor;
        if (items.count >= 2) {
            NSAssert(items.count >= 2, @"items's cout at least 2!please check!");
            _titles              = items;
            _selectedIndex       = 0;
            self.backgroundColor = [UIColor clearColor];
            
            _itemHeight = frame.size.height;
            //
            _bgView = [[UIView alloc] init];
            _bgView.backgroundColor    = [UIColor clearColor];
            //            _bgView.clipsToBounds      = YES;
            //            _bgView.layer.cornerRadius = KDefaultCornerRadius;
            //            _bgView.layer.borderWidth  = 0;
            //            _bgView.layer.borderColor = [UIUtil ColorWithHexString:@"abb7c6"].CGColor;
            
            [self addSubview:_bgView];
            
            
            NSInteger count = _titles.count;
            for (NSInteger i = 0; i < count; i++) {
                
                YLSegmentItem *item = [[YLSegmentItem alloc] initWithFrame:CGRectZero
                                                                     index:i
                                                                     title:items[i]
                                                                  norColor:self.norColor ? self.norColor : [UIColor whiteColor]
                                                                  selColor:self.selColor ? self.selColor : kDefaultTintColor
                                                                isSelected:(i == 0)? YES: NO];
                
                [_bgView addSubview:item];
                item.delegate = self;
                
                //save all items
                if (!self.items) {
                    self.items = [[NSMutableArray alloc] initWithCapacity:count];
                }
                [_items addObject:item];
            }
            
            //            //add Ver lines
            //            for (NSInteger i = 0; i < count - 1; i++) {
            //                UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
            //                lineView.backgroundColor = kDefaultTintColor;
            //
            //                [_bgView addSubview:lineView];
            //
            //                //save all lines
            //                if (!self.lines) {
            //                    self.lines = [[NSMutableArray alloc] initWithCapacity:count];
            //                }
            //                [_lines addObject:lineView];
            //            }
        } else {
            _titles              = items;
            _selectedIndex       = 0;
            self.backgroundColor = [UIColor clearColor];
            
            //
            _bgView = [[UIView alloc] init];
            _bgView.backgroundColor    = [UIColor clearColor];
            //            _bgView.clipsToBounds      = YES;
            //            _bgView.layer.cornerRadius = KDefaultCornerRadius;
            //            _bgView.layer.borderWidth  = kBorderLineWidth;
            //            _bgView.layer.borderColor  = kDefaultTintColor.CGColor;
            
            [self addSubview:_bgView];
            
            
            NSInteger count = _titles.count;
            for (NSInteger i = 0; i < count; i++) {
                YLSegmentItem *item = [[YLSegmentItem alloc] initWithFrame:CGRectZero
                                                                     index:i
                                                                     title:items[i]
                                                                  norColor:self.norColor ? self.norColor : [UIColor whiteColor]
                                                                  selColor:self.selColor ? self.selColor : kDefaultTintColor
                                                                isSelected:(i == 0)? YES: NO];
                item.layer.masksToBounds = YES;
                item.layer.cornerRadius = KDefaultCornerRadius;
                [_bgView addSubview:item];
                item.delegate = self;
                
                //save all items
                if (!self.items) {
                    self.items = [[NSMutableArray alloc] initWithCapacity:count];
                }
                [_items addObject:item];
            }
        }
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count       = self.titles.count;
    CGFloat viewWidth     = CGRectGetWidth(self.frame) - (count - 1) * kBorderLineWidth;
    CGFloat viewHeight    = CGRectGetHeight(self.frame);
    __block CGFloat initX = 0;
    CGFloat initY         = 0;
    
    CGFloat itemWidth     = CGRectGetWidth(self.frame)/count;
    CGFloat itemHeight    = viewHeight;
    CGFloat leftRightMargin = self.leftRightMargin?:kLeftRightMargin;
    
    //configure bgView
    self.bgView.frame = CGRectMake(leftRightMargin, 0, viewWidth - 2*leftRightMargin, viewHeight);
    
    //configure items
    [self.items enumerateObjectsUsingBlock:^(YLSegmentItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        item.frame = CGRectMake(initX - idx * kBorderLineWidth, initY, itemWidth, viewHeight);
        initX += itemWidth;
        //        if (idx == 0) {
        //            UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:item.bounds
        //                                                              byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft
        //                                                                    cornerRadii:CGSizeMake(KDefaultCornerRadius, KDefaultCornerRadius)];
        //            CAShapeLayer *maskLayer = [CAShapeLayer layer];
        //            maskLayer.frame = item.bounds;
        //            maskLayer.path = bezierPath.CGPath;
        //            item.layer.mask = maskLayer;
        //        }
    }];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    NSAssert(cornerRadius > 0, @"cornerRadius must be above 0");
    
    _cornerRadius = cornerRadius;
    _bgView.layer.cornerRadius  = cornerRadius;
    
    [self setNeedsLayout];
}

- (void)setTintColor:(UIColor *)tintColor{
    
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        
        for (NSInteger i = 0; i<self.items.count; i++) {
            YLSegmentItem *item = self.items[i];
            item.selColor = tintColor;
        }
    }
}

- (void)setTextColor:(UIColor *)textColor{
    
    if (_textColor != textColor) {
        _textColor = textColor;
        for (NSInteger i = 0; i<self.items.count; i++) {
            YLSegmentItem *item = self.items[i];
            item.norTextColor = _textColor;
            item.selTextColor = self.selTextColor;
        }
        [self setNeedsLayout];
    }
}

- (void)setBorderColor:(UIColor *)borderColor{
    //    self.bgView.layer.borderColor  = borderColor.CGColor;
    //    for (NSInteger i = 0; i<self.lines.count; i++) {
    //        UIView *lineView = self.lines[i];
    //        lineView.backgroundColor = borderColor;
    //    }
    
    [self setNeedsLayout];
}

- (void)setSelectedIndex:(NSUInteger)index
{
    _selectedIndex = index;
    
    if (index<self.items.count) {
        for (int i = 0; i<self.items.count; i++) {
            YLSegmentItem *item=self.items[i];
            
            if (i==index) {
                [item setIsSelected:YES];
            } else {
                [item setIsSelected:NO];
            }
        }
    }
}

#pragma mark - YLSegmentItemDelegate
- (void)ItemStateChanged:(YLSegmentItem *)currentItem index:(NSInteger)index isSelected:(BOOL)isSelected
{
    
    // diselect all items
    for (int i = 0; i < self.items.count; i++) {
        YLSegmentItem *item = self.items[i];
        item.isSelected = NO;
    }
    currentItem.isSelected = YES;
    
    // notify delegate
    if (_delegate && [_delegate respondsToSelector:@selector(segmentView:didSelectedIndex:)])
    {
        [_delegate segmentView:self didSelectedIndex:index];
    }
    
    // notify block handler
    if (_handlder) {
        _handlder(self, index);
    }
}

@end

