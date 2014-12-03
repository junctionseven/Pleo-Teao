//
//  Records.m
//  Pleo Teao
//
//  Created by Richard Stockdale on 30/11/2014.
//  Copyright (c) 2014 Pleo. All rights reserved.
//

#import "JSRecordsViewController.h"

@interface JSRecordsViewController ()


@property (unsafe_unretained) IBOutlet NSTextView *recordsTextView;


@end

@implementation JSRecordsViewController

- (void) viewWillAppear
{
    NSArray* result = [[NSUserDefaults standardUserDefaults] objectForKey:@"records"];
    
    if (result)
    {
        NSMutableString* s = [[NSMutableString alloc] init];
        for (NSDictionary* item in result)
        {
            NSString* name = [item objectForKey:@"name"];
            NSDate* date = [item objectForKey:@"time"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd/MM/yyyy 'at' HH:mm"];
            
            NSString *formattedDateString = [dateFormat stringFromDate:date];
            
            [s appendString:[NSString stringWithFormat:@"%@ : Winner - %@ \r", formattedDateString, name]];
            
            
        }
        [self.recordsTextView setString:s];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
