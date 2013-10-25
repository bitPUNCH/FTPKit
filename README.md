#Easy-to-use FTP client library for iOS and OS X apps

Want to add FTP communication into your app, but don't want to bother with low level C APIs and raw network streams?
Introducing FTP Kit, the solution for providing full featured FTP access in your apps with just a few lines of code.

![][1]

## Features at a glance:
- Easy integration with a few lines of code
- Clean and straight forward API
- All networking stuff is done completely asynchronous
- List remote directory content
- Downloading of remote files from a FTP Server
- Uploading of local files to a FTP Server
- Create remote directories
- Delete remote files



#How to use

##1. Connect to FTP server

###Create your FTP client instance:

	// Create FTP location Object. We use nil as a path, so we are pointing to the root directory.
    DZFTPLocation *ftpLocation = [DZFTPLocation locationWithHost:@"ftp://my.ftp-server.com" 
    														path:nil 
    													username:@"username" 
    													password:@"password"];
    // Initialize client with location
    DZFTPClient *ftpClient = [[DZFTPClient alloc] initWithLocation:ftpLocation];
    // Register delegate
    ftpClient.delegate = self;

    
##2. Execute requests

###List directory content at the path of our current FTP location:

	DZFTPRequest *request = [ftpClient listDirectoryInCurrentLocationShowHiddenItems:YES];
	// The requests starts immediately. Maybe you want to keep the request object for later use.
	
Recive directory content in delegate method:

	- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didListItems:(NSArray *)items
	{
    	// Do some stuff with received conent.
    	for (DZFTPItem *item in items)
    	{
    		if (item.type == DZFTPItemTypeDirectory) //Directory
				// ...
    		else if (item.type == DZFTPItemTypeFile) //File
				// ...
    	}
    	
    	// Usually you will present the content in a TableView...
	} 

###Download a file from the FTP server:

	DZFTPItem *item = // ...
	NSString *downloadPath = [NSTemporaryDirectory() stringByAppendingPathComponent:item.name];
	DZFTPRequest *request = [ftpClient downloadItem:item toDestination:downloadPath];
	// The requests starts immediately. Maybe you want to keep the request object for later use.
	
Receive delegate notifications:

	- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didUpdateProgress:(float)progress
	{
    	// Update the UI, e.g. progressBar.value = progress
	}
	
	- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didDownloadFile:(NSURL *)sourceURL toDestination:(NSString *)destinationPath
	{
    	// Download finished. Do some stuff with the file...
	}
	
###Upload a local file to the FTP server

	NSString *lokalFilePath = @"my/lokal/file.txt";
	DZFTPRequest *request = [ftpClient uploadFileToCurrentLocation:lokalFilePath];
	// The requests starts immediately. Maybe you want to keep the request object for later use.
	
Receive delegate notifications:

	- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didUpdateProgress:(float)progress
	{
    	// Update the UI, e.g. progressBar.value = progress
	}
	
	- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didUploadFile:(NSString *)sourcePath toDestination:(NSURL *)destinationURL
	{
    	// Upload finished. 
    	// Do some stuff, e.g. relist content.
   		[ftpClient listDirectoryInCurrentLocationShowHiddenItems:YES];
	}
	
###Create a new remote directoy

	NSString *directoryName = @"My Directory";
	DZFTPRequest *request = [ftpClient createDirectoryInCurrentLocation:directoryName];
	// The requests starts immediately. Maybe you want to keep the request object for later use.
	
Receive delegate notification:

	- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didMakeDirectory:(NSURL *)directoryURL
	{
    	//Directory created.
    	// Do some stuff, e.g. relist content.
   		[ftpClient listDirectoryInCurrentLocationShowHiddenItems:YES];
	}

###Delete a file from the FTP Server

	DZFTPItem *item = // ...
	DZFTPRequest *request = [ftpClient deleteFileInCurrentLocation:item.name];
	// The requests starts immediately. Maybe you want to keep the request object for later use.
	
Receive delegate notification:

	- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didDeleteFile:(NSURL *)fileURL
	{
    	//File deleted.
    	// Do some stuff, e.g. relist content.
   		[ftpClient listDirectoryInCurrentLocationShowHiddenItems:YES];
	}
	
###Cancel a running request

	DZFTPRequest *request = // ...
	[request cancel];
	
Receive delegate notification:

	- (void)client:(DZFTPClient *)client requestDidCancel:(DZFTPRequest *)request
	{
		// Request canceled. Do some stuff...
	}
	
###Listen to the current status of the running request

Running request notify the delegate of ftpClient when the status of the connection changes.
You can register for a delegate method in order to listen to this changes. This may be helpful for logging purposes or for showing status informations in the UI.

	- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didUpdateStatus:(NSString *)status
	{
    	// Update connection status.
    	// Do some stuff, e.g. update UI: statusLabel.text = status
	}
	
###Error handling

If an error occured during a request, your delegate will be notified:

	- (void)client:(DZFTPClient *)client request:(DZFTPRequest *)request didFailWithError:(NSError *)error
	{
    	//Something went wrong. Maybe you want to notify the user.:    
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %d", error.code]
                                                    	message:[error localizedDescription]
                                                   	   delegate:nil
                                          	  cancelButtonTitle:@"OK"
                                          	  otherButtonTitles:nil];
    	[alert show];
	}
	

	
#Setup / Integration

##Requirements

The source code of FTP Kit is developed on Xcode 5.0. FTP Kit works on a deployment target of iOS 4 or greater or OS X 10.6 or greater and can be used in ARC and non-ARC projects.

###Required Frameworks:

- Foundation
- CFNetwork

If you link FTP Kit in your project as a static library, you will need to set the **-ObjC** and **-all_load** linker flags. For details have a look at the following instructions.

##Integration

1. Drag the "DZFTP.xcodeproj" into your project.
2. Add the required library and frameworks as show in the screenshot below.
3. Open the "Build Settings" tab of your target and add the following changes:
	- Other Linker Flags: **-ObjC -all_load**
4. If you are using XCode prior 5.0 you will also need to add libDZFTP.a as a target dependency:
	- Open the "Build Phases" tab.
	- Expand the "Target Dependencies" section
	- Press "+" and select libDZFTP.a
5. Add the **#import <DZFTP/DZFTP.h>** statement everywhere you want to use FTP Kit in your project.

![][2]


  [1]: https://dl.dropboxusercontent.com/u/20735077/Binpress/FTPKit/banner.png
  [2]: https://dl.dropboxusercontent.com/u/20735077/Binpress/FTPKit/xcode1.png
  
#Evaluation License
The following license applies to the free trial version of the software component.

Copyright (c) 2013, bitPUNCH e.K.
All rights reserved.

Redistribution of this software, in either source or binary form is prohibited.

Use of this software is permitted under the following conditions:

- The software is used for evaluation purposes, with a view to purchasing a commercial development license.
- The software is used for non-commercial educational purposes. In all cases, the software's object code may not be submitted to Apple's App Store.

This software is provided by bitPUNCH e.K. "as is" and any express or implied warranties, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose are disclaimed. In no event shall bitPUNCH e.K. be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of sue, data or profits; or other business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this software, even if advised of the possibility of such damage.


#Get the full version

You can purchase the full version of FTPKit at Binpress:  
[http://www.binpress.com/app/ftp-kit-for-ios-and-os-x/1669](http://www.binpress.com/app/ftp-kit-for-ios-and-os-x/1669)
