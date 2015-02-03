//
// Created by Kai Straßmann on 23.01.15.
// Copyright (c) 2015 Kai Straßmann. All rights reserved.
//

#import "UIView+KSLayout.h"

@implementation KSLayoutSettings
- (instancetype)init {
    if (self = [super init]) {
        _autoRemoveSubviews = YES;
        __weak typeof(self) weakSelf = self;
        
        _subviewSize = CGFLOAT_MIN;
        _subviewSizeBlock = ^CGFloat(UIView *currentView, NSUInteger currentViewIndex) {
            return weakSelf.subviewSize;
        };
        
        _subviewSpacing = 0;
        _subviewSpacingBlock = ^CGFloat(UIView *lastView, UIView *currentView, NSUInteger currentViewIndex) {
            return weakSelf.subviewSpacing;
        };
        
        _subviewSizeRatio = CGFLOAT_MIN;
        _subviewSizeRatioBlock = ^CGFloat(UIView *currentView, NSUInteger currentViewIndex) {
            return weakSelf.subviewSizeRatio;
        };
    }
    return self;
}

@end

@implementation UIView (KSLayout)
- (void)setSubviewsStacked:(NSArray *)subviews layoutDirection:(KSLayoutDirection)direction {
    [self setSubviewsStacked:subviews layoutDirection:direction settings:nil];
}

- (void)setSubviewsStacked:(NSArray *)subviews layoutDirection:(KSLayoutDirection)direction settings:(void (^)(KSLayoutSettings*))settingsBlock {
    KSLayoutSettings *settings = [[KSLayoutSettings alloc] init];
    if (settingsBlock) settingsBlock(settings);

    if (settings.autoRemoveSubviews) [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIView *lastView;
    for (UIView *view in subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];

        NSDictionary *views = @{@"view" : view, @"lastView" : lastView ?: [[UIView alloc] init]};
		
        NSUInteger subviewIndex = [subviews indexOfObject:view];
        CGFloat subviewSpacing = settings.subviewSpacingBlock(lastView, view, subviewIndex);
        CGFloat subviewSize = settings.subviewSizeBlock(view, subviewIndex);
        CGFloat subviewSizeRatio = settings.subviewSizeRatioBlock(view, subviewIndex);
        
		if (direction == KSLayoutDirectionVertical) {
			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-%f-[view]-%f-|", settings.containerPadding.left, settings.containerPadding.right] options:kNilOptions metrics:nil views:views]];
			if (!lastView) {
				[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[view]", settings.containerPadding.top] options:kNilOptions metrics:nil views:views]];
			} else {
				[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[lastView]-%f-[view]", subviewSpacing] options:kNilOptions metrics:nil views:views]];
			}
			
			if (view == subviews.lastObject) {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
                constraint.priority = 999;
                [self addConstraint:constraint];
			}
		} else {
			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[view]-%f-|", settings.containerPadding.top, settings.containerPadding.bottom] options:kNilOptions metrics:nil views:views]];
			if (!lastView) {
				[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-%f-[view]", settings.containerPadding.left] options:kNilOptions metrics:nil views:views]];
			} else {
				[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"[lastView]-%f-[view]", subviewSpacing] options:kNilOptions metrics:nil views:views]];
			}
			
			if (view == subviews.lastObject) {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
                constraint.priority = 999;
				[self addConstraint:constraint];
			}
		}
		
        if (subviewSizeRatio != CGFLOAT_MIN) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:direction == KSLayoutDirectionVertical ? NSLayoutAttributeHeight : NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:KSLayoutDirectionVertical ? NSLayoutAttributeHeight : NSLayoutAttributeWidth multiplier:subviewSizeRatio constant:0]];
            
        } else if (subviewSize != CGFLOAT_MIN) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:direction == KSLayoutDirectionVertical ? NSLayoutAttributeHeight : NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:subviewSize]];
        }

        lastView = view;
    }
}


@end