//
//  LoginView.m
//  CDI Viewer
//
//  Created by Chris Lesch on 1/3/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import "LoginView.h"
#import "Globals.h"
#import "downloadDelegate.h"

@implementation LoginView
/*Initialize the layout from the nib file
 * */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*Configure any handlers after the view has loaded.
 * */
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Set the Login result text, even though it is hidden until after failed log-in attempt.
    [LoginResult setHidden:YES];
    [LoginResult setText:@"Login Failed!"];
    [LoginResult setTextColor:[UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0]];
    [activity setHidesWhenStopped:YES];
    //Register the keyboard notication handlers eacht time the view is loaded.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification  object:nil];
}
/*Log information about the cookies associated with the argument displayURL.
* */
- (void)displayCookies:(NSURL *)displayURL{
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* all_cookies = [cookies cookiesForURL:displayURL];
    for(NSHTTPCookie *cook in all_cookies){
        NSLog(@"%@",[cook name]);
        NSLog(@"%@",[cook value]);
        NSLog(@"%@",[cook domain]);
    }
}
/*Delete all of the stored cookies when the user logs-out.
* */
- (void)deleteCookies{
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *all_cookies = [cookies cookies];
    for(NSHTTPCookie *element in all_cookies){
        if([[element domain] isEqualToString:@".intel.com"] || [[element domain] isEqualToString:@"welcome.intel.com"]){
            [cookies deleteCookie:element];
        }
    }
}
/*Returns TRUE if cookie data for the intel domain exists.
* false otherwise.*/
- (BOOL)currentlyLoggedIn{
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *all_cookies = [cookies cookies];
    for(NSHTTPCookie *element in all_cookies){
        if([[element name] isEqualToString:@"SecureSESSION"] &&
           [[element domain] isEqualToString:@".intel.com"] && [element isSecure]){
            return true;
        }
    }
    return false;
}
/*Tell the keyboard to go away when the user presses return
* */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
/*Return to the view that brought you to this LoginView.
* */
- (IBAction)back{
    [self.navigationController popViewControllerAnimated:YES];
}

/*Authenticate with the intel CDI servers and obtain a valid session to check for updates ect.
* */
- (IBAction)enterCredentials{
    //Default starting setup.
    [LoginResult setHidden:YES];
    [activity startAnimating];
    Globals *g = [Globals getInstance];
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    //Hard-coded URL for the CDI login web server.
    NSURL *restrictedURL = [NSURL URLWithString:@"http://www.intel.com/cd/edesign/library/asmo-na/eng/index.htm"];
    
    //Grab the login username and configure it to be sent in HTTP Post body.
    NSString *user = usernameField.text;
    NSString *unformatted_user = user;
    user = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)user, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
    //Grab the login password and configure it to be sent in HTTP Post body.
    NSString *password = passwordField.text;
    password = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)password,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
    //Format the login post-body data.
    NSString *myRequestString = [NSString stringWithFormat:@"&txtUserName=%@&txtPassword=%@",user,password];
    myNewRequestString = [[NSString alloc] initWithString:myRequestString];
    //Setup the ses sion.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    downloadDelegate* download_delegate = [[downloadDelegate alloc] init];
    g.session = [NSURLSession sessionWithConfiguration:configuration delegate:download_delegate delegateQueue: ];
    
    //Configure the GET request to obtain the login page data.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:restrictedURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"en-US,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    [request setValue:@"www.intel.com" forHTTPHeaderField:@"Host"];
    [[g.session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if(error){
            [LoginResult setHidden:NO];
            [activity stopAnimating];
            return;
        }
        //Use the Hpple library to parse the HTML response for the required authentication components
        //that must be appended to the Post request for the server to recognize the response.
        NSData* data = [NSData dataWithContentsOfURL:location];
        TFHpple *parseData = [TFHpple hppleWithHTMLData:data];
        NSString *xPathQuery = @"//form";
        NSArray *nodes = [parseData searchWithXPathQuery:xPathQuery];
        for(TFHppleElement *element in nodes){
          action = @"https://welcome.intel.com/";
          action = [action stringByAppendingString:[element objectForKey:@"action"]];
        }
        xPathQuery = @"//input";
        nodes = [parseData searchWithXPathQuery:xPathQuery];
        for(TFHppleElement *element in nodes){
            if([[element objectForKey:@"type"] isEqualToString:@"hidden"]){
                NSString* name =[element objectForKey:@"name"];
                NSString* val = [element objectForKey:@"value"];
                NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)val,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
                myNewRequestString = [[[[myNewRequestString stringByAppendingString:@"&"] stringByAppendingString:name] stringByAppendingString:@"="]stringByAppendingString:encodedString];
            }
        }
        NSData *myNewRequestData = [myNewRequestString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[myNewRequestData length]];
        NSURL *newRequest = [[NSURL alloc] initWithString:action];
        [request setURL:newRequest];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:myNewRequestData];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"welcome.intel.com" forHTTPHeaderField:@"Host"];
        [request setValue:action forHTTPHeaderField:@"Referer"];
        [request setHTTPShouldHandleCookies:YES];
        [[g.session downloadTaskWithRequest:request completionHandler:^(NSURL *location2, NSURLResponse *response2, NSError *error2) {
            if([self currentlyLoggedIn]){
                [g.base.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
                [g.base.hello setText:[@"User: " stringByAppendingString:unformatted_user]];
                [g.base.hello setHidden:NO];
                [self.navigationController popViewControllerAnimated:YES];
                //Check if finished downloading all of the "starter documents".
                [self startingDocsCheck];
            }else{
                [LoginResult setHidden:NO];
            }
            [activity stopAnimating];
        }] resume];
        
        }] resume];
}
/*Check that the default files have all been successfully downloaded.
 * */
- (void)startingDocsCheck{
    Globals *g = [Globals getInstance];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* start = [userDefaults objectForKey:@"starting_docs"];
    for(id docID in start){
        NSLog(@"%@",docID);
        [g.base downloadDocument:docID];
    }
}

//-------------------------Handle displaying the keyboard------------------------------
- (void)keyboardDidShow:(NSNotification*)notification{
    [self animateTextField:notification up:YES];
}

- (void)keyboardDidHide:(NSNotification*)notification{
    [self animateTextField:notification up:NO];
}

- (void) animateTextField:(NSNotification*)notification up:(BOOL)up
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    int movementDistance;
    //Keyboard is coming up.
    if(up){
        [backButton setHidden:YES];
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if(orientation == UIDeviceOrientationLandscapeRight){
            movementDistance = keyboardFrameEndRect.origin.x;
        }else if(orientation == UIDeviceOrientationLandscapeLeft){
            movementDistance = ([self view].frame.size.height - keyboardFrameEndRect.size.width);
        }else if(orientation == UIDeviceOrientationPortrait){
            movementDistance = keyboardFrameEndRect.origin.y;
        }else{
            movementDistance = ([self view].frame.size.height - keyboardFrameEndRect.size.height);
        }
        movementDistance -= (loginButton.frame.origin.y + loginButton.frame.size.height);
        //If the keyboard isn't covering anything, than don't bother moving anything.
        if(movementDistance > 0){
            movementDistance = 0;
        }else{ //Add some extra padding to make things look nice.
            movementDistance = movementDistance - 5;
        }
        downDistance = -movementDistance;
    }else{ //Keyboard is going down.
        movementDistance = downDistance;
        [backButton setHidden:NO];
    }
    
    //Animate the text box movements.
    const float movementDuration = 0.3f;
    centerY.constant -= movementDistance;
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

@end