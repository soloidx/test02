#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MainListTableViewController.h"

@implementation AppDelegate

#pragma mark -
#pragma mark NSObject

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

#pragma mark -
#pragma mark <UIApplicationDelegate>

/*
 * Solo alineación en implementación y prototipos
 */

- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)options
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mainListTableViewController = [[MainListTableViewController alloc] init];

    UINavigationController *navController = [[UINavigationController alloc]
            initWithRootViewController:mainListTableViewController];

    [_window setRootViewController:navController];
    [_window makeKeyAndVisible];
    return YES;
}
@end
