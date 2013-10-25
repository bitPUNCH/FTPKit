#import <Foundation/Foundation.h>
#import "DZFTPLocation.h"

#define kDZFTPRequestBufferSize 32768

@interface DZFTPRequest : NSObject
{
    DZFTPLocation *location;
}

@property (nonatomic, retain, readonly) DZFTPLocation *location;

- (id)initWithLocation:(DZFTPLocation *)location;

- (void)start;
- (void)cancel;

@end