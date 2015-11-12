//
//  UIMenuBarController.m
//  MenubarControllerDemo
//
//  Created by zuopengl on 11/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "UIMenuBarController.h"
#import <objc/runtime.h>



/**
 *  UIMenuBar
 */
@interface UIMenuBar ()
@property (nonatomic, strong, readwrite) UIView *menuBarView;
@property (nonatomic, readwrite) CGRect menuBarFrame;
@end



/**
 *  Implementation of UIViewController category about UIMenuBarController
 */
@implementation UIViewController (UIMenuBarControllerItem)

- (instancetype)initWithMenuBarItemTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.titleOfMenuBarItem = title;
    }
    return self;
}


- (NSString *)titleOfMenuBarItem {
   return objc_getAssociatedObject(self, @selector(titleOfMenuBarItem));
}


- (void)setTitleOfMenuBarItem:(NSString *)titleOfMenuBarItem {
    objc_setAssociatedObject(self, @selector(titleOfMenuBarItem), titleOfMenuBarItem, OBJC_ASSOCIATION_COPY);
}

- (UIMenuBarItem *)menuBarItem {
     return objc_getAssociatedObject(self, @selector(menuBarItem));
}


- (void)setMenuBarItem:(UIMenuBarItem *)menuBarItem {
    objc_setAssociatedObject(self, @selector(menuBarItem), menuBarItem, OBJC_ASSOCIATION_RETAIN);
}
@end




/**
 *  Extension of UIMenuBarConttoller
 */
@interface UIMenuBarController ()

@end

@implementation UIMenuBarController

@synthesize showMenuBar = _showMenuBar;

- (instancetype)init {
    self = [super init];
    if (self) {
        _showMenuBar = YES;
        _selectedIndex = -1;
    }
    return self;
}


- (instancetype)initWithViewControllers:(NSArray *)controllers {
    self = [self init];
    if (self) {
        NSAssert([controllers count] > 0, @"初始化viewController数组不能为空");
        
        if ([controllers count] > 0) {
            self.viewControllers = controllers;
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMenuBar];
}


- (void)setupMenuBar {
    NSMutableArray *menuBarItems = [NSMutableArray array];
    
    for (UIViewController *viewController in self.viewControllers) {
        UIMenuBarItem *menuBarItem = viewController.menuBarItem;
        if (!menuBarItem) {
            menuBarItem = [[UIMenuBarItem alloc] init];
        }
        menuBarItem.title = viewController.titleOfMenuBarItem;
        
        [self.view addSubview:viewController.view];
        [menuBarItems addObject:menuBarItem];
    }
    
    self.menuBar = [[UIMenuBar alloc] initWithMenuBarItems:menuBarItems];
    self.menuBar.delegate = self;
    self.menuBar.menuBarFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame), 50.f);
    [self.view addSubview:self.menuBar.menuBarView];
    
    self.selectedIndex = 0;
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat offsetY = 0.f;
    if ([self isShowMenuBar]) {
        if (![self.view.subviews containsObject:self.menuBar.menuBarView]) {
            [self.view addSubview:self.menuBar.menuBarView];
        }
        [self.view bringSubviewToFront:self.menuBar.menuBarView];

        offsetY = CGRectGetHeight(self.menuBar.menuBarView.frame);
    }
    
    for (UIViewController *vc in self.viewControllers) {
        vc.view.frame = CGRectIntegral(CGRectMake(CGRectGetMinX(self.view.bounds), offsetY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)));
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - delegate for UIMenuBarDelegate

- (void)menuBar:(UIMenuBar *)menuBar willTouchWithSelectedIndex:(NSUInteger)selectedIndex {
    if (self.menuBar == menuBar) {
        if ([self.menuBarDelegate respondsToSelector:@selector(menuBarController:willTouchMenuBarItem:)]) {
            [self.menuBarDelegate menuBarController:self willTouchMenuBarItem:self.selectedViewController.menuBarItem];
        }
    }
}


- (void)menuBar:(UIMenuBar *)menuBar selectedIndex:(NSUInteger)selectedIndex {
    if (self.menuBar == menuBar) {
        self.selectedIndex = selectedIndex;
        
        if ([self.menuBarDelegate respondsToSelector:@selector(menuBarController:didTouchMenuBarItem:)]) {
            [self.menuBarDelegate menuBarController:self didTouchMenuBarItem:self.selectedViewController.menuBarItem];
        }
    }
}


- (void)menuBar:(UIMenuBar *)menuBar willEndTouchWithSelectedIndex:(NSUInteger)selectedIndex {
    if (self.menuBar == menuBar) {

        if ([self.menuBarDelegate respondsToSelector:@selector(menuBarController:willEndTouchMenuBarItem:)]) {
            [self.menuBarDelegate menuBarController:self willEndTouchMenuBarItem:self.selectedViewController.menuBarItem];
        }
    }
}


#pragma mark - setter/getter property

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    NSAssert(selectedIndex >= 0 && selectedIndex < [self.viewControllers count], @"参数越界");
    
    if (selectedIndex < [self.viewControllers count]) {
        _selectedIndex = selectedIndex;
        _selectedViewController = [self.viewControllers objectAtIndex:_selectedIndex];
        
        // TODO: ADD animated of view
        if ([self.view.subviews containsObject:_selectedViewController.view]) {
            [self.view bringSubviewToFront:_selectedViewController.view];
        }
    }
}


- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    NSAssert(selectedViewController != nil && [self.viewControllers containsObject:selectedViewController], @"参数为空或不合法");
    
    if (selectedViewController && [self.viewControllers containsObject:selectedViewController]) {
        _selectedViewController = selectedViewController;
        _selectedIndex = [self.viewControllers indexOfObject:selectedViewController];
        
        [self.view bringSubviewToFront:_selectedViewController.view];
    }
}


- (BOOL)isShowMenuBar {
    return (_showMenuBar && self.menuBar);
}


- (void)setShowMenuBar:(BOOL)showMenuBar {
    _showMenuBar = showMenuBar;
    
    CGFloat offsetY = 0.f;
    self.menuBar.hidden = !self.isShowMenuBar;
    if ([self isShowMenuBar]) {
        offsetY = self.menuBar.height;
    }
    self.view.frame = CGRectIntegral(CGRectMake(CGRectGetMinX(self.view.bounds), offsetY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
