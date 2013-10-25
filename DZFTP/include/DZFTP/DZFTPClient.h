#import <Foundation/Foundation.h>

#import "DZFTPItem.h"
#import "DZFTPLocation.h"
#import "DZFTPRequest.h"


@protocol DZFTPClientDelegate;


@interface DZFTPClient : NSObject
{
    id<DZFTPClientDelegate> delegate;
    
	NSMutableArray *requests;
	DZFTPLocation *location;
}

@property (nonatomic, assign) id<DZFTPClientDelegate> delegate;

@property (nonatomic, retain, readonly) DZFTPLocation* location;

- (id)initWithHost:(NSString *)host username:(NSString *)username password:(NSString* )password;
- (id)initWithLocation:(DZFTPLocation *)location;

+ (DZFTPClient *)clientWithHost:(NSString *)host username:(NSString *)username password:(NSString* )password;
+ (DZFTPClient *)clientWithLocation:(DZFTPLocation *)location;


- (DZFTPRequest *)listDirectoryInCurrentLocationShowHiddenItems:(BOOL)showHiddenItems;
- (DZFTPRequest *)listDirectory:(NSString *)path showHiddenItems:(BOOL)showHiddenItems;

- (DZFTPRequest *)downloadFileInCurrentLocation:(NSString *)fileName toDestination:(NSString *)destinationPath;
- (DZFTPRequest *)downloadFile:(NSString *)sourcePath toDestination:(NSString *)destinationPath;
- (DZFTPRequest *)downloadItem:(DZFTPItem *)item toDestination:(NSString *)destinationPath;

- (DZFTPRequest *)uploadFileToCurrentLocation:(NSString *)sourcePath;
- (DZFTPRequest *)uploadFile:(NSString *)sourcePath toDestination:(NSString *)destinationPath;

- (DZFTPRequest *)createDirectoryInCurrentLocation:(NSString *)named;
- (DZFTPRequest *)createDirectory:(NSString *)named inParentDirectory:(NSString *)parentDirectory;

- (DZFTPRequest *)deleteFileInCurrentLocation:(NSString *)fileName;
- (DZFTPRequest *)deleteFile:(NSString *)filePath;

- (DZFTPRequest *)chmodFileInCurrentLocation:(NSString *)fileName toMode:(int)mode;
- (DZFTPRequest *)chmodFile:(NSString *)filePath toMode:(int)mode;
- (DZFTPRequest *)chmodItem:(DZFTPItem *)item toMode:(int)mode;

@end



@protocol DZFTPClientDelegate <NSObject>

@optional

- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didListItems:(NSArray *)items;
- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didDownloadFile:(NSURL *)sourceURL toDestination:(NSString *)destinationPath;
- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didUploadFile:(NSString *)sourcePath toDestination:(NSURL *)destinationURL;
- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didMakeDirectory:(NSURL *)directoryURL;
- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didDeleteFile:(NSURL *)fileURL;
- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didChmodFile:(NSURL *)fileURL toMode:(int)mode;

- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didUpdateProgress:(float)progress;
- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didFailWithError:(NSError *)error;
- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didUpdateStatus:(NSString *)status;
- (void)client:(DZFTPClient *)client requestDidCancel:(DZFTPRequest *)request;

@end