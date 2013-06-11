//
//  BBSPAppDelegate.m
//  BtBatStatPlus
//
//  Created by Alexander Verhaar on 12/14/12.
//  Copyright (c) 2012 A.Verhaar. All rights reserved.
//

#import "BBSPAppDelegate.h"
#import "NSImage+load.h"

#define IMAGEIDX 0  /* Image index in Array     */
#define DEVIDIDX 1  /* DeviceID index in Array  */
#define FNAMEIDX 2  /* Fullname index in Array  */

@implementation BBSPAppDelegate

@synthesize aboutController, configController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /*
     * Check if Growl is running
     */
    if ([GrowlApplicationBridge isGrowlRunning]) {
        NSLog(@"Growl is running");
        growlRunning = YES;
    } else {
        growlRunning = NO;
    }
    
    /*
     * Get preferences
     */
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs objectForKey:@"warnLevel"]) {
        /* Key doesn't exist so create defaults and write them back to disk */
        warnLevel = 10;
        critLevel = 5;
        useGrowl = growlRunning;
        [prefs setInteger:warnLevel forKey:@"warnLevel"];
        [prefs setInteger:critLevel forKey:@"critLevel"];
        [prefs setBool:growlRunning ? YES:NO forKey:@"useGrowl"];
        [prefs synchronize];
    } else {
        warnLevel = [prefs integerForKey:@"warnLevel"];
        critLevel = [prefs integerForKey:@"critLevel"];
        useGrowl = [prefs boolForKey:@"useGrowl"];
    }
    
    barItems    =   [[NSMutableDictionary alloc] init];
    startTime   =   [NSDate date];
    menu        =   [[NSMenu alloc] init];
    devices     =   [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         [[NSArray alloc] initWithObjects:[[NSImage alloc] loadPNG:@"kb.png"],           @"AppleBluetoothHIDKeyboard", @"Keyboard",      nil], @"kb",
                         [[NSArray alloc] initWithObjects:[[NSImage alloc] loadPNG:@"magic_mouse.png"],  @"BNBMouseDevice",            @"Magic Mouse",   nil], @"magicMouse",
                         [[NSArray alloc] initWithObjects:[[NSImage alloc] loadPNG:@"mighty_mouse.png"], @"AppleBluetoothHIDMouse",    @"Mighty Mouse",  nil], @"mightyMouse",
                         [[NSArray alloc] initWithObjects:[[NSImage alloc] loadPNG:@"TrackpadIcon.png"], @"BNBTrackpadDevice",         @"Magic Trackpad",nil], @"magicTrackpad",
                         [[NSArray alloc] initWithObjects:[[NSImage alloc] loadPNG:@"no_device.png"],    nil,                          nil              ,nil], @"noDevices",
                         nil];
    
    /*
     * Define menu items
     */
    statusBar                   =   [NSStatusBar systemStatusBar];
    NSMenuItem *menuAbout       =   [[NSMenuItem alloc] initWithTitle:@"About BtBatStat+" action:@selector(about:) keyEquivalent:@""];
    NSMenuItem *menuConfig      =   [[NSMenuItem alloc] initWithTitle:@"Configure warnings" action:@selector(config:) keyEquivalent:@""];
    NSMenuItem *seperator       =   [NSMenuItem separatorItem];
    NSMenuItem *menuQuit        =   [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit:) keyEquivalent:@""];
    NSMenuItem *noDevsMenuItem  =   [[NSMenuItem alloc] initWithTitle:@"BtBatStat+: No devices found." action:nil keyEquivalent:@""];
    
    /*
     * Setup timer
     */
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:startTime interval:10.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    /*
     * Add menu items
     */
    [menu addItem:menuAbout];
    [menu addItem:menuConfig];
    [menu addItem:seperator];
    [menu addItem:menuQuit];
    
    noDevsMenu = [menu copy];
    [noDevsMenu insertItem:[NSMenuItem separatorItem] atIndex:0];
    [noDevsMenu insertItem:noDevsMenuItem atIndex:0];
    
    /*
     * Register Growl
     */
    if (growlRunning) {
        [GrowlApplicationBridge setGrowlDelegate:self];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotifications:) name:@"BBSPNotification" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 * Notifications receiver
 */
-(void) receiveNotifications:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"BBSPNotification"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSArray *levels = [userInfo objectForKey:@"levels"];
        warnLevel = [[levels objectAtIndex:0] intValue];
        critLevel = [[levels objectAtIndex:1] intValue];
        useGrowl = [[userInfo objectForKey:@"useGrowl"] boolValue];
    }
}

/*
 * Register app to Growl
 */
- (NSDictionary *) registrationDictionaryForGrowl {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"BtBatStatPlus" ofType: @"growlRegDict"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile: path];
    return dictionary;
}

/*
 * About menu item
 */
- (IBAction)about:(id)sender
{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    if (aboutController==nil) {
        aboutController = [[AboutController alloc] init];
    }
    [aboutController.window makeKeyAndOrderFront:sender];
    [aboutController.window center];
}

/*
 * Config menu item
 */
- (IBAction) config:(id)sender
{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    if (configController==nil) {
        configController = [[ConfigController alloc] init];
    }
    [configController.window makeKeyAndOrderFront:sender];
    [configController.window center];
}

