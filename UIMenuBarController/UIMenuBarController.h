//
//  UIMenuBarController.h
//  MenubarControllerDemo
//
//  Created by zuopengl on 11/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMenuBar.h"


@protocol UIMenuBarControllerDelegate;

/**
 *  UIViewController category about UIMenuBarController
 */
@interface UIViewController (UIMenuBarControllerItem)

@property (nonatomic, strong) UIMenuBarItem *menuBarItem;
@property (nonatomic, copy)   NSString *titleOfMenuBarItem;

- (instancetype)initWithMenuBarItemTitle:(NSString *)title;

@end


/**
 *  UIMenuBarController
 */
@interface UIMenuBarController : UIViewController
<
UIMenuBarDelegate
>

@property (nonatomic, weak)   id<UIMenuBarControllerDelegate> menuBarDelegate;
@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;
@property (nonatomic, strong, readonly) UIViewController *selectedViewController;
@property (nonatomic, strong) UIMenuBar *menuBar;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign, getter=isShowMenuBar) BOOL showMenuBar; // default YES

- (instancetype)initWithViewControllers:(NSArray *)controllers;

@end


@protocol UIMenuBarControllerDelegate
<
NSObject
>

@optional
- (void)menuBarController:(UIMenuBarController *)menuBarController willTouchMenuBarItem:(UIMenuBarItem *)menuBarItem;

- (void)menuBarController:(UIMenuBarController *)menuBarController didTouchMenuBarItem:(UIMenuBarItem *)menuBarItem;

- (void)menuBarController:(UIMenuBarController *)menuBarController willEndTouchMenuBarItem:(UIMenuBarItem *)menuBarItem;

@end
