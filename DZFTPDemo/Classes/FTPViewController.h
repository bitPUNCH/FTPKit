#import <UIKit/UIKit.h>

#import <DZFTP/DZFTP.h>

@interface FTPViewController : UITableViewController <DZFTPClientDelegate, UIActionSheetDelegate>
{
    UIActivityIndicatorView *activityIndicator;
    UIProgressView *progressView;
    UILabel *statusLabel;

    DZFTPClient *ftpClient;
    NSMutableArray *directoryItems;
}

- (id)initWithLocation:(DZFTPLocation *)location;

@end
