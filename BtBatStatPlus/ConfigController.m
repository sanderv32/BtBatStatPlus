//
//  ConfigController.m
//  BtBatStatPlus
//
//  Created by Alexander Verhaar on 12/15/12.
//  Copyright (c) 2012 A.Verhaar. All rights reserved.
//

#import "ConfigController.h"

@implementation ConfigController

@synthesize sliderCrit, sliderWarn, textCrit, textWarn, cbGrowl;

-(id)init
{
    self = [super initWithWindowNibName:@"ConfigController"];
    return self;
}

- (void)awakeFromNib
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger warnLevel = [prefs integerForKey:@"warnLevel"];
    NSInteger critLevel = [prefs integerForKey:@"critLevel"];
    BOOL useGrowl = [prefs boolForKey:@"useGrowl"];
    [textWarn setIntegerValue:warnLevel];
    [sliderWarn setIntegerValue:warnLevel];
    [textCrit setIntegerValue:critLevel];
    [sliderCrit setIntegerValue:critLevel];
    [cbGrowl setState:useGrowl==YES ? NSOnState:NSOffState];
}

-(IBAction)saveSettings:(id)sender
{
    NSInteger warnLevel = [sliderWarn integerValue];
    NSInteger critLevel = [sliderCrit integerValue];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:warnLevel forKey:@"warnLevel"];
    [prefs setInteger:critLevel forKey:@"critLevel"];
    [prefs setBool:cbGrowl.state==NSOnState ? YES:NO forKey:@"useGrowl"];
    [prefs synchronize];
    
    NSArray *levels = [NSArray arrayWithObjects:[NSNumber numberWithLong:warnLevel], [NSNumber numberWithLong:critLevel], nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:levels forKey:@"levels"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BBSPNotification" object:self userInfo:userInfo];
    [self close];
}

- (IBAction)sliderWarnChanged:(NSSlider *)sender {
    [textWarn setIntegerValue:[sliderWarn integerValue]];
    
}

- (IBAction)sliderCritChanged:(NSSlider *)sender {
    [textCrit setIntegerValue:[sliderCrit integerValue]];
}

-(IBAction)quit:(id)sender
{
    [self close];
}
@end
