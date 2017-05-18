#import <Foundation/Foundation.h>
#import "JCNotificationBanner.h"

typedef void (^JCNotificationBannerPresenterFinishedBlock)();

@class JCNotificationBannerWindow;

@interface JCNotificationBannerPresenter : NSObject

@property (nonatomic, assign) CGFloat bannerMaxWidth;
@property (nonatomic, assign) CGFloat bannerHeight;
@property (nonatomic, assign) CGFloat bannerPadding;
@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic, strong) UIColor* textColor;

- (void)willBeginPresentingNotifications;
- (void)didFinishPresentingNotifications;
- (void) presentNotification:(JCNotificationBanner*)notification
                    finished:(JCNotificationBannerPresenterFinishedBlock)finished;

@end
