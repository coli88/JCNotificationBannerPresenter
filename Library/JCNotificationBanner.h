#import <Foundation/Foundation.h>

typedef void (^JCNotificationBannerTapHandlingBlock)();

@interface JCNotificationBanner : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* message;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, copy) JCNotificationBannerTapHandlingBlock tapHandler;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) UIColor* backgroundColor;
@property (strong, nonatomic) UIColor* textColor;

- (JCNotificationBanner*) initWithTitle:(NSString*)title
                                message:(NSString*)message
                                   icon:(UIImage*)image
                             tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

@end
