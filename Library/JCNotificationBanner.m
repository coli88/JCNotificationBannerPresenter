#import "JCNotificationBanner.h"

@implementation JCNotificationBanner

@synthesize title;
@synthesize message;
@synthesize timeout;
@synthesize tapHandler;

- (JCNotificationBanner*) initWithTitle:(NSString*)_title
                                message:(NSString*)_message
                                   icon:(UIImage*)image
                             tapHandler:(JCNotificationBannerTapHandlingBlock)_tapHandler
{
    self = [super init];
    if (self) {
        self.title = _title;
        self.message = _message;
        self.image = image;
        self.timeout = 2.0;
        self.tapHandler = _tapHandler;
    }
    return self;
}

@end
