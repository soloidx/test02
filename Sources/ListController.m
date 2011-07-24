#import <stdlib.h>
#import <Foundation/Foundation.h>
#import "ListController.h"

static NSString *kFileName = @"array.nib";

@implementation NSString (random)
+ (NSString *)generateRandomWord
{
    NSInteger len = rand () % 10 + 10;
    NSInteger i;
    NSMutableString *stringTemp = [NSMutableString string];

    srandomdev();
    for (i = 0; i < len; i++) {
        char randomChar = (unsigned char)random() % 26 + 97;

        [stringTemp appendFormat:@"%c", randomChar];
    }
    return stringTemp;
}
@end

@implementation ListController
#pragma mark -
#pragma mark NSObject

- (void) dealloc
{
    [_superList release];
    [_listDetail release];
    [super dealloc];
}

#pragma mark -
#pragma mark ListController
@synthesize superList = _superList;
@synthesize listDetail = _listDetail;

+ (void)generateRandomList
{
    //search for the file array.nib using nsPredicate and filemanager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSApplicationSupportDirectory
                    inDomains:NSUserDomainMask];
    NSError *appSupportDirError;

    if ([urls count] == 0) {
        return;
    }
    
    NSString *appSupportDir = [(NSURL *)[urls objectAtIndex:0] path];
    NSError *createAppSuportDirError;
    
    if (![fileManager fileExistsAtPath:appSupportDir])
        [fileManager createDirectoryAtPath:appSupportDir
            withIntermediateDirectories:YES
            attributes:nil error:&createAppSuportDirError];
    
    NSArray *contents =
            [fileManager contentsOfDirectoryAtPath:appSupportDir 
                error:&appSupportDirError];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                @"SELF like[cd] %@", kFileName];

    NSArray *arrFile = [contents filteredArrayUsingPredicate:predicate];
    if ([arrFile count] > 0)
        return;

    //generate a list in .nib files
    NSMutableArray *superList = [NSMutableArray array];
    int i;
    BOOL hasError = NO;

    for (i = 0; i < 10; i++) {
        NSDictionary *aDetail = [NSDictionary 
                dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInteger:i], @"id",
                    [NSString generateRandomWord], @"name",
                    [NSString generateRandomWord], @"description", nil];

        [superList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
            [aDetail objectForKey:@"id"], @"id", 
            [aDetail objectForKey:@"name"], @"name", nil]];
        if (![NSKeyedArchiver archiveRootObject:aDetail 
                toFile:[appSupportDir stringByAppendingFormat:@"/%i.nib", i]])
            hasError = YES;
    }

    if (!hasError)
        [NSKeyedArchiver archiveRootObject:superList
                toFile:[NSString stringWithFormat:@"%@/%@", 
                    appSupportDir, kFileName]];
}

- (void)readSuperListWithFileName:(NSError **)error
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSApplicationSupportDirectory
            inDomains:NSUserDomainMask];

    if ([urls count] == 0) {
        *error = [NSError errorWithDomain:@"Library/Application Support/ "
                @"doesn't exists" code:6 userInfo:nil];
        return;
    }

    NSString *filePath =
            [[(NSURL *)[urls objectAtIndex:0]
                URLByAppendingPathComponent:kFileName] path];

    if (![fileManager fileExistsAtPath:filePath]) {
        *error = [NSError errorWithDomain:
                [NSString stringWithFormat:@"File %@ doesn't exist", filePath]
                code:7 userInfo:nil];
        return;
    }
    
    id unarchived = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

    if (![unarchived isKindOfClass:[NSArray class]]) {
        *error = [NSError errorWithDomain:
                [NSString stringWithFormat:@"File %@ is corrupted", filePath]
                code:8 userInfo:nil];
        return;
    }
    [_superList autorelease];
    _superList = [unarchived retain];
}
@end
