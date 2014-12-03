//
//  JSPlayer.h
//  Pleo Teao
//
//  Created by Richard Stockdale on 28/11/2014.
//  Copyright (c) 2014 Pleo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSPlayer : NSObject

@property NSString* name;
@property NSString* emailAddress;
@property NSString* coffeePref;
@property NSString* teaPref;
@property NSString* otherPref;

@property BOOL playing;

- (id) initWithDict: (NSDictionary*) dict;
- (NSDictionary*) dictRep;


@end
