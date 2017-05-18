#import "JCNotificationBannerPresenter.h"
#import "JCNotificationBannerPresenter_Private.h"
#import "JCNotificationBannerView.h"
#import "JCNotificationBannerWindow.h"
#import "JCNotificationBannerViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation JCNotificationBannerPresenter

- (id) init {
    if (self = [super init])
    {
        _bannerHeight = 64.0f;
        _bannerPadding = 5.0f;
        _backgroundColor = [UIColor colorWithRed:0.09 green:0.09 blue:0.09 alpha:1.00];
        _textColor = [UIColor whiteColor];
    }
    return self;
}

// JCNotificationCenter calls this whenever a presenter
// is about to be used to present one or more notifications.
// It is guaranteed to be called exactly once before presentNotification:finished:.
- (void) willBeginPresentingNotifications {
  bannerWindow = [self newWindow];
}

// JCNotificationCenter calls this whenever it has finished
// using a presenter to present notifications.
// It is guaranteed to be called exactly once after
// one or more calls to presentNotification:finished:.
- (void) didFinishPresentingNotifications {
  bannerWindow.hidden = YES;
  [bannerWindow removeFromSuperview];
  bannerWindow.rootViewController = nil;
  bannerWindow = nil;
}

- (void) presentNotification:(JCNotificationBanner*)notification
                    inWindow:(JCNotificationBannerWindow*)window
                    finished:(JCNotificationBannerPresenterFinishedBlock)finished {
    notification.backgroundColor = self.backgroundColor;
    notification.textColor = self.textColor;
    JCNotificationBannerView* banner = [self newBannerViewForNotification:notification];
    
    JCNotificationBannerViewController* bannerViewController = [JCNotificationBannerViewController new];
    window.rootViewController = bannerViewController;
    UIView* originalControllerView = bannerViewController.view;
    
    UIView* containerView = [self newContainerViewForNotification:notification];
    [containerView addSubview:banner];
    bannerViewController.view = containerView;
    
    window.bannerView = banner;
    
    containerView.bounds = originalControllerView.bounds;
    containerView.transform = originalControllerView.transform;
    [banner getCurrentPresentingStateAndAtomicallySetPresentingState:YES];
    
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    CGSize bannerSize = CGSizeMake(originalControllerView.bounds.size.width - (_bannerPadding * 2.0f), _bannerHeight);
    // Center the banner horizontally.
    CGFloat x = (MAX(statusBarSize.width, statusBarSize.height) / 2) - (bannerSize.width / 2);
    // Position the banner offscreen vertically.
    CGFloat y = -_bannerHeight;
    
    banner.frame = CGRectMake(x, y, bannerSize.width, bannerSize.height);
    
    JCNotificationBannerTapHandlingBlock originalTapHandler = banner.notificationBanner.tapHandler;
    JCNotificationBannerTapHandlingBlock wrappingTapHandler = ^{
        if ([banner getCurrentPresentingStateAndAtomicallySetPresentingState:NO]) {
            if (originalTapHandler) {
                originalTapHandler();
            }
            
            [banner removeFromSuperview];
            finished();
            // Break the retain cycle
            notification.tapHandler = nil;
        }
    };
    banner.notificationBanner.tapHandler = wrappingTapHandler;
    
    // Slide it down while fading it in.
    banner.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect newFrame = CGRectOffset(banner.frame, 0, banner.frame.size.height + _bannerPadding);
                         banner.frame = newFrame;
                         banner.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         // Empty.
                     }];
    
    
    // On timeout, slide it up while fading it out.
    if (notification.timeout > 0.0) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, notification.timeout * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 banner.frame = CGRectOffset(banner.frame, 0, -(banner.frame.size.height + _bannerPadding));
                                 banner.alpha = 0;
                             } completion:^(BOOL didFinish) {
                                 if ([banner getCurrentPresentingStateAndAtomicallySetPresentingState:NO]) {
                                     [banner removeFromSuperview];
                                     [containerView removeFromSuperview];
                                     finished();
                                     // Break the retain cycle
                                     notification.tapHandler = nil;
                                 }
                             }];
        });
    }
}

// JCNotificationCenter calls this each time a notification should be presented.
// You can take as long as you like, but make sure you call finished() whenever
// you are ready to display the next notification, if any.
//
// If you do not require a window, override -willBeginPresentingNotifications,
// -didFinishPresentingNotifications, and do whatever windowless thing you like.
- (void) presentNotification:(JCNotificationBanner*)notification
                    finished:(JCNotificationBannerPresenterFinishedBlock)finished {
    [self presentNotification:notification
                     inWindow:bannerWindow
                     finished:finished];

}

#pragma mark - View helpers

- (JCNotificationBannerWindow*)newWindow {
    JCNotificationBannerWindow* window = [[JCNotificationBannerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    window.userInteractionEnabled = YES;
    window.autoresizesSubviews = YES;
    window.opaque = NO;
    window.hidden = NO;
    window.windowLevel = UIWindowLevelStatusBar;
    return window;
}

- (UIView*) newContainerViewForNotification:(JCNotificationBanner*)notification {
    UIView* container = [UIView new];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    container.userInteractionEnabled = YES;
    container.opaque = NO;
    container.autoresizesSubviews = YES;
    return container;
}

- (JCNotificationBannerView*) newBannerViewForNotification:(JCNotificationBanner*)notification {
    JCNotificationBannerView* view = [[JCNotificationBannerView alloc]
                                    initWithNotification:notification];
    view.userInteractionEnabled = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
                            UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleRightMargin;
    return view;
}

@end
