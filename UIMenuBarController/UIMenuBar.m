//
//  UIMenuBar.m
//  MenubarControllerDemo
//
//  Created by zuopengl on 11/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "UIMenuBar.h"

// RGB颜色
#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define UIColorFromRGBA(rgbValue, _alpha_) [UIColor colorWithRed:((float)((rgbValue &0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >> 8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:_alpha_]


#define kUIMenuBarSeparatorColor      ([UIColor darkGrayColor])
#define kUIMenuBarItemIndicatorColor  ([UIColor redColor])
#define kUIMenuBarItemSeparatorColor  ([UIColor darkGrayColor])
#define kUIMenuBarItemTextColor       (UIColorFromRGB(0xFF4683))

#define kUIMenuBarItemTextFontSize    (14.f)
#define kUIMenuBarIndicatorAnimation  (0.5f)

#define kUIMenuBarItemSeparatorWidth  (2.f)
#define kUIMenuBarSeparatorHeight     (0.5f)
#define kUIMenuBarItemIndicatorHeight (1.f)


/**
 *  UIMenuBarItem
 */
@interface UIMenuBarItem ()

@property (nonatomic, strong) UIView *menuBarItemView;

@end

@implementation UIMenuBarItem

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title titleView:nil];
}


- (instancetype)initWithTitleView:(UIView *)titleView {
    return [self initWithTitle:nil titleView:titleView];
}


- (instancetype)initWithTitle:(NSString *)title titleView:(UIView *)titleView {
    self = [self init];
    if (self) {
        self.title = title;
        self.titleView = titleView;
        
        self.menuBarItemView.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)didTapMenuBarItemButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuBarItem:willTouchWithSender:)]) {
        [self.delegate menuBarItem:self willTouchWithSender:sender];
    }
    
    if ([self.delegate respondsToSelector:@selector(menuBarItem:sender:)]) {
        [self.delegate menuBarItem:self sender:sender];
    }
    
    if ([self.delegate respondsToSelector:@selector(menuBarItem:willEndTouchWithSender:)]) {
        [self.delegate menuBarItem:self willEndTouchWithSender:sender];
    }
}


