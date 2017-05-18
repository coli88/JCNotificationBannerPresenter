#import "JCNotificationBannerView.h"

const CGFloat kJCNotificationBannerViewMarginX = 10.0;
const CGFloat kJCNotificationBannerViewMarginY = 10.0;
const CGFloat kJCNotificationBannerViewIconTextPadding = 15.0f;
const CGFloat kJCNotificationBannerViewTextPadding = 5.0f;

@interface JCNotificationBannerView ()
{
    BOOL isPresented;
    NSObject* isPresentedMutex;
}

- (void) handleSingleTap:(UIGestureRecognizer*)gestureRecognizer;

@end

@implementation JCNotificationBannerView

- (id) initWithNotification:(JCNotificationBanner*)notification {
    self = [super init];
    
    if (self)
    {
        isPresentedMutex = [NSObject new];
        self.backgroundColor = [UIColor colorWithRed:0.09 green:0.09 blue:0.09 alpha:1.00];
        
        self.iconImageView = [UIImageView new];
        
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.iconImageView];
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        self.messageLabel = [UILabel new];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.font = [UIFont systemFontOfSize:16];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.numberOfLines = 0;
        [self addSubview:self.messageLabel];

        UITapGestureRecognizer* tapRecognizer;
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:tapRecognizer];

        self.notificationBanner = notification;
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    if (self.frame.size.width <= 0)
    {
        return;
    }

    BOOL hasIcon = _notificationBanner ? (_notificationBanner.image != nil) : NO;
    BOOL hasTitle = _notificationBanner ? (_notificationBanner.title.length > 0) : NO;
    BOOL hasMessage = _notificationBanner ? (_notificationBanner.message.length > 0) : NO;

    CGFloat borderY = kJCNotificationBannerViewMarginY;
    CGFloat borderX = kJCNotificationBannerViewMarginX;
    CGFloat currentX = borderX;
    CGFloat currentY = borderY;
    CGFloat contentWidth = self.frame.size.width - (borderX * 2.0f);

    if (hasIcon)
    {
        CGFloat iconSize = self.frame.size.height - (borderY * 2.0f);
        _iconImageView.frame = CGRectMake(currentX, currentY, iconSize, iconSize);
        currentX += iconSize + kJCNotificationBannerViewIconTextPadding;
        contentWidth -= (iconSize + kJCNotificationBannerViewIconTextPadding);
    }
    
    if (hasTitle)
    {
        if (!hasMessage)
        {
            currentY = (self.frame.size.height * 0.5) - (self.titleLabel.font.pointSize * 0.5);
        }
        self.titleLabel.frame = CGRectMake(currentX, currentY, contentWidth, self.titleLabel.font.pointSize);
        currentY += self.titleLabel.font.pointSize + kJCNotificationBannerViewTextPadding;
    }
    
    CGFloat messageLabelHeight = (self.frame.size.height - borderY) - currentY;
    if (!hasTitle)
    {
        currentY = (self.frame.size.height * 0.5) - (messageLabelHeight * 0.5);
    }
    self.messageLabel.frame = CGRectMake(currentX, currentY, contentWidth, messageLabelHeight);
    [self.messageLabel sizeToFit];
    CGRect messageFrame = self.messageLabel.frame;
    
    CGFloat spillY = (currentY + messageFrame.size.height + kJCNotificationBannerViewMarginY) - self.frame.size.height;
    if (spillY > 0.0)
    {
        messageFrame.size.height -= spillY;
        if (!hasTitle)
        {
            messageFrame.origin.y = (self.frame.size.height * 0.5) - (messageFrame.size.height * 0.5);
        }
        self.messageLabel.frame = messageFrame;
    }
    
    if (!hasTitle && messageFrame.size.height < messageLabelHeight)
    {
        messageFrame.origin.y = (self.frame.size.height * 0.5) - (messageFrame.size.height * 0.5);
        self.messageLabel.frame = messageFrame;
    }
}

- (void) setNotificationBanner:(JCNotificationBanner*)notification
{
    _notificationBanner = notification;

    self.titleLabel.text = notification.title;
    self.messageLabel.text = notification.message;
    if (notification.image != nil)
    {
        self.iconImageView.image = notification.image;
    }
    if (notification.backgroundColor != nil)
    {
        self.backgroundColor = notification.backgroundColor;
    }
    if (notification.textColor != nil)
    {
        self.titleLabel.textColor = notification.textColor;
        self.messageLabel.textColor = notification.textColor;
    }
}

- (void) handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (_notificationBanner && _notificationBanner.tapHandler)
    {
        _notificationBanner.tapHandler();
    }
}

- (BOOL) getCurrentPresentingStateAndAtomicallySetPresentingState:(BOOL)state
{
    @synchronized(isPresentedMutex)
    {
        BOOL originalState = isPresented;
        isPresented = state;
        return originalState;
    }
}

@end
