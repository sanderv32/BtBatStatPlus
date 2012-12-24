//
//  main.m
//  BtBatStatPlus
//
//  Created by Alexander Verhaar on 12/14/12.
//  Copyright (c) 2012 A.Verhaar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BBSPAppDelegate.h"

int main(int argc, char *argv[])
{
    NSApplication *app = [NSApplication sharedApplication];
    BBSPAppDelegate *appDelegate = [[BBSPAppDelegate alloc] init];
    [app setDelegate:appDelegate];
    [app run];
    return 0;
}
