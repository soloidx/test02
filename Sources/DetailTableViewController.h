@class NSDictionary;
@class UITableViewController;

@interface DetailTableViewController: UITableViewController
{
    NSDictionary *_detailedInfo;
}

- (id)initWithDetailedInfo:(NSDictionary *)detailedInfo;
@end
