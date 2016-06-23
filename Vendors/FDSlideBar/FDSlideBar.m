//
//  FDSlideBar.m
//  FDSlideBarDemo
//
//  Created by fergusding on 15/6/4.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDSlideBar.h"
#import "FDSlideBarItem.h"

#define DEVICE_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SLIDER_VIEW_HEIGHT 5
#define SLIDER_VIEW_WIDTH kXLeft

@interface FDSlideBar () <FDSlideBarItemDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIView *sliderView;

@property (strong, nonatomic) FDSlideBarItem *selectedItem;
@property (strong, nonatomic) FDSlideBarItemSelectedCallback callback;

@property (strong, nonatomic) FDSlideBarItemSelectedbackTop backTop;

@end

@implementation FDSlideBar

#pragma mark - Lifecircle
//上面有导航栏，修改高度
- (instancetype)init {
    self = [super init];
    CGRect frame = CGRectMake(0, 64, DEVICE_WIDTH, 46);
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {

        
        _items = [NSMutableArray array];
        
        [self initScrollView];
        [self initSliderView];
        
    }
    return self;
}

#pragma - mark Custom Accessors

- (void)setItemsTitle:(NSArray *)itemsTitle {
    
    _itemsTitle = itemsTitle;
    [_items removeAllObjects];
    [self setupItems];
}

- (void)setItemColor:(UIColor *)itemColor {
    for (FDSlideBarItem *item in _items) {
        [item setItemTitleColor:itemColor];
    }
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    for (FDSlideBarItem *item in _items) {
        [item setItemSelectedTitleColor:itemSelectedColor];
    }
}

- (void)setSliderColor:(UIColor *)sliderColor {
    _sliderColor = sliderColor;
    self.sliderView.backgroundColor = _sliderColor;
}

- (void)setSelectedItem:(FDSlideBarItem *)selectedItem {
    _selectedItem.selected = NO;
    _selectedItem = selectedItem;
}


#pragma - mark Private

- (void)initScrollView {

    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.delegate = self;
//    _scrollView.alwaysBounceVertical = YES;
//    _scrollView.al
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(0, 46);
    _scrollView.scrollsToTop = NO;
    [self addSubview:_scrollView];
}

- (void)initSliderView {

    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
    }
    _sliderColor = [UIUtil ColorWithHexString:@"f2f2f2"];
    _sliderView.backgroundColor = _sliderColor;
    [_scrollView addSubview:_sliderView];
}

- (void)setupItems {

    CGFloat itemX = 0;

    for (UIView * view in _scrollView.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"FDSlideBarItem"]) {
            [view removeFromSuperview];
        }
    }
    CGFloat itemW = 0.0f;
    for (NSString *title in _itemsTitle) {
        
        FDSlideBarItem *item = [[FDSlideBarItem alloc] init];
        item.delegate = self;
        
        // Init the current item's frame
        
        
        if(_itemsTitle.count < 4){
            itemW = _scrollView.frame.size.width/_itemsTitle.count;
        }else{
            itemW = _scrollView.frame.size.width/4;
        }
        
        //CGFloat itemW = [FDSlideBarItem widthForTitle:title[@"name"]];
        item.frame = CGRectMake(itemX, 0, itemW, CGRectGetHeight(_scrollView.frame));
        [item setItemTitle:title];
        [_items addObject:item];

        [_scrollView addSubview:item];

        // Caculate the origin.x of the next item
        itemX = CGRectGetMaxX(item.frame);
    }
    
    // Cculate the scrollView 's contentSize by all the items
    _scrollView.contentSize = CGSizeMake(itemX, CGRectGetHeight(_scrollView.frame));
    
    // Set the default selected item, the first item
    FDSlideBarItem *firstItem = [self.items firstObject];
    firstItem.selected = YES;
    _selectedItem = firstItem;
    
    // Set the frame of sliderView by the selected item
    _sliderView.frame = CGRectMake(0, 0, itemW, SLIDER_VIEW_HEIGHT);
    _scrollView.bounds = _scrollView.frame;
    [self setNeedsDisplay];
}

#pragma mark - 重写滚动逻辑
- (void)scrollToVisibleItem:(FDSlideBarItem *)item {
    CGPoint offset;

    
    if (item.center.x < self.frame.size.width/2) {

        
        offset.x = 0;
        offset.y = 0;
        
    }else if (self.scrollView.contentSize.width - item.center.x < self.frame.size.width/2) {

        offset.x = self.scrollView.contentSize.width - self.frame.size.width;
        offset.y = 0;

    }else{
    
        
        offset.x = item.center.x - self.frame.size.width/2;
        offset.y = 0;

    }
    //_scrollView.contentOffset = offset;
    [UIView animateWithDuration:0.1 animations:^{
        
        _scrollView.contentOffset = offset;

    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)addAnimationWithSelectedItem:(FDSlideBarItem *)item {
    // Caculate the distance of translation
    CGFloat dx = CGRectGetMidX(item.frame) - CGRectGetMidX(_selectedItem.frame);
    
    // Add the animation about translation
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.fromValue = @(_sliderView.layer.position.x);
    positionAnimation.toValue = @(_sliderView.layer.position.x + dx);
    
    // Add the animation about size
    CABasicAnimation *boundsAnimation = [CABasicAnimation animation];
    boundsAnimation.keyPath = @"bounds.size.width";
    boundsAnimation.fromValue = @(CGRectGetWidth(_sliderView.layer.frame));
    boundsAnimation.toValue = @(CGRectGetWidth(item.frame));
    
    // Combine all the animations to a group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation];
    animationGroup.duration = 0.1;
    [_sliderView.layer addAnimation:animationGroup forKey:@"basic"];
    
    // Keep the state after animating
    _sliderView.layer.position = CGPointMake(_sliderView.layer.position.x + dx, _sliderView.layer.position.y);
    CGRect rect = _sliderView.layer.frame;
    rect.size.width = CGRectGetWidth(item.frame);
    rect.origin.x = CGRectGetMinX(item.frame);
    _sliderView.layer.frame = rect;
}

#pragma mark - Public

- (void)slideBarItemSelectedCallback:(FDSlideBarItemSelectedCallback)callback {
    _callback = callback;
}

-(void)slideBarItemSelectedbackTop:(FDSlideBarItemSelectedbackTop)backTop{
    _backTop = backTop;
}

- (void)selectSlideBarItemAtIndex:(NSUInteger)index {

    FDSlideBarItem *item = [self.items objectAtIndex:index];
    if (item == _selectedItem ) {
        
        return;
    }
    
    item.selected = YES;
    
    

    [self scrollToVisibleItem:item];
    
    [self addAnimationWithSelectedItem:item];
    
    self.selectedItem = item;
}

#pragma mark - FDSlideBarItemDelegate

- (void)slideBarItemSelected:(FDSlideBarItem *)item {
    
    if (item == _selectedItem) {
        //_backTop();
        return;
    }
    [self addAnimationWithSelectedItem:item];

    [self scrollToVisibleItem:item];
    
    self.selectedItem = item;
    _callback([self.items indexOfObject:item]);
}

@end
