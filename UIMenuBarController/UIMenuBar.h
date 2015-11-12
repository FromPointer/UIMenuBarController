//
//  UIMenuBar.h
//  MenubarControllerDemo
//
//  Created by zuopengl on 11/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class UIMenuBar, UIMenuBarItem;
@protocol UIMenuBarItemDelegate, UIMenuBarDelegate;


@protocol UIMenuBarDelegate <NSObject>
@required
- (void)menuBar:(UIMenuBar *)menuBar willTouchWithSelectedIndex:(NSUInteger)selectedIndex;
- (void)menuBar:(UIMenuBar *)menuBar selectedIndex:(NSUInteger)selectedIndex;
- (void)menuBar:(UIMenuBar *)menuBar willEndTouchWithSelectedIndex:(NSUInteger)selectedIndex;
@end


@protocol UIMenuBarItemDelegate <NSObject>
@required
- (void)menuBarItem:(UIMenuBarItem *)menuBarItem sender:(id)sender;
- (void)menuBarItem:(UIMenuBarItem *)menuBarItem willTouchWithSender:(id)sender;
- (void)menuBarItem:(UIMenuBarItem *)menuBarItem willEndTouchWithSender:(id)sender;
@end


@interface UIMenuBarItem : NSObject

/**
 *  title and titleView only show one, if exits titleView, will show it, or use title instance
 */
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, weak)   id<UIMenuBarItemDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitleView:(UIView *)titleView;

@end


typedef NS_ENUM(NSUInteger, UIMenuBarSeparatorStyle) {
    kUIMenuBarSeparatorNone,
    kUIMenuBarSeparatorHorizontal, // default
};


typedef NS_ENUM(NSUInteger, UIMenuBarItemSeparatorStyle) {
    kUIMenuBarItemSeparatorNone,
    kUIMenuBarItemSeparatorVertical, // default
};

typedef NS_ENUM(NSUInteger, UIMenuBarItemIndicatorStyle) {
    kUIMenuBarItemIndicatorNone,
    kUIMenuBarItemIndicatorLine, // default
};


@interface UIMenuBar : NSObject
<
UIMenuBarItemDelegate
>

@property (nonatomic, assign, getter=isHidden) BOOL hidden;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong, readonly) NSArray *menuBarItems;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak)   id<UIMenuBarDelegate> delegate;
@property (nonatomic, assign) UIMenuBarSeparatorStyle menuBarSeparatorStyle;
@property (nonatomic, assign) UIMenuBarItemSeparatorStyle menuBarItemSeparatorStyle;
@property (nonatomic, assign) UIMenuBarItemIndicatorStyle menuBarItemIndicatorStyle;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithMenuBarItems:(NSArray *)menuBarItems;

@end
