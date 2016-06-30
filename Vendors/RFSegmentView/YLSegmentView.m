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

@property (nonatomic, strong) UIColor   *norBorderColor;
@property (nonatomic, strong) UIColor   *norBackColor;
@property (nonatomic, strong) UIColor   *norTextColor;

@property (nonatomic, strong) UIColor   *selBorderColor;
@property (nonatomic, strong) UIColor   *selBackColor;
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
             colors:(NSDictionary *) colors
         isSelected:(BOOL)isSelected;
{
    self = [super initWithFrame:frame];
    if (self) {
        if(colors) {
            _norBorderColor = [colors objectForKey:@"norBorderColor"];
            _norBackColor = [colors objectForKey:@"norBackColor"];
            _norTextColor = [colors objectForKey:@"norTextColor"];
            _selBorderColor = [colors objectForKey:@"selBorderColor"];
            _selBackColor = [colors objectForKey:@"selBackColor"];
            _selTextColor = [colors objectForKey:@"selTextColor"];
        } else {
            UIColor *norTextColor = [UIUtil ColorWithHexString:@"abb7c6"];
            UIColor *selTextColor = [UIUtil ColorWithHexString:@"b4784c"];
            UIColor *backColor = [UIUtil ColorWithHexString:@"eaeff5"];
            
            _norBorderColor = norTextColor;
            _norBackColor = backColor;
            _norTextColor = norTextColor;
            _selBorderColor = selTextColor;
            _selBackColor = backColor;
            _selTextColor = selTextColor;
        }
        
        _titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0 + kBorderLineWidth, 0 + kBorderLineWidth, self.bounds.size.width - kBorderLineWidth * 2, self.bounds.size.height - kBorderLineWidth * 2)];
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = _norBackColor;
        _titleLabel.font            = kTitleSize;
        [self addSubview:_titleLabel];
        
        _titleLabel.text = title;
        _index           = index;
        _isSelected      = isSelected;
        self.backgroundColor = _norBorderColor;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.titleLabel.frame = CGRectMake(0 + kBorderLineWidth, 0 + kBorderLineWidth, self.bounds.size.width - kBorderLineWidth * 2, self.bounds.size.height - kBorderLineWidth * 2);
}

- (void)setSelColor:(UIColor *)selColor
{
    if (_isSelected) {
        self.titleLabel.textColor = self.selTextColor;
        self.titleLabel.backgroundColor = self.selBackColor;
        self.backgroundColor = self.selBorderColor;
    } else {
        self.titleLabel.textColor = self.norTextColor;
        self.titleLabel.backgroundColor = self.norBackColor;
        self.backgroundColor = self.norBorderColor;
    }
    
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if (_isSelected) {
        self.titleLabel.textColor = self.selTextColor;
        self.titleLabel.backgroundColor = self.selBackColor;
        self.backgroundColor = self.selBorderColor;
        [self.superview bringSubviewToFront:self];
    } else {
        self.titleLabel.textColor = self.norTextColor;
        self.titleLabel.backgroundColor = self.norBackColor;
        self.backgroundColor = self.norBorderColor;
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
@end

@implementation YLSegmentView

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray<NSString *> * _Nonnull)items
                       colors:(NSDictionary *)colors {
    self = [super initWithFrame:frame];
    if (self) {
        if (items.count >= 2) {
            NSAssert(items.count >= 2, @"items's cout at least 2!please check!");
            _titles              = items;
            _selectedIndex       = 0;
            self.backgroundColor = [UIColor clearColor];
            
            _itemHeight = frame.size.height;
            //
            _bgView = [[UIView alloc] init];
            _bgView.backgroundColor    = [UIColor clearColor];
            
            [self addSubview:_bgView];
            
            
            NSInteger count = _titles.count;
            for (NSInteger i = 0; i < count; i++) {
                
                YLSegmentItem *item = [[YLSegmentItem alloc] initWithFrame:CGRectZero
                                                                     index:i
                                                                     title:items[i]
                                                                    colors:colors
                                                                isSelected:(i == 0)];
                [_bgView addSubview:item];
                item.delegate = self;
                
                //save all items
                if (!self.items) {
                    self.items = [[NSMutableArray alloc] initWithCapacity:count];
                }
                [_items addObject:item];
            }
        } else {
            _titles              = items;
            _selectedIndex       = 0;
            self.backgroundColor = [UIColor clearColor];
            
            //
            _bgView = [[UIView alloc] init];
            _bgView.backgroundColor    = [UIColor clearColor];
            
            [self addSubview:_bgView];
            
            
            NSInteger count = _titles.count;
            for (NSInteger i = 0; i < count; i++) {
                YLSegmentItem *item = [[YLSegmentItem alloc] initWithFrame:CGRectZero
                                                                     index:i
                                                                     title:items[i]
                                                                    colors:colors
                                                                isSelected:(i == 0)? YES: NO];
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
        if (count > 1 && (idx == 0 || idx == count - 1)) {
            UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:item.bounds
                                                              byRoundingCorners:idx == 0 ? (UIRectCornerTopLeft|UIRectCornerBottomLeft) : (UIRectCornerTopRight|UIRectCornerBottomRight)
                                                                    cornerRadii:CGSizeMake(KDefaultCornerRadius, KDefaultCornerRadius)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = item.bounds;
            maskLayer.path = bezierPath.CGPath;
            item.layer.mask = maskLayer;
            
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:item.titleLabel.bounds
                                               byRoundingCorners:idx == 0 ? (UIRectCornerTopLeft|UIRectCornerBottomLeft) : (UIRectCornerTopRight|UIRectCornerBottomRight)
                                                     cornerRadii:CGSizeMake(KDefaultCornerRadius - 0.8, KDefaultCornerRadius - 0.8)];
            maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = item.bounds;
            maskLayer.path = bezierPath.CGPath;
            item.titleLabel.layer.mask = maskLayer;
        } else if (count == 1) {
            item.titleLabel.layer.masksToBounds = YES;
            item.titleLabel.layer.cornerRadius = KDefaultCornerRadius - 0.8;
            item.layer.masksToBounds = YES;
            item.layer.cornerRadius = KDefaultCornerRadius;
        }
    }];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    NSAssert(cornerRadius > 0, @"cornerRadius must be above 0");
    
    _cornerRadius = cornerRadius;
    _bgView.layer.cornerRadius  = cornerRadius;
    
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

