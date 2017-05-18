#import "JCNotificationPresenterDemoViewController.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenter.h"

@interface JCNotificationPresenterDemoViewController ()

@property (weak, nonatomic) IBOutlet UITextField* titleTextField;
@property (weak, nonatomic) IBOutlet UITextView* messageTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl* styleSwitch;

@end

@implementation JCNotificationPresenterDemoViewController

- (IBAction) presentNotificationButtonTapped:(id)sender
{
    [JCNotificationCenter enqueueNotificationWithTitle:self.titleTextField.text
                                               message:self.messageTextView.text
                                                  icon:[UIImage imageNamed:@"Mixers.png"]
                                            tapHandler:^{
                                                UIAlertView* alert = [[UIAlertView alloc]
                                                                      initWithTitle:@"Tapped notification"
                                                                      message:@"Perform some custom action on notification tap event..."
                                                                      delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                                [alert show];
                                            }];
}

- (void) viewDidUnload {
  [self setMessageTextView:nil];
  [self setTitleTextField:nil];
  [super viewDidUnload];
}

@end
