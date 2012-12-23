//
//  NSImage+load.m
//  BtBatStatPlus
//
//  Created by Alexander Verhaar on 12/14/12.
//  Copyright (c) 2012 A.Verhaar. All rights reserved.
//

#import "NSImage+load.h"

@implementation NSImage (load)

-(NSImage *) loadPNG:(NSString *)fileName
{
    NSBundle *bundle= [NSBundle mainBundle];
    NSString *fileInBundle = [bundle pathForResource:fileName ofType:nil];
    
    NSData *rawFile = [[NSData alloc] initWithContentsOfFile:fileInBundle];
    NSBitmapImageRep *imgrep = [[[[NSImage alloc]initWithData:rawFile]representations]objectAtIndex:0];
    
    return [[NSImage alloc] initWithData:[imgrep representationUsingType:NSPNGFileType properties:Nil]];
}

@end