- (UIView *)menuBarItemView {
    if (!_menuBarItemView) {
        UIButton *menuItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuItemButton.backgroundColor = [UIColor clearColor];
        menuItemButton.titleLabel.font = [UIFont systemFontOfSize:kUIMenuBarItemTextFontSize];
        [menuItemButton setTitleColor:kUIMenuBarItemTextColor forState:UIControlStateNormal];
        
        if (self.title) {
            [menuItemButton setTitle:self.title forState:UIControlStateNormal];
        } else {
            [menuItemButton addSubview:self.titleView];
        }
//        [menuItemButton setImage:[UIImag] forState:UIControlStateHighlighted];
        [menuItemButton addTarget:self action:@selector(didTapMenuBarItemButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _menuBarItemView = menuItemButton;
    }
    
    return _menuBarItemView;
}
@end




/**
 *  UIMenuBarView
 */
@interface UIMenuBarView : UIView

@end

@implementation UIMenuBarView

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end


/**
 *  UIMenuBar
 */
@interface UIMenuBar ()
@property (nonatomic, strong) UIView *menuBarView;
@property (nonatomic, strong) UIMenuBarItem *selectedMenuBarItem;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *indicatorLine;
@property (nonatomic, strong) NSArray *menuBarItemSeparators;
@property (nonatomic, readwrite) CGRect menuBarFrame;
@end


@implementation UIMenuBar

@synthesize menuBarFrame = _menuBarFrame;

- (instancetype)init {
    self = [super init];
    if (self) {
        _height = CGFLOAT_MIN; // default
        _menuBarFrame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 64.f);
        
        _menuBarSeparatorStyle = kUIMenuBarSeparatorHorizontal;
        _menuBarItemSeparatorStyle = kUIMenuBarItemSeparatorVertical;
        _menuBarItemIndicatorStyle = kUIMenuBarItemIndicatorLine;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [self init];
    if (self) {
        _menuBarFrame = frame;
    }
    return self;
}


- (instancetype)initWithMenuBarItems:(NSArray *)menuBarItems {
    self = [self init];
    if (self) {
        NSAssert([menuBarItems count] > 0, @"初始化menuBar数组不能为空");
        
        [self initViewsWithMenuBarItems:menuBarItems];
    }
    return self;
}


- (void)initViewsWithMenuBarItems:(NSArray *)menuBarItems {
    NSMutableArray *arrays = [NSMutableArray array];
    
    for (id item in menuBarItems) {
        UIMenuBarItem *menuBarItem = nil;
        
        if ([item isKindOfClass:[UIMenuBarItem class]]) {
            menuBarItem = item;
        } else {
            NSAssert(NO, @"参数类型不正确");
        }
        menuBarItem.delegate = self;
        
        [self.menuBarView addSubview:menuBarItem.menuBarItemView];
        [arrays addObject:menuBarItem];
    }
    
    _menuBarItems = arrays;
    self.selectedIndex = 0;
}


#pragma mark - delegate for UIMenuBarItemDelegate

- (void)menuBarItem:(UIMenuBarItem *)menuBarItem sender:(id)sender {
    if ([self.menuBarView.subviews containsObject:sender]) {
        self.selectedIndex = [self.menuBarItems indexOfObject:menuBarItem];
        
        if ([self.delegate respondsToSelector:@selector(menuBar:selectedIndex:)]) {
            [self.delegate menuBar:self selectedIndex:self.selectedIndex];
        }
    }
}


- (void)menuBarItem:(UIMenuBarItem *)menuBarItem willTouchWithSender:(id)sender {
    if ([self.menuBarView.subviews containsObject:sender]) {
        if ([self.delegate respondsToSelector:@selector(menuBar:selectedIndex:)]) {
            [self.delegate menuBar:self willTouchWithSelectedIndex:self.selectedIndex];
        }
    }
}


- (void)menuBarItem:(UIMenuBarItem *)menuBarItem willEndTouchWithSender:(id)sender {
    if ([self.menuBarView.subviews containsObject:sender]) {
        if ([self.delegate respondsToSelector:@selector(menuBar:selectedIndex:)]) {
            [self.delegate menuBar:self willEndTouchWithSelectedIndex:self.selectedIndex];
        }
    }
}

#pragma mark - layout subViews

- (void)layoutCustomSubViews {
    const NSUInteger count = [self.menuBarItems count];
    const CGRect  selfFrame = self.menuBarView.frame;
    
    CGFloat menuBarHeight = CGRectGetHeight(selfFrame);
    CGFloat menuBarItemsWidth = CGRectGetWidth(selfFrame);
    CGFloat menuBarItemWidth = menuBarItemsWidth / count;
    CGFloat menuBarItemHeight = menuBarHeight;
    CGFloat menuBarItemIndicatorWidth = menuBarItemWidth * 3.0 / 5;
    
    
    /**
     *  计算menuBarItem宽度
     */
    if (self.menuBarItemSeparatorStyle == kUIMenuBarItemSeparatorVertical) {
        menuBarItemsWidth -= kUIMenuBarItemSeparatorWidth * (count - 1);
        menuBarItemWidth = menuBarItemsWidth / count;
        menuBarItemIndicatorWidth = menuBarItemWidth * 3.0 / 5;
    }

    
    /**
     *  显示menuBar下面的分割线
     */
    if (self.menuBarSeparatorStyle == kUIMenuBarSeparatorHorizontal) {
        self.bottomLine.hidden = NO;
        self.bottomLine.frame = CGRectMake(0, menuBarHeight - kUIMenuBarSeparatorHeight, CGRectGetWidth(selfFrame), kUIMenuBarSeparatorHeight);
        
        menuBarItemHeight = menuBarHeight - kUIMenuBarSeparatorHeight;
    } else {
        _bottomLine.hidden = YES;
    }
    
    
    if (self.menuBarItemIndicatorStyle == kUIMenuBarItemIndicatorLine) {
        CGFloat bottomLineHeight = (self.menuBarSeparatorStyle == kUIMenuBarSeparatorHorizontal) ? kUIMenuBarSeparatorHeight : 0;
        menuBarItemHeight = menuBarHeight - MAX(bottomLineHeight, kUIMenuBarItemIndicatorHeight);
    }
    
    
    /**
     *  显示menuBarItem和之间的分割线
     */
    CGFloat offsetX = 0;
    for (NSUInteger i = 0; i < count; i++) {
        
        UIMenuBarItem *menuBarItem = self.menuBarItems[i];
        menuBarItem.menuBarItemView.frame = CGRectMake(offsetX, 0, menuBarItemWidth, menuBarItemHeight);
        
        offsetX += menuBarItemWidth;
        
        if (i != count - 1) {
            UIView *separator = self.menuBarItemSeparators[i];
            if (self.menuBarItemSeparatorStyle == kUIMenuBarItemSeparatorVertical) {
                separator.hidden = NO;
                separator.frame = CGRectMake(offsetX, (menuBarItemHeight - menuBarItemHeight * 3.0 / 5) / 2, kUIMenuBarItemSeparatorWidth, menuBarItemHeight * 3.0 / 5);
                
                offsetX += kUIMenuBarItemSeparatorWidth;
            } else {
                separator.hidden = YES;
            }
        }
    }
    
    
    /**
     *  显示某个具体的menuBarItem的指示线
     */
    CGFloat indicatorOffsetX = CGRectGetMinX(self.selectedMenuBarItem.menuBarItemView.frame) + (menuBarItemWidth - menuBarItemIndicatorWidth) / 2;
    if (self.menuBarItemIndicatorStyle == kUIMenuBarItemIndicatorLine) {
        self.indicatorLine.hidden = NO;
        
        self.indicatorLine.frame = CGRectMake(indicatorOffsetX, menuBarHeight - kUIMenuBarItemIndicatorHeight, menuBarItemIndicatorWidth, kUIMenuBarItemIndicatorHeight);
        
    } else {
        _indicatorLine.hidden = YES;
    }
    
    
    self.menuBarView.frame = CGRectMake(CGRectGetMinX(selfFrame), CGRectGetMinY(selfFrame), CGRectGetWidth(selfFrame), menuBarHeight);
}


#pragma mark - help for move indicator with animation

- (void)moveIndicatorFromIndex:(NSUInteger)fromIdx toIndex:(NSUInteger)toIdx withAnimation:(BOOL)animation {
    if (self.menuBarItemIndicatorStyle == kUIMenuBarItemIndicatorNone) {
        return;
    }
    
    CGFloat menuBarItemWidth = CGRectGetWidth(self.selectedMenuBarItem.menuBarItemView.frame);
    CGFloat menuBarItemIndicatorWidth = menuBarItemWidth * 3.0 / 5;
    CGFloat indicatorOffsetX = CGRectGetMinX(self.selectedMenuBarItem.menuBarItemView.frame) + (menuBarItemWidth - menuBarItemIndicatorWidth) / 2;
    
    if (animation) {
        NSUInteger skipCount = labs((NSInteger)fromIdx - (NSInteger)toIdx);
        [UIView animateWithDuration:kUIMenuBarIndicatorAnimation / skipCount animations:^{
            self.indicatorLine.frame = CGRectMake(indicatorOffsetX, CGRectGetHeight(self.menuBarView.frame) - kUIMenuBarItemIndicatorHeight, menuBarItemIndicatorWidth, kUIMenuBarItemIndicatorHeight);
        }];
    } else {
        self.indicatorLine.frame = CGRectMake(indicatorOffsetX, CGRectGetHeight(self.menuBarView.frame) - kUIMenuBarItemIndicatorHeight, menuBarItemIndicatorWidth, kUIMenuBarItemIndicatorHeight);
    }
}


#pragma mark - setter/getter property

- (UIView *)menuBarView {
    if (!_menuBarView) {
        _menuBarView = [[UIMenuBarView alloc] init];
        _menuBarView.backgroundColor = [UIColor whiteColor];
    }
    return _menuBarView;
}


- (NSArray *)menuBarItemSeparators {
    NSMutableArray *separatorItems = [_menuBarItemSeparators copy];
    
    if (!separatorItems) {
        separatorItems = [NSMutableArray array];
    }
    
    if ([separatorItems count] != [self.menuBarItems count]) {
        [separatorItems removeAllObjects];
        
        for (NSUInteger i = 0; i < [self.menuBarItems count]; i++) {
            UIView *separatorItem = [self menuBarItemSeparator];
            [separatorItems addObject:separatorItem];
            
            [self.menuBarView addSubview:separatorItem];
        }
    }
    
    return separatorItems;
}


- (void)setMenuBarItems:(NSArray *)menuBarItems {
    NSAssert([menuBarItems count] > 0, @"数组为空");
    
    _menuBarItems = menuBarItems;
    
    [self initViewsWithMenuBarItems:_menuBarItems];
}


- (void)setHidden:(BOOL)hidden {
    _hidden = hidden;
    
    self.menuBarView.hidden = _hidden;
}


- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    NSAssert(selectedIndex < [self.menuBarItems count], @"数组访问越界");
    
    if (selectedIndex < [self.menuBarItems count] && selectedIndex != _selectedIndex) {
        NSUInteger preSelectedIndex = _selectedIndex;
        
        _selectedIndex = selectedIndex;
        _selectedMenuBarItem = [self.menuBarItems objectAtIndex:_selectedIndex];
        
        [self moveIndicatorFromIndex:preSelectedIndex toIndex:selectedIndex withAnimation:YES];
    }
}


- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = kUIMenuBarSeparatorColor;
        
        [self.menuBarView addSubview:_bottomLine];
    }
    return _bottomLine;
}


