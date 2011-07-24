#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DetailTableViewController.h"

static NSString *kSectionTitle = @"Detailed Info";
static NSString *kCellIdentifierForName = @"nameCell";
static NSString *kCellIdentifierForDetail = @"detailCell";
static NSString *kNameFieldFormat = @"Name: %@";
static NSString *kDetailFormat = @"Info:";

typedef enum {
    kNameFieldIndex,
    kDetailFieldIndex
} FieldIndexType;

@implementation DetailTableViewController

#pragma mark -
#pragma mark NSObject

- (void)dealloc
{
    [_detailedInfo release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewController

- (UINavigationItem *)navigationItem
{
    UINavigationItem *navItem = [super navigationItem];
    [navItem setTitle:@"Detail list"];
    return navItem;
}

#pragma mark -
#pragma mark DetailTableViewController

- (id)initWithDetailedInfo:(NSDictionary *)detailedInfo
{
    if ((self = [super initWithStyle:UITableViewStyleGrouped]) != nil)
        _detailedInfo = [detailedInfo copy];
    return self;
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)   tableView:(UITableView *)tableView
  titleForHeaderInSection:(NSInteger)section
{
    return kSectionTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    switch ([indexPath row]) {
        case kNameFieldIndex:
            cell = [tableView dequeueReusableCellWithIdentifier:
                    kCellIdentifierForName];
            if (cell == nil)
                cell = [[[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                            reuseIdentifier:kCellIdentifierForName]
                        autorelease];
            [[cell textLabel] setText:
                    [NSString stringWithFormat:
                        kNameFieldFormat, [_detailedInfo valueForKey:@"name"]]];
            break;
        case kDetailFieldIndex:
            cell = [tableView dequeueReusableCellWithIdentifier:
                    kCellIdentifierForDetail];
            if (cell == nil)
                cell = [[[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleSubtitle
                            reuseIdentifier:kCellIdentifierForDetail]
                        autorelease];
            [[cell textLabel] setText:kDetailFormat];
            [[cell detailTextLabel] setText:
                    [_detailedInfo valueForKey:@"description"]];
            break;
    }
    return cell;
}
@end
