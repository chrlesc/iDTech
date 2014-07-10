//
//  downloadDelegate.m
//  CDI Viewer
//
//  Created by Chris Lesch on 1/17/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import "downloadDelegate.h"

@implementation downloadDelegate

/*Handle server trust issues by obtaining their certificate.
* */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }else{
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
    }
}
/*When the request has finished, display the results in the table, also handle any errors that may occur.
* */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    //Initialize some variables.
    Globals *g = [Globals getInstance];
    NSNumber *request_hash = [NSNumber numberWithInteger:downloadTask.originalRequest.hash];
    TableState *aState = [g.currently_downloading objectForKey:request_hash];
    NSString *urlString = [[@"http://www.intel.com/cd/edesign/library/asmo-na/eng/" stringByAppendingString:aState.docID] stringByAppendingString:@".htm"];
    NSURL *pdfURL = [NSURL URLWithString:urlString];
    
    
    NSHTTPURLResponse *rep =  (NSHTTPURLResponse*)downloadTask.response;
    if([[[downloadTask.response URL] lastPathComponent] isEqualToString:@"404.html"]){
        [g.base removeRow:aState request_hash:request_hash];
        g.base.response.text = @"404: File Not Found";
        [g.base.response setHidden:NO];
        [g.base performSelector:@selector(removeResponseMessage) withObject:nil afterDelay:2.0];
        if(!aState.fileName){
            return;
        }
        aState.displayFileName = aState.fileName;
        [g.base addRow:aState];
    }else if([rep statusCode] == 200){
        NSString *webExtension = [[downloadTask.response URL] pathExtension];
        if([webExtension isEqualToString:@"pdf"]){
            
            //Move the pdf from temp location to Documents path.
            NSData *data = [NSData dataWithContentsOfURL:location];
            NSString *documentsDirectory = [g documentsBasePath];
            NSString *writePath = [documentsDirectory stringByAppendingPathComponent:[pdfURL lastPathComponent]];
            writePath = [[writePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"pdf"];
            [data writeToFile:writePath atomically:YES];
            
            //Write information about the file to a .txt.
            writePath = [[writePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"txt"];
            //Update the fileName appropriately based on whether the user has renamed the file.
            if(aState.renamed == NO){
                aState.fileName = [rep suggestedFilename];
                aState.displayFileName = [rep suggestedFilename];
            }else{
                aState.displayFileName = aState.fileName;
            }
            [[aState dictForClass] writeToFile:writePath atomically:YES];
            
            //Update the table view.
            [g.base removeRow:aState request_hash:request_hash];
            [g.base addRow:aState];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *start = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"starting_docs"]];
            if([start containsObject:aState.docID]){
                [start removeObject:aState.docID];
                NSArray *newStart = [[NSArray alloc] initWithArray:start];
                [userDefaults setObject:newStart forKey:@"starting_docs"];
                [userDefaults synchronize];
            }
        }else{
            [g.base removeRow:aState request_hash:request_hash];
            g.base.response.text = @"File is not a PDF";
            [g.base.response setHidden:NO];
            [g.base performSelector:@selector(removeResponseMessage) withObject:nil afterDelay:2.0];
            if(!aState.fileName){
                return;
            }
            aState.displayFileName = aState.fileName;
            [g.base addRow:aState];
        }
    }else{
        [g.base removeRow:aState request_hash:request_hash];
        g.base.response.text = @"Unkown Error";
        [g.base.response setHidden:NO];
        [g.base performSelector:@selector(removeResponseMessage) withObject:nil afterDelay:2.0];
        if(!aState.fileName){
            return;
        }
        aState.displayFileName = aState.fileName;
        [g.base addRow:aState];
    }
}
/*Resume the download after entering background mode if possible.
* */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
}

/*Update the download progress bar for the table item as the file is downloaded
* */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:
(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    Globals *g = [Globals getInstance];
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    if(g.currently_downloading){
        TableState *aState = [g.currently_downloading objectForKey:[NSNumber numberWithInteger:downloadTask.originalRequest.hash]];
        NSMutableArray *sectionArray = [[NSMutableArray alloc] initWithArray:[g.base.states objectAtIndex:aState.sectionNumber]];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:[sectionArray indexOfObject:aState] inSection:aState.sectionNumber];
        if(ip){
            float diff =(progress - [aState.progress floatValue]);
            if( diff >= (float)0.01){
                [aState setProgress:[NSNumber numberWithFloat:progress]];
                NSMutableArray *reloadRows = [[NSMutableArray alloc] initWithObjects:ip,nil];
                [g.base.table reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    
}
/*An unexpected error occured while trying to download the file.  Remove the downloading, add back the old.
* */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if(!error){
        return;
    }
    Globals *g = [Globals getInstance];
    
    //Grab the table item that matches the current download request and update it.
    NSNumber *request_hash = [NSNumber numberWithInteger:task.originalRequest.hash];
    TableState *aState = [g.currently_downloading objectForKey:request_hash];
    [g.base removeRow:aState request_hash:request_hash];
    g.base.response.text = @"Download Failed!";
    [g.base.response setHidden:NO];
    [g.base performSelector:@selector(removeResponseMessage) withObject:nil afterDelay:2.0];
    //If the file didn't previously exist then there is no need to add it back.
    if(!aState.fileName){
        return;
    }
    aState.displayFileName = aState.fileName;
    [g.base addRow:aState];
}
/*Handle any HTTP redirection requests that may occur.
* */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler{
    NSLog(@"REDIRECT RESPONSE: %@",[response URL]);
    NSLog(@"REDIRECT REQUEST: %@",[request URL]);
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[request URL]];
    [req setValue:[[request URL] host] forHTTPHeaderField:@"Host"];
    [req setHTTPMethod:@"GET"];
    [req setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [req setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [req setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [req setValue:@"en-US,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    completionHandler(req);
}
@end
