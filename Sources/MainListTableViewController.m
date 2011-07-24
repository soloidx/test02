#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MainListTableViewController.h"
#import "DetailTableViewController.h"

@implementation MainListTableViewController

#pragma mark -
#pragma mark NSObject

- (void)dealloc
{
    [_listController release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if ((self = [super initWithStyle:style]) != nil) {
        _listController = [[ListController alloc] init];
        NSError *error = nil;
        [ListController generateRandomList];
        [_listController readSuperListWithFileName:&error];
        if (error != nil)
            NSLog(@"%@", error);
    }
    return self;
}

- (UINavigationItem *)navigationItem
{
    UINavigationItem *navItem = [super navigationItem];
    [navItem setTitle:@"Super list"];
    return navItem;
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)   tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [[_listController superList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier] autorelease];
        [[cell textLabel] setText:
                [[[_listController superList]
                    objectAtIndex:[indexPath row]] valueForKey:@"name"]];
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSNumber *elementId = [[[_listController superList]
            objectAtIndex:[indexPath row]] valueForKey:@"id"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSApplicationSupportDirectory
            inDomains:NSUserDomainMask];
    NSError *error = nil;

    if ([urls count] == 0) {
        error = [NSError errorWithDomain:@"Library/Application Support/ "
                @"doesn't exist" code:6 userInfo:nil];
        NSLog(@"%@", error);
        return;
    }

    NSString *actualNib = [NSString stringWithFormat:@"%@.nib", elementId];
    NSString *filePath =
            [[(NSURL *)[urls objectAtIndex:0]
               URLByAppendingPathComponent:actualNib] path];

    if (![fileManager fileExistsAtPath:filePath]) {
        error = [NSError errorWithDomain:
                [NSString stringWithFormat:@"File %@ doesn't exist", filePath]
                code:7 userInfo:nil];
        NSLog(@"%@", error);
        return;
    }

    NSDictionary * detailInfo =
        [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

    if (![detailInfo isKindOfClass:[NSDictionary class]]) {
        error = [NSError errorWithDomain:
                [NSString stringWithFormat:@"File %@ is corrupted", filePath]
                code:8 userInfo:nil];
        NSLog(@"%@", error);
        return;
    }

    DetailTableViewController *detailController =
            [[[DetailTableViewController alloc] 
                initWithDetailedInfo:detailInfo] autorelease];
    UINavigationController *navController = (UINavigationController *)
            [[[UIApplication sharedApplication] keyWindow] rootViewController];

    [navController pushViewController:(UIViewController *)detailController
            animated:YES];
}
@end
