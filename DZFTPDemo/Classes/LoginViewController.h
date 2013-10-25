#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *hostTextField;
    UITextField *userTextField;
    UITextField *passwordTextField;
    
    UIButton *connectButton;
}

@end
