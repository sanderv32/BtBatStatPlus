//
//  BBSPAppDelegate.h
//  BtBatStatPlus
//
//  Created by Alexander Verhaar on 12/14/12.
//  Copyright (c) 2012 A.Verhaar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
#import "AboutController.h"
#import "ConfigController.h"

@interface BBSPAppDelegate : NSObject <NSApplicationDelegate,GrowlApplicationBridgeDelegate>
{
    @private
    NSDate *startTime;
    NSStatusBar *statusBar;
    NSStatusItem *statusItem;
    NSStatusItem *barItem;
    NSMutableDictionary *barItems;
    NSMutableDictionary *devices;
    NSMenu *menu;
    NSMenu *noDevsMenu;
    
    NSInteger devicesFound;
    NSInteger warnLevel;
    NSInteger critLevel;
    BOOL growlRunning;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) AboutController *aboutController;
@property (nonatomic, retain) ConfigController *configController;

- (IBAction)configPressedOK:(NSButton *)sender;
- (IBAction)about:(id)sender;
- (IBAction)config:(id)sender;
- (IBAction)quit:(id)sender;

typedef enum {
    EWarning = 0,
    ECritical = 1
} BBSP_Msg_Type;

@end
