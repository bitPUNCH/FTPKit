#import <Foundation/Foundation.h>
#import "DZFTPLocation.h"

typedef enum {
	DZFTPItemTypeUnknown = 0,
	DZFTPItemTypeFIFO = 1,
	DZFTPItemTypeCharacterDevice = 2,
	DZFTPItemTypeDirectory = 4,
	DZFTPItemTypeBLL = 6,
	DZFTPItemTypeFile = 8,
	DZFTPItemTypeLink = 10,
	DZFTPItemTypeSocket = 12,
	DZFTPItemTypeWHT = 14
} DZFTPItemType;

@interface DZFTPItem : NSObject
{
	NSDate *modified;
	NSString *owner;
	NSString *group;
	NSString *link;
	NSString *name;
	unsigned long long size;
	DZFTPItemType type;
	int mode;
	DZFTPLocation *parent;
}

@property (nonatomic, retain) NSDate *modified;
@property (nonatomic, retain) NSString *owner;
@property (nonatomic, retain) NSString *group;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) unsigned long long size;
@property (nonatomic, assign) DZFTPItemType type;
@property (nonatomic, assign) int mode;

@property (nonatomic, retain) DZFTPLocation *parent;

@property (nonatomic, retain, readonly) NSURL *url;
@property (nonatomic, retain, readonly) NSURL *fullURL;
@property (nonatomic, retain, readonly) NSString *permissions;

- (id)initWithDictionary:(NSDictionary *)item;
+ (DZFTPItem *)itemWithDictionary:(NSDictionary *)item;

- (DZFTPLocation *)location;

@end
