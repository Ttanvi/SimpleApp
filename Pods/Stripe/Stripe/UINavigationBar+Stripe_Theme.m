//
//  UINavigationBar+Stripe_Theme.m
//  Stripe
//
//  Created by Jack Flintermann on 5/17/16.
//  Copyright © 2016 Stripe, Inc. All rights reserved.
//

#import "UINavigationBar+Stripe_Theme.h"
#import "STPTheme.h"
#import "STPColorUtils.h"
#import <objc/runtime.h>

static NSInteger const STPNavigationBarHairlineViewTag = 787473;

@implementation UINavigationBar (Stripe_Theme)


- (STPTheme *)stp_theme {
    return objc_getAssociatedObject(self, @selector(stp_theme));
}

- (void)setStp_theme:(STPTheme *)theme {
    objc_setAssociatedObject(self, @selector(stp_theme), theme, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self stp_hairlineImageView].hidden = (theme != nil);

    if (!theme) {
        return;
    }

    [self stp_artificialHairlineView].backgroundColor = theme.tertiaryBackgroundColor;
    self.barTintColor = theme.secondaryBackgroundColor;
    self.tintColor = theme.accentColor;
    self.barStyle = theme.barStyle;
    self.translucent = theme.translucentNavigationBar;
    self.titleTextAttributes = @{
                                 NSFontAttributeName: theme.emphasisFont,
                                 NSForegroundColorAttributeName: theme.primaryForegroundColor,
                                 };
}


- (void)stp_setTheme:(STPTheme *)theme {
    [self setStp_theme:theme];
}

- (UIView *)stp_artificialHairlineView {
    UIView *view = [self viewWithTag:STPNavigationBarHairlineViewTag];
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds), CGRectGetWidth(self.bounds), 0.5f)];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        view.tag = STPNavigationBarHairlineViewTag;
        [self addSubview:view];
    }
    return view;
}

- (UIImageView *)stp_hairlineImageView {
    return [self stp_hairlineImageView:self];
}

- (UIImageView *)stp_hairlineImageView:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self stp_hairlineImageView:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end

void linkUINavigationBarThemeCategory(void){}
