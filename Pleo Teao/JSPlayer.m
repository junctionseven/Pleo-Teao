//
//  JSPlayer.m
//  Pleo Teao
//
//  Created by Richard Stockdale on 28/11/2014.
//  Copyright (c) 2014 Pleo. All rights reserved.
//

#import "JSPlayer.h"

@implementation JSPlayer


- (id)init
{
    if (self = [super init])
    {
        self.playing = YES;
    }
    return self;
}

- (id) initWithDict: (NSDictionary*) dict
{
    if (self = [super init])
    {
        self.playing = YES;

        
        self.name = [dict objectForKey:@"name"];
        self.emailAddress = [dict objectForKey:@"emailAddress"];
        self.coffeePref = [dict objectForKey:@"coffeePref"];
        self.teaPref = [dict objectForKey:@"teaPref"];
        self.otherPref = [dict objectForKey:@"otherPref"];
        
        NSNumber* playingNum = [dict objectForKey:@"playing"];
        NSLog(@"playingNum: %@", playingNum);
        
        self.playing = playingNum.boolValue;
    }
    return self;
}

- (NSDictionary*) dictRep
{
    NSString* name = self.name;
    if (!name) name = @"";
    
    NSString* emailAddress = self.emailAddress;
    if (!emailAddress) emailAddress = @"";
    
    NSString* coffeePref = self.coffeePref;
    if (!coffeePref) coffeePref = @"";
    
    NSString* teaPref = self.teaPref;
    if (!teaPref) teaPref = @"";
    
    NSString* otherPref = self.otherPref;
    if (!otherPref) otherPref = @"";
    
    BOOL playing = self.playing;
    
    
    NSDictionary* dict = @{@"name" : name,
                           @"emailAddress" : emailAddress,
                           @"coffeePref" : coffeePref,
                           @"teaPref" : teaPref,
                           @"otherPref" : otherPref,
                           @"playing" : [NSNumber numberWithBool:playing]};
    
    
    
    return dict;
}


@end