- (UIView *)indicatorLine {
    if (!_indicatorLine) {
        _indicatorLine = [[UIView alloc] init];
        _indicatorLine.backgroundColor = kUIMenuBarItemIndicatorColor;
        
        [self.menuBarView addSubview:_indicatorLine];
    }
    return _indicatorLine;
}


- (UIView *)menuBarItemSeparator {
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = kUIMenuBarItemSeparatorColor;
    return separator;
}


#pragma mark - setter with layoutSubViews

- (void)setMenuBarSeparatorStyle:(UIMenuBarSeparatorStyle)menuBarSeparatorStyle {
    if (_menuBarSeparatorStyle != menuBarSeparatorStyle) {
        _menuBarSeparatorStyle = menuBarSeparatorStyle;
        
        [self layoutCustomSubViews];
    }
}


- (void)setMenuBarItemSeparatorStyle:(UIMenuBarItemSeparatorStyle)menuBarItemSeparatorStyle {
    if (_menuBarItemSeparatorStyle != menuBarItemSeparatorStyle) {
        _menuBarItemSeparatorStyle = menuBarItemSeparatorStyle;
        
        [self layoutCustomSubViews];
    }
}


- (void)setMenuBarItemIndicatorStyle:(UIMenuBarItemIndicatorStyle)menuBarItemIndicatorStyle {
    if (_menuBarItemIndicatorStyle != menuBarItemIndicatorStyle) {
        _menuBarItemIndicatorStyle = menuBarItemIndicatorStyle;
        
        [self layoutCustomSubViews];
    }
}


- (void)setMenuBarFrame:(CGRect)frame {
    if (!CGRectEqualToRect(frame, _menuBarFrame)) {
        _height = CGRectGetHeight(frame);
        _menuBarFrame = self.menuBarView.frame = frame;
        
        [self layoutCustomSubViews];
    }
}


- (CGRect)menuBarFrame {
    return self.menuBarView.frame;
}


- (void)setHeight:(CGFloat)height {
    if (height != height) {
        _height = height;
        _menuBarFrame = self.menuBarView.frame = CGRectMake(CGRectGetMinX(self.menuBarView.frame), CGRectGetMinY(self.menuBarView.frame), CGRectGetWidth(self.menuBarView.frame), height);

        [self layoutCustomSubViews];
    }
}

@end
