@class NSString;
@class NSObject;
@class NSMutableArray;
@class NSMutableDictionary;

@interface NSString (random)
+ (NSString *)generateRandomWord;
@end

@interface ListController : NSObject
{
    NSMutableArray *_superList;
    NSMutableDictionary *_listDetail;
}
@property (nonatomic, retain) NSMutableArray *superList;
@property (nonatomic, retain) NSMutableDictionary *listDetail;

+ (void)generateRandomList;

- (void)readSuperListWithFileName:(NSError **)error;
@end
