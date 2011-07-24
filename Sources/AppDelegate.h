@class NSObject;
@class UIWindow;
@class MainListTableViewController;

@interface AppDelegate: NSObject <UIApplicationDelegate>
{
    UIWindow *_window;
    MainListTableViewController *mainListTableViewController;
}
@end