/*
 * Quit menu item
 */
- (IBAction)quit:(id)sender
{
    [NSApp stop:self];
}

/*
 * Create statusbar item
 */
-(NSStatusItem *) createStatusBarItem:(NSImage *)icon title:(NSString*)title menu:(NSMenu *)mnu
{
    barItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    [barItem setTitle:title];
    [barItem setImage:icon];
    [barItem setHighlightMode:YES];
    [barItem setMenu:mnu];
    return barItem;
}

/*
 * Timer callback
 */
- (void) tick:(NSNotification *)sender
{
    devicesFound = 0;
    
    for(id device in [devices allKeys]) {
        if ([device isEqual: @"noDevices"]) continue;
        
        NSInteger percentage = [self getPercentage:[[devices objectForKey:device] objectAtIndex:DEVIDIDX]];
        NSString *strPercentage = [NSString stringWithFormat:@"%ld",percentage];
        if (percentage<0) {
            if ([barItems objectForKey:device]) {
                [statusBar removeStatusItem:[barItems objectForKey:device]];
                [barItems removeObjectForKey:device];
            }
        }
        
        if (percentage>0) {
            devicesFound +=1;
            if (![barItems objectForKey:device]) {
                [barItems setObject:[self createStatusBarItem:[[devices objectForKey:device] objectAtIndex:IMAGEIDX] title:strPercentage menu:menu]
                             forKey:device];
            }
            [[barItems objectForKey:device] setTitle:[NSString stringWithFormat:@"%ld%%", percentage]];
            if (percentage <= warnLevel) {
                [self sendMessage:device type:EWarning];
            }
            if (percentage <= critLevel) {
                [self sendMessage:device type:ECritical];
            }
        }
    }
    if (devicesFound == 0) {
        [barItems setObject:[self createStatusBarItem:[[devices objectForKey:@"noDevices"] objectAtIndex:IMAGEIDX] title:@"" menu:noDevsMenu] forKey:@"noDevices"];
    }
}

/*
 * Universal Growl message sender
 */
-(void) sendMessage:(NSString *)device type:(BBSP_Msg_Type)t
{
    if (growlRunning && useGrowl) {
        NSString *identifier = [@"BtBatStat+" stringByAppendingString:device];
        NSString *msg = (t==EWarning)?@"Battery low!":@"Battery critical!";
        NSString *dev = [[devices objectForKey:device] objectAtIndex:FNAMEIDX];
        [GrowlApplicationBridge notifyWithTitle:dev
                                    description:msg
                               notificationName:@"BtBatStat+"
                                       iconData:nil
                                       priority:0
                                       isSticky:YES
                                   clickContext:nil
                                     identifier:identifier];
    }
}

#ifdef USE_IOREG
/*
 * Start ioreg and get battery percentage
 */
-(NSInteger) getPercentage:(NSString *)key
{
    NSInteger percentage = -1;
    NSString *mText;
    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];
    
    [task setLaunchPath:@"/usr/sbin/ioreg"];
    [task setArguments:[NSArray arrayWithObjects:@"-rc", key, nil]];
    [task setStandardOutput:pipe];
    [task launch];
    
    NSFileHandle *read = [pipe fileHandleForReading];
    NSData *dataRead = [read readDataToEndOfFile];
    NSString *data = [[NSString alloc] initWithData:dataRead encoding:NSASCIIStringEncoding];
    [task waitUntilExit];
    
    if (dataRead.length > 0) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"BatteryPercent\" = (\\d{1,2}0?)" options:0 error:&error];
        NSArray *matches = [regex matchesInString:data options:0 range:NSMakeRange(0, [data length])];
      
        if ([matches count] > 0) {
            for(NSTextCheckingResult *match in matches) {
                mText = [data substringWithRange:[match rangeAtIndex:1]];
            }
            percentage = [mText integerValue];
        }
    }
    return percentage;
}
#else
/*
 * Query IOService for the HID devices
 */
-(NSInteger) getPercentage:(NSString *)key
{
    CFMutableDictionaryRef matchingDict;
    CFTypeRef percentage;
    io_iterator_t iterator;
    kern_return_t result;
    io_service_t device;
    NSInteger retval = 0;
    
    matchingDict = IOServiceMatching([key cStringUsingEncoding:NSASCIIStringEncoding]);
    if (matchingDict==NULL) {
        return -1;
    }
    
    result = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iterator);
    if (result != KERN_SUCCESS || iterator == IO_OBJECT_NULL) {
        return -1;
    }
    
    while ((device = IOIteratorNext(iterator))) {
        percentage = IORegistryEntryCreateCFProperty(device, CFSTR("BatteryPercent"), kCFAllocatorDefault, 0);
        IOObjectRelease(device);
    }
    IOObjectRelease(iterator);
    
    /* Be sure we got a number in percentage */
    if (CFGetTypeID(percentage)!=CFNumberGetTypeID())
        return -1;
    
    /* Convert CFTypeRef to SInt32 */
    if (CFNumberGetValue((CFTypeRef)percentage, kCFNumberSInt32Type, &retval))
        return retval;
    else
        return -1;
}
#endif

@end /* Implementation */
