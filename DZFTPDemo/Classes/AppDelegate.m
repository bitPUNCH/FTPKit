#import "AppDelegate.h"

#import "LoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    LoginViewController *controller = [[LoginViewController alloc] init];
    UINavigationController *rootViewControler = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = rootViewControler;
    [controller release];
    [rootViewControler release];
    
    return YES;
}

- (void)dealloc
{
    [self.window release];
    
    [super dealloc];
}


@end
