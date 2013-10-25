#import "FTPViewController.h"


#define ADD_ACTIONSHEET_TAG     101
#define FILE_ACTIONSHEET_TAG    102


@interface FTPViewController ()

@property (nonatomic, retain) NSIndexPath *indexPathForFileAction;

@end


@implementation FTPViewController

@synthesize indexPathForFileAction;

- (id)initWithLocation:(DZFTPLocation *)location;
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        //Create FTP Client
        ftpClient = [[DZFTPClient alloc] initWithLocation:location];
        ftpClient.delegate = self;
        
        //Set our Data objects
        directoryItems = [[NSMutableArray alloc] init];
        self.indexPathForFileAction = nil;
        
        self.title = location.name;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    //Build UI
    
    self.navigationController.toolbarHidden = NO;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction:)];
    UIBarButtonItem *activityIndicatorItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButtonItem, activityIndicatorItem, nil];
    [addButtonItem release];
    [activityIndicatorItem release];
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                            0.0,
                                                            self.view.frame.size.width - 20.0,
                                                            30.0)];
    statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = [UIColor darkGrayColor];
    statusLabel.font = [UIFont systemFontOfSize:12.0];
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.frame = CGRectMake(0.0,
                                    3.0,
                                    statusLabel.frame.size.width,
                                    progressView.frame.size.height);
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [statusLabel addSubview:progressView];
    
    UIBarButtonItem *statusItem = [[UIBarButtonItem alloc] initWithCustomView:statusLabel];
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                       target:nil
                                                                                       action:NULL];
    self.toolbarItems = [NSArray arrayWithObjects:flexibleSpaceItem, statusItem, flexibleSpaceItem, nil];
    [statusItem release];
    [flexibleSpaceItem release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //List directory content
    [activityIndicator startAnimating];
    [ftpClient listDirectoryInCurrentLocationShowHiddenItems:YES];
}

- (void)dealloc
{
    [activityIndicator release];
    [progressView release];
    [statusLabel release];
    
    ftpClient.delegate = nil;
    [ftpClient release];
    [directoryItems release];
    
    [self.indexPathForFileAction release];
    
    [super dealloc];
}



#pragma mark ---
#pragma mark Actions
#pragma mark ---
- (void)addButtonAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Uplaod File", @""), NSLocalizedString(@"Create Directory", @""), nil];
    actionSheet.tag = ADD_ACTIONSHEET_TAG;
    [actionSheet showInView:self.navigationController.view];
    [actionSheet release];
}



#pragma mark ---
#pragma mark Table view data source
#pragma mark ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [directoryItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
    DZFTPItem *item = [directoryItems objectAtIndex:indexPath.row];
    if (item.type == DZFTPItemTypeDirectory) //Directory
    {
        cell.detailTextLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (item.type == DZFTPItemTypeFile) //File
    {
        unsigned long long fileSize = item.size;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Size: %llu", fileSize];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else //Other
    {
        cell.detailTextLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = item.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DZFTPItem *item = [directoryItems objectAtIndex:indexPath.row];
    if (item.type == DZFTPItemTypeDirectory) //Directory
    {
        DZFTPLocation *location = [item location];
        FTPViewController *controller = [[FTPViewController alloc] initWithLocation:location];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if (item.type == DZFTPItemTypeFile) //File
    {
        self.indexPathForFileAction = indexPath;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Download File", @""), NSLocalizedString(@"Delete File", @""), nil];
        actionSheet.tag = FILE_ACTIONSHEET_TAG;
        [actionSheet showInView:self.navigationController.view];
        [actionSheet release];
    }
    else //Other
    {
        /*
         * ... handle itemtype!
         */
    }
}



#pragma mark ---
#pragma mark DZFTPClient Deleagte
#pragma mark ---
- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didListItems:(NSArray *)items
{
    //Refresh UI
    progressView.progress = 0.0;
    [directoryItems removeAllObjects];
    [directoryItems addObjectsFromArray:items];
    
    [activityIndicator stopAnimating];
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didDownloadFile:(NSURL *)sourceURL toDestination:(NSString *)destinationPath
{
    //Download finished. Notify User.
    progressView.progress = 0.0;
    [activityIndicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"File downloaded!", @"")
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didUploadFile:(NSString *)sourcePath toDestination:(NSURL *)destinationURL
{
    //Upload finished. Relist content.
    [activityIndicator startAnimating];
    [ftpClient listDirectoryInCurrentLocationShowHiddenItems:YES];
}

- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didMakeDirectory:(NSURL *)directoryURL
{
    //Directory created. Relist content.
    [activityIndicator startAnimating];
    [ftpClient listDirectoryInCurrentLocationShowHiddenItems:YES];
}

- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didDeleteFile:(NSURL *)fileURL
{
    //File deleted. Refresh content.
    [activityIndicator startAnimating];
    [ftpClient listDirectoryInCurrentLocationShowHiddenItems:YES];
}

- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didUpdateProgress:(float)progress
{
    //Update Progressbar
    progressView.progress = progress;
}

- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didFailWithError:(NSError *)error
{
    //Something went wrong. Notify User.
    progressView.progress = 0.0;
    [activityIndicator stopAnimating];
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
    
    statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Error %d", @""), error.code];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Error %d", @""), error.code]
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didUpdateStatus:(NSString *)status
{
    //Update connection status.
    statusLabel.text = status;
}




#pragma mark ---
#pragma mark UIActionSheet Delegate
#pragma mark ---
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ADD_ACTIONSHEET_TAG)
    {
        if (buttonIndex == 0) //Upload File
        {
            NSString *testUploadPath = [[NSBundle mainBundle] pathForResource:@"test_upload" ofType:@"jpg"];
            
            [activityIndicator startAnimating];
            [ftpClient uploadFileToCurrentLocation:testUploadPath];
        }
        else if (buttonIndex == 1) //Create Directory
        {
            [activityIndicator startAnimating];
            [ftpClient createDirectoryInCurrentLocation:@"this is a test"];
        }
    }
    else if (actionSheet.tag == FILE_ACTIONSHEET_TAG)
    {
        DZFTPItem *item = [directoryItems objectAtIndex:self.indexPathForFileAction.row];
        self.indexPathForFileAction = nil;
        
        if (buttonIndex == 0) //Download File
        {
            NSString *downloadPath = [NSTemporaryDirectory() stringByAppendingPathComponent:item.name];
            if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:nil];
            }
            
            [activityIndicator startAnimating];
            [ftpClient downloadItem:item toDestination:downloadPath];
        }
        else if (buttonIndex == 1) //Delete File
        {
            [activityIndicator startAnimating];
            [ftpClient deleteFileInCurrentLocation:item.name];
        }
    }
}

@end
