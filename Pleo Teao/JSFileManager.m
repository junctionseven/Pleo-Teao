//
//  JSFileManager.m
//  Pleo Teao
//
//  Created by Richard Stockdale on 02/12/2014.
//  Copyright (c) 2014 Pleo. All rights reserved.
//

#import "JSFileManager.h"

@interface JSFileManager ()

@end

@implementation JSFileManager

+ (BOOL) saveContestants: (NSArray*) contestants
{
    NSString* fileNameWithExt = @"contestants";
    
    //======================================= Get file path =======================================
    
    //Get list of documents for directries in the sandbox. There will only be one!
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //get the one and only document directory from list (this is always a index:0)
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    
    
    
    //Append passed in file name to that directory, returning it
    NSString* fullFilePath = [documentDirectory stringByAppendingPathComponent:fileNameWithExt];
    
    //======================================= Write =======================================
    
    BOOL writeSuccess = [contestants writeToFile:fullFilePath atomically:YES];
    return writeSuccess;
}

+ (NSArray*) loadContestants
{
    // Build the filename and file path
    NSString* fileNameWithExt = @"contestants";
    
    //======================================= Get file path =======================================
    
    //Get list of documents for directries in the sandbox. There will only be one!
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //get the one and only document directory from list (this is always a index:0)
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    //NSString *documentDirectory = @"..";
    
    //Append passed in file name to that directory, returning it
    NSString* fullFilePath = [documentDirectory stringByAppendingPathComponent:fileNameWithExt];
    
    //======================================= Read =======================================
    
    NSArray* file = [NSArray arrayWithContentsOfFile:fullFilePath];
    if (file == nil)
    {
        NSLog(@"Error with the loading of the catalogue from file (FM)");
        return nil;
    }
    return file;
}






@end
