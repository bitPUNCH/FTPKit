#import <Foundation/Foundation.h>

@interface DZFTPLocation : NSObject
{
	NSString *username;
	NSString *password;
	NSURL *url;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSURL *url;

@property (nonatomic, assign, readonly) int port;
@property (nonatomic, retain, readonly) NSString *host;
@property (nonatomic, retain, readonly) NSString *path;

@property (nonatomic, retain, readonly) NSURL *fullURL;

@property (nonatomic, retain, readonly) NSString *name;

- (id)initWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url username:(NSString *)username password:(NSString *)password;
- (id)initWithHost:(NSString *)host path:(NSString *)path username:(NSString *)username password:(NSString *)password;

+ (DZFTPLocation *)locationWithURL:(NSURL *)url;
+ (DZFTPLocation *)locationWithURL:(NSURL *)url username:(NSString *)username password:(NSString *)password;
+ (DZFTPLocation *)locationWithHost:(NSString *)host path:(NSString *)path username:(NSString *)username password:(NSString *)password;

@end