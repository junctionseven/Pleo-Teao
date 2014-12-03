//
//  JSPlayViewController.m
//  Pleo Teao
//
//  Created by Richard Stockdale on 21/11/2014.
//  Copyright (c) 2014 Pleo. All rights reserved.
//

#import "JSPlayViewController.h"
#import "JSPlayer.h"
#import "JSFileManager.h"

@interface JSPlayViewController ()
{
    NSMutableArray* contestants;
    
    NSTimer* ticker;
    
    JSPlayer* winningPlayer;
}

@property (weak) IBOutlet NSTextField *nameLabel;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSButton *informButton;


@end

@implementation JSPlayViewController

#pragma mark - Audio

- (void) playSound
{
    NSBundle* myBundle = [NSBundle mainBundle];
    NSString* resourcePath = [myBundle pathForResource:@"bing" ofType:@"m4a"];
    
    
    NSSound *sound = [[NSSound alloc] initWithContentsOfFile:resourcePath byReference:YES];
    [sound play];
}


#pragma mark - Timers

- (void) showResults: (NSTimer*) timer
{
    [timer invalidate];
    [ticker invalidate];
    [self.playButton setHidden:NO];
    [self showWinner];
}

- (void) showNextName: (NSTimer*) timer
{
    NSInteger playerNum = [self randomNumberBetween:0 maxNumber:contestants.count];
    JSPlayer* p = [contestants objectAtIndex:playerNum];
    self.nameLabel.textColor = [NSColor lightGrayColor];
    self.nameLabel.stringValue = p.name;
}

#pragma mark - Interface

- (IBAction)informWinner:(id)sender
{
    NSString* winnersEmail = winningPlayer.emailAddress;
    
    [self.informButton setHidden:NO];
    
    [self sendEmailTo:winnersEmail
              Subject:@"You've won at Pleo Teao! Luck you!"
                 Body:[self generateBodyText]];
    
}

- (IBAction)playTapped:(id)sender
{
    if (contestants.count == 0)
    {
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setMessageText:@"You might want to add some contestants first!"];
        [alert addButtonWithTitle:@"Gosh yes. I am quite the FOOL!"];
        [alert runModal];
    }
    else
    {
        [self.playButton setHidden:YES];
        [self performSelector:@selector(showResults:) withObject:nil afterDelay:2.6];
        ticker = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(showNextName:) userInfo:nil repeats:YES];
        
        [self.informButton setHidden:YES];
        [self playSound];
    }
    
    
}

- (void) showWinner
{
    NSInteger winner = [self randomNumberBetween:0 maxNumber:contestants.count];
    winningPlayer = [contestants objectAtIndex:winner];
    self.nameLabel.textColor = [NSColor darkGrayColor];
    self.nameLabel.stringValue = winningPlayer.name;
    
    NSString* winnersEmail = winningPlayer.emailAddress;
    if (winnersEmail.length > 3)
    {
        [self.informButton setHidden:NO];
    }
    else
    {
        [self.informButton setHidden:YES];
    }
    
    // Record the result
    NSMutableArray* records;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"records"])
    {
        records = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"records"]];
    }
    else
    {
        records = [[NSMutableArray alloc] init];
    }
    
    NSDictionary* result = @{@"name" : winningPlayer.name,
                             @"time" : [NSDate date]};
    
    [records addObject:result];
    [[NSUserDefaults standardUserDefaults] setObject:records forKey:@"records"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Helpers

- (NSString*) generateBodyText
{

    NSMutableString* text = [[NSMutableString alloc] initWithString:@"Congratulations on winning at Pleo Teao. Now, go get the drinks. Please ask everyone what they would like. Below you can find details about how they take their drinks:\r\r"];
    
    // Loop through the contestants
    for (JSPlayer* p in contestants)
    {
        NSString* name = p.name;
        
        [text appendString:[NSString stringWithFormat:@"%@\r", name]];
        
        for (int i = 0 ; i < name.length + 6; i++)
        {
            [text appendString:@"-"];
        }
        
        [text appendString:@"\r"];
        
        if (p.teaPref.length > 0)
        {
            NSString* s = [NSString stringWithFormat:@"\rTea = %@", p.teaPref];
            [text appendString:s];
        }
        else
        {
            
        }
        if (p.coffeePref.length > 0)
        {
            NSString* s = [NSString stringWithFormat:@"\rCoffee = %@", p.coffeePref];
            [text appendString:s];
        }
        else
        {
            
        }
        if (p.otherPref.length > 0)
        {
            NSString* s = [NSString stringWithFormat:@"\rOther = %@", p.coffeePref];
            [text appendString:s];
        }
        
        if (p.teaPref.length == 0 && p.coffeePref.length == 0 && p.otherPref.length == 0 )
        {
            [text appendString:@"\rJust ask me. I'm too lazy to enter a preference."];
        }
        
        [text appendString:@"\r\r"];

    }
    
    return text;
    
}

- (void)sendEmailTo: (NSString *) to Subject:(NSString *) subject Body:(NSString *) body
{
    NSString *encodedSubject = [NSString stringWithFormat:@"SUBJECT=%@", [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *encodedBody = [NSString stringWithFormat:@"BODY=%@", [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *encodedTo = [to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedURLString = [NSString stringWithFormat:@"mailto:%@?%@&%@", encodedTo, encodedSubject, encodedBody];
    NSURL *mailtoURL = [NSURL URLWithString:encodedURLString];
    
    [[NSWorkspace sharedWorkspace] openURL:mailtoURL];
}



- (NSInteger) randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min);
}

#pragma mark - Object Life Cycle

- (void) viewDidAppear
{
    [self.informButton setHidden:YES];
    [self.informButton setImage:[NSImage imageNamed:NSImageNameShareTemplate]];
    [self.informButton sendActionOn:NSLeftMouseDownMask];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSArray* a = [[NSUserDefaults standardUserDefaults] objectForKey:@"contestants"];
    NSArray* a = [JSFileManager loadContestants];
    contestants = [[NSMutableArray alloc] init];
    
    
    if (a)
    {
        for (NSDictionary* dict in a)
        {
            JSPlayer* p = [[JSPlayer alloc] initWithDict:dict];
            
            if (p.playing == YES)
            {
                //NSLog(@"Players: %@", p.name);
                [contestants addObject:p];
            }
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
    
}

@end
