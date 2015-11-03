//
// Created by Kai Straßmann on 23.01.15.
// Copyright (c) 2015 Kai Straßmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KSLayoutDirection) {
    KSLayoutDirectionVertical = 0,
    KSLayoutDirectionHorizontal
};

@interface KSLayoutSettings : NSObject
@property (nonatomic, assign) UIEdgeInsets containerPadding;
@property (nonatomic, assign) CGFloat subviewSpacing;
@property (nonatomic, copy) CGFloat (^_Nonnull subviewSpacingBlock)(UIView * _Nullable lastView, UIView * _Nonnull currentView, NSUInteger currentViewIndex);
@property (nonatomic, assign) CGFloat subviewSize;
@property (nonatomic, copy) CGFloat (^_Nonnull subviewSizeBlock)(UIView * _Nonnull currentView, NSUInteger currentViewIndex);
@property (nonatomic, assign) CGFloat subviewSizeRatio;
@property (nonatomic, copy) CGFloat (^_Nonnull subviewSizeRatioBlock)(UIView * _Nonnull currentView, NSUInteger currentViewIndex);
@property (nonatomic, assign) BOOL autoRemoveSubviews;
@end

@interface UIView (KSLayout)
- (void)setSubviewsStacked:(NSArray<UIView*>* _Nonnull)subviews layoutDirection:(KSLayoutDirection)direction;
- (void)setSubviewsStacked:(NSArray<UIView*>* _Nonnull)subviews layoutDirection:(KSLayoutDirection)direction settings:(nullable void (^)(KSLayoutSettings* _Nonnull))settingsBlock;
@end

