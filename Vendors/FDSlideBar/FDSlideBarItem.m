//
//  FDSlideBarItem.m
//  FDSlideBarDemo
//
//  Created by fergusding on 15/6/4.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDSlideBarItem.h"

#define DEFAULT_TITLE_FONTSIZE 15
#define DEFAULT_TITLE_SELECTED_FONTSIZE 15
#define DEFAULT_TITLE_COLOR [UIColor blackColor]
#define DEFAULT_TITLE_SELECTED_COLOR [UIColor orangeColor]

#define HORIZONTAL_MARGIN 15

@interface FDSlideBarItem ()

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) CGFloat selectedFontSize;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *selectedColor;

@property (strong, nonatomic) UILabel *labelTitle;
@property (strong, nonatomic) UIView *selecetedView;

@end

@implementation FDSlideBarItem

#pragma mark - Lifecircle

- (instancetype) init {
    if (self = [super init]) {
        _fontSize = DEFAULT_TITLE_FONTSIZE;
        _selectedFontSize = DEFAULT_TITLE_SELECTED_FONTSIZE;
        _color = DEFAULT_TITLE_COLOR;
        _selectedColor = DEFAULT_TITLE_SELECTED_COLOR;
        
        self.backgroundColor = [UIColor clearColor];
        
        
        self.selecetedView = [[UIView alloc] init];
        self.selecetedView.hidden = YES;
        
        [self addSubview:self.selecetedView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    
    CGRect rectt = CGRectMake(0, 5, rect.size.width, rect.size.height-5);
    if (_selected) {
        UIColor *fillColor = [UIUtil ColorWithHexString:@"ffffff"];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,fillColor.CGColor);
        //CGContextSetRGBFillColor(context, fillColor.CGColor, 122/ 255.0f, 160/ 255.0f,0.2);//颜色（RGB）,透明度
        CGContextFillRect(context, rectt);
    }
    CGFloat titleX = (CGRectGetWidth(self.frame) - [self titleSize].width) * 0.5;
    CGFloat titleY = (CGRectGetHeight(self.frame) - [self titleSize].height) * 0.5;
    
    CGRect titleRect = CGRectMake(titleX, titleY, [self titleSize].width, [self titleSize].height);
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [self titleFont],
                                 NSForegroundColorAttributeName : [self titleColor],
                                 };
    
    [_title drawInRect:titleRect withAttributes:attributes];

}

#pragma mark - Custom Accessors

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma mark - Public

- (void)setItemTitle:(NSString *)title {
    _title = title;
    [self setNeedsDisplay];
}

- (void)setItemTitleFont:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self setNeedsDisplay];
}

- (void)setItemSelectedTileFont:(CGFloat)fontSize {
    _selectedFontSize = fontSize;
    [self setNeedsDisplay];
}

- (void)setItemTitleColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setItemSelectedTitleColor:(UIColor *)color {
    _selectedColor = color;
    [self setNeedsDisplay];
}

#pragma mark - Private

- (CGSize)titleSize {
    NSDictionary *attributes = @{NSFontAttributeName : [self titleFont]};
    CGSize size = [_title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}

- (UIFont *)titleFont {
    UIFont *font;
//    if (_selected) {
//        font = [UIFont boldSystemFontOfSize:_selectedFontSize];
//    } else {
//        font = [UIFont systemFontOfSize:_fontSize];
//    }
    font = [UIFont systemFontOfSize:_fontSize];

    return font;
}

- (UIColor *)titleColor {
    UIColor *color;
    if (_selected) {
        color = _selectedColor;
    } else {
        color = _color;
    }
    return color;
}

#pragma mark - Public Class Method

+ (CGFloat)widthForTitle:(NSString *)title {
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:DEFAULT_TITLE_FONTSIZE]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size.width = ceil(size.width) + HORIZONTAL_MARGIN * 2;
    
    return size.width;
}

#pragma mark - Responder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideBarItemSelected:)]) {
        [self.delegate slideBarItemSelected:self];
    }
}

@end
