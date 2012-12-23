//
//  AboutDelegate.h
//  BtBatStatPlus
//
//  Created by Alexander Verhaar on 12/14/12.
//  Copyright (c) 2012 A.Verhaar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AboutController : NSWindowController <NSWindowDelegate>
{
    @private
    NSTextView *aboutTextView;
    NSWindow *aboutWindow;
}

@property (strong) IBOutlet NSTextView *aboutTextView;
@property (nonatomic, retain) IBOutlet NSWindow *aboutWindow;
@end
