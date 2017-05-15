#import "JCNotificationBannerViewIOS7Style.h"

@implementation JCNotificationBannerViewIOS7Style

- (id) initWithNotification:(JCNotificationBanner*)notification {
  self = [super initWithNotification:notification];
  if (self) {
    self.titleLabel.textColor = [UIColor whiteColor];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithRed:40.f/255.f green:174.f/255.f blue:74.f/255.f alpha:1];

    /*self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOpacity = 0.8;*/
  }
  return self;
}

/** Overriden to do no custom drawing */
- (void) drawRect:(CGRect)rect {
}

@end
