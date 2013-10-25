#import "LoginViewController.h"

#import "FTPViewController.h"

#define kFTPViewControllerLastHost @"kFTPViewControllerLastHost"
#define kFTPViewControllerLastUser @"kFTPViewControllerLastUser"

@implementation LoginViewController

- (id)init 
{
    if (self = [super initWithNibName:nil bundle:nil])
	{
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(textFieldTextDidChangeNotification:)
													 name:UITextFieldTextDidChangeNotification
												   object:nil];
    }
	
    return self;
}

- (void)loadView 
{
	[super loadView];
	
    //Build UI
    
    hostTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0,
                                                                  10.0 + 64.0,
                                                                  self.view.frame.size.width - 20.0,
                                                                  30.0)];
	hostTextField.delegate = self;
	hostTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	hostTextField.borderStyle = UITextBorderStyleRoundedRect;
	hostTextField.placeholder = NSLocalizedString(@"FTP Server Address", @"Headline for FTP server address");
	hostTextField.clearButtonMode = UITextFieldViewModeAlways;
	hostTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	hostTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	hostTextField.returnKeyType =  UIReturnKeyNext;
	hostTextField.keyboardType =  UIKeyboardTypeURL;
	hostTextField.enablesReturnKeyAutomatically = YES;
    hostTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kFTPViewControllerLastHost];
	[self.view addSubview:hostTextField];
    
    userTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0,
                                                                  hostTextField.frame.origin.y + hostTextField.frame.size.height + 10.0,
                                                                  self.view.frame.size.width - 20.0,
                                                                  30.0)];
	userTextField.delegate = self;
	userTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	userTextField.borderStyle = UITextBorderStyleRoundedRect;
	userTextField.placeholder = NSLocalizedString(@"Username", @"Headline for username textfield");
	userTextField.clearButtonMode = UITextFieldViewModeAlways;
	userTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	userTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	userTextField.returnKeyType =  UIReturnKeyNext;
	userTextField.keyboardType =  UIKeyboardTypeDefault;
	userTextField.enablesReturnKeyAutomatically = YES;
    userTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kFTPViewControllerLastUser];
	[self.view addSubview:userTextField];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0,
                                                                      userTextField.frame.origin.y + userTextField.frame.size.height + 10.0,
                                                                      self.view.frame.size.width - 20.0,
                                                                      30.0)];
	passwordTextField.delegate = self;
	passwordTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
	passwordTextField.placeholder = NSLocalizedString(@"Password", @"Headline for password textfield");
	passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
	passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	passwordTextField.returnKeyType =  UIReturnKeyNext;
	passwordTextField.keyboardType =  UIKeyboardTypeDefault;
    passwordTextField.secureTextEntry = YES;
	passwordTextField.enablesReturnKeyAutomatically = YES;
	[self.view addSubview:passwordTextField];
    
    connectButton = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
    connectButton.frame = CGRectMake(10.0,
                                     passwordTextField.frame.origin.y + passwordTextField.frame.size.height + 13.0,
                                     self.view.frame.size.width - 20.0,
                                     37.0);
	connectButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[connectButton setTitle:NSLocalizedString(@"Connect", @"Title of 'Connect' Button") forState:UIControlStateNormal];
	[connectButton addTarget:self action:@selector(connectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	connectButton.enabled = NO;
	[self.view addSubview:connectButton];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [hostTextField release];
    [userTextField release];
    [passwordTextField release];
    
    [connectButton release];
    
    [super dealloc];
}



#pragma mark ---
#pragma mark Actions
#pragma mark ---
- (void)connectButtonAction:(id)sender
{
    //Save User input for later
    [[NSUserDefaults standardUserDefaults] setObject:hostTextField.text forKey:kFTPViewControllerLastHost];
    [[NSUserDefaults standardUserDefaults] setObject:userTextField.text forKey:kFTPViewControllerLastUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Present FTP content at root path.
    DZFTPLocation *ftpLocation = [DZFTPLocation locationWithHost:hostTextField.text path:nil username:userTextField.text password:passwordTextField.text];
    FTPViewController *controller = [[FTPViewController alloc] initWithLocation:ftpLocation];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}



#pragma mark ---
#pragma mark UITextField Notfications
#pragma mark ---
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
	connectButton.enabled = [hostTextField.text length] > 0;
}



#pragma mark ---
#pragma mark UITextField delegate
#pragma mark ---
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([textField isEqual:hostTextField])
	{
		[userTextField becomeFirstResponder];
	}
    else if ([textField isEqual:userTextField])
    {
        [passwordTextField becomeFirstResponder];
    }
    else if ([textField isEqual:passwordTextField])
    {
        [self performSelector:@selector(connectButtonAction:) withObject:connectButton];
    }
    
	return YES;
}

@end
