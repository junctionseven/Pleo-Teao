//
//  JSPlayersViewController.m
//  Pleo Teao
//
//  Created by Richard Stockdale on 21/11/2014.
//  Copyright (c) 2014 Pleo. All rights reserved.
//

#import "JSPlayersViewController.h"
#import "JSPlayer.h"
#import "JSFileManager.h"

@interface JSPlayersViewController ()
{
    NSMutableArray* contestants;
}


@property (weak) IBOutlet NSButton *addPlayerButton;
@property (weak) IBOutlet NSButton *removePlayerButton;
@property (weak) IBOutlet NSTableView *tableView;



@end

@implementation JSPlayersViewController


- (IBAction)addPlayer:(id)sender
{
    JSPlayer* newPlayer = [[JSPlayer alloc] init];
    [contestants addObject:newPlayer];
    [self.tableView reloadData];
    
}

- (IBAction)removePlayer:(id)sender
{
    NSInteger row = [self.tableView selectedRow];
    if (row != -1)
    {
        [contestants removeObjectAtIndex:row];
        [self.tableView reloadData];
    }
}


#pragma mark - Table View Methods




- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    JSPlayer* player = [contestants objectAtIndex:row];
    NSString* ident = [tableColumn identifier];
    return [player valueForKey:ident];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    JSPlayer* player = [contestants objectAtIndex:row];
    NSString* ident = [tableColumn identifier];
    [player setValue:object forKey:ident];
    
    [self saveChanges];
    
    
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return contestants.count;
}

- (void) saveChanges
{
    NSMutableArray* saveArray = [[NSMutableArray alloc] init];
    for (JSPlayer* player in contestants)
    {
        NSDictionary* dict = [player dictRep];
        
        [saveArray addObject: dict];
    }
    
    //[[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"contestants"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    [JSFileManager saveContestants:saveArray];

}

- (void) viewWillDisappear
{
    [self saveChanges];
}

- (void) viewDidAppear
{
    // Do view setup here.
    
    if (!contestants)
    {
        contestants = [[NSMutableArray alloc] init];
        //NSArray* a = [[NSUserDefaults standardUserDefaults] objectForKey:@"contestants"];
        NSArray* a = [JSFileManager loadContestants];
        if (a)
        {
            for (NSDictionary* dict in a)
            {
                JSPlayer* p = [[JSPlayer alloc] initWithDict:dict];
                [contestants addObject:p];
                
            }
        }
        else
        {
            contestants = [[NSMutableArray alloc] init];
        }
    }
    [[self tableView] reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}

@end
