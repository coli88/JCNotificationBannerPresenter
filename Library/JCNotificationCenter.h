#import <Foundation/Foundation.h>
#import "JCNotificationBanner.h"

@class JCNotificationBannerPresenter;

@interface JCNotificationCenter : NSObject

@property (nonatomic) JCNotificationBannerPresenter* presenter;

+ (JCNotificationCenter*) sharedCenter;

/** Adds notification to queue with given parameters. */
+ (void) enqueueNotificationWithTitle:(NSString*)title
                              message:(NSString*)message
                                 icon:(UIImage*)image
                           tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

@end
