//
//  JSFileManager.h
//  Pleo Teao
//
//  Created by Richard Stockdale on 02/12/2014.
//  Copyright (c) 2014 Pleo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JSFileManager : NSObject

+ (BOOL) saveContestants: (NSArray*) contestants;
+ (NSArray*) loadContestants;


@end
