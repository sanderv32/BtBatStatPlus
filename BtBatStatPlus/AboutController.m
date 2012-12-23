//
//  AboutDelegate.m
//  BtBatStatPlus
//
//  Created by Alexander Verhaar on 12/14/12.
//  Copyright (c) 2012 A.Verhaar. All rights reserved.
//

#import "AboutController.h"

@implementation AboutController

@synthesize aboutTextView, aboutWindow;

- (id)init
{
    self = [super initWithWindowNibName:@"AboutController"];
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        NSLog(@"initWithWindow");
    }
    return self;
}

- (void)awakeFromNib
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *rtfFile = [bundle pathForResource:@"Credits" ofType:@"rtf"];
    [aboutTextView readRTFDFromFile:rtfFile];
    [aboutTextView setNeedsDisplay:YES];
}

- (void)dealloc
{
    //[super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)windowWillClose:(NSNotification *)notification
{
        
}

@end
