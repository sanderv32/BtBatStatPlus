//
//  ConfigController.h
//  BtBatStatPlus
//
//  Created by Alexander Verhaar on 12/15/12.
//  Copyright (c) 2012 A.Verhaar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigController : NSWindowController <NSWindowDelegate>
{
    @private
    NSSliderCell    *sliderWarn;
    NSSliderCell    *sliderCrit;
    NSTextField     *textWarn;
    NSTextField     *textCrit;
    NSButton        *cbGrowl;
}

@property (nonatomic, retain) IBOutlet NSSliderCell *sliderWarn;
@property (nonatomic, retain) IBOutlet NSSliderCell *sliderCrit;
@property (nonatomic, retain) IBOutlet NSTextField  *textWarn;
@property (nonatomic, retain) IBOutlet NSTextField  *textCrit;
@property (nonatomic, retain) IBOutlet NSButton     *cbGrowl;

- (IBAction)quit:(id)sender;
- (IBAction)saveSettings:(id)sender;
- (IBAction)sliderWarnChanged:(NSSlider *)sender;
- (IBAction)sliderCritChanged:(NSSlider *)sender;

@end
