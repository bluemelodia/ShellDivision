//
//  BoardViewController.m
//  ShellDivision
//
//  Created by Melanie Lislie Hsu on 2/24/16.
//  Copyright © 2016 Melanie Lislie Hsu. All rights reserved.
//

#import "BoardViewController.h"
#import "BoardCollectionViewCell.h"
#import "Organism.h"
#import "Game.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const GAME_STATE = @"GameState";
static NSString *const BOARD_STATE = @"BoardState";
static NSString *const EVENT_MESSAGE = @"EventMessage";
static NSString *const EVENT_DETAIL = @"EventDetail";

@interface BoardViewController () {
    NSMutableArray *organisms;
    Game *game;
    NSString *eventMessage;
    NSString *eventDetails;
}

@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(43, 43);
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 3;
    
    [self.board setCollectionViewLayout:flow];
    [self.board setBackgroundColor:[UIColor clearColor]];
    
    UINib *nib = [UINib nibWithNibName:@"BoardCollectionViewCell" bundle:nil];
    [self.board registerNib:nib forCellWithReuseIdentifier:@"BoardCell"];
    organisms = [[NSMutableArray alloc] initWithCapacity:64];
    
    // change the button appearances
    self.eraLabel.layer.masksToBounds = YES;
    self.eraLabel.layer.cornerRadius = 8;
    self.snapperPopulation.layer.masksToBounds = YES;
    self.snapperPopulation.layer.cornerRadius = 8;
    self.seaPopulation.layer.masksToBounds = YES;
    self.seaPopulation.layer.cornerRadius = 8;
    self.restartButton.layer.masksToBounds = YES;
    self.restartButton.layer.cornerRadius = 8;
    self.turnLabel.layer.masksToBounds = YES;
    self.turnLabel.layer.cornerRadius = 8;
    
    // want to save the Game state in-between runs
    if (![[NSUserDefaults standardUserDefaults]dataForKey:GAME_STATE]) {
        game = [[Game alloc] init];
        game.turn = P1;
        game.era = 300;
        NSLog(@"NEW GAME");
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:game];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:GAME_STATE];
        
        // initialize the tile states to empty
        for (int i = 0; i < 64; i++) {
            Organism *newCreature = [[Organism alloc] init];
            [newCreature spawn:Empty];
            [organisms addObject:newCreature];
        }
        NSData *orgData = [NSKeyedArchiver archivedDataWithRootObject:organisms];
        [[NSUserDefaults standardUserDefaults] setObject:orgData forKey:BOARD_STATE];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:GAME_STATE];
        game = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        game.turn = [game getTurn];
        game.era = [game getEra];
        //NSLog(@"%d %d", [thisGame getTurn], [thisGame getEra]);
        //[thisGame elapseTime];
        //NSLog(@"%d %d", [thisGame getTurn], [thisGame getEra]);
        
        // Synch test succeeded - should do this after each turn, but you also have to save the board!
        //NSData *dataToSave = [NSKeyedArchiver archivedDataWithRootObject:game];
        //[[NSUserDefaults standardUserDefaults] setObject:dataToSave forKey:GAME_STATE];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        
        NSData *orgData = [defaults objectForKey:BOARD_STATE];
        organisms = [NSKeyedUnarchiver unarchiveObjectWithData:orgData];
        [self countSpecies];
    }
    
    // get the event strings
    if (![[NSUserDefaults standardUserDefaults]stringForKey:EVENT_MESSAGE]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:EVENT_MESSAGE];
    } else {
        eventMessage = [[NSUserDefaults standardUserDefaults]objectForKey:EVENT_MESSAGE];
    }
    if (![[NSUserDefaults standardUserDefaults]stringForKey:EVENT_DETAIL]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:EVENT_DETAIL];
    } else {
        eventDetails = [[NSUserDefaults standardUserDefaults]objectForKey:EVENT_DETAIL];
    }
    [self.event setText:eventMessage];
    [self.details setText:eventDetails];
    
    [self displayNextTurn];
    [self.eraLabel setText:[NSString stringWithFormat:@"%d mya", game.era]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 64;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BoardCollectionViewCell *cell = [self.board dequeueReusableCellWithReuseIdentifier:@"BoardCell" forIndexPath:indexPath];
    Organism *thisCreature = [organisms objectAtIndex:indexPath.row];
    [cell setCellImageByState:[thisCreature getSpecies]];
    //NSLog(@"Hi I am %d", [thisCreature getSpecies]);
    return cell;
}

// TODO, start a game, set the turn, and add logic to change turns
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BoardCollectionViewCell *cell = (BoardCollectionViewCell *) [self.board cellForItemAtIndexPath:indexPath];
    Organism *thisCreature = [organisms objectAtIndex:indexPath.row];
    // new organism can only spawn in an empty cell
    if ([thisCreature getSpecies] == Empty) {
        switch (game.turn) {
            case P1:
                [thisCreature setSpecies:Snapper];
                game.turn = P2;
                break;
            case P2:
                [thisCreature setSpecies:Sea];
                game.turn = P1;
                break;
        }
        [cell setCellImageByState:[thisCreature getSpecies]];
    }
    // kill organisms
    [self interCompetition];
}

/* 
 Grid indices:
    0  1  2  3  4  5  6  7
    8  9  10 11 12 13 14 15
    16 17 18 19 20 21 22 23
    24 25 26 27 28 29 30 31
    32 33 34 35 36 37 38 39
    40 41 42 43 44 45 46 47
    48 49 50 51 52 53 54 55
    56 57 58 59 60 61 62 63
 
 If 5 or more competitors around the organism, the organism is converted to the other species.
 Competitors: species different from the organism directly surrounding it.
 
 This will take effect each turn, so it's possible to cause chain reactions turn after turn.
 */
- (void)interCompetition {
    NSMutableArray *toDie = [[NSMutableArray alloc] init];
    for (int i = 0; i < 64; i++) {
        Organism *thisCreature = [organisms objectAtIndex:i];
        int species = [thisCreature getSpecies];
        int competitors = 0;
        if (species == Empty) continue;
        //TODO: if species is some predator or parasite don't do conversions
        if (i%8 != 0) { // get the left organism, can't get left if on the left edge
            Organism *left = [organisms objectAtIndex:i-1];
            if ([left getSpecies] != Empty && [left getSpecies] != species) {
                competitors++;
                NSLog(@"LEFT of %d", i);
            }
        } if (i%8 != 7) { // get the right organism, can't get right if on the right corner
            Organism *right = [organisms objectAtIndex:i+1];
            if ([right getSpecies] != Empty && [right getSpecies] != species) {
                competitors++;
                NSLog(@"RIGHT of %d", i);
            }
        } if (i-8 >= 0) { // get the organism above it, can't go further up if in first row
            Organism *up = [organisms objectAtIndex:i-8];
            if ([up getSpecies] != Empty && [up getSpecies] != species) {
                competitors++;
                NSLog(@"UP of %d", i);
            }
        } if (i+8 < 64 && i < 56) { // get the organism below it, can't go further down if in the last row
            Organism *down = [organisms objectAtIndex:i+8];
            if ([down getSpecies] != Empty && [down getSpecies] != species) {
                competitors++;
                NSLog(@"DOWN of %d", i);
            }
        }
        if (i%8 != 0 && (i-9) >= 0) { // get diagonal left up organism
            Organism *lu = [organisms objectAtIndex:i-9];
            if ([lu getSpecies] != Empty && [lu getSpecies] != species) {
                competitors++;
                NSLog(@"DIA LEFT UP of %d", i);
            }
        }
        if (i%8 != 7 && (i-7) >= 0) { // get diagonal right up organism
            Organism *ru = [organisms objectAtIndex:i-7];
            if ([ru getSpecies] != Empty && [ru getSpecies] != species) {
                competitors++;
                NSLog(@"DIA RIGHT UP of %d", i);
            }
        }
        if (i%8 != 0 && (i+7) < 64) { // get diagonal left down organism
            Organism *ld = [organisms objectAtIndex:i+7];
            if ([ld getSpecies] != Empty && [ld getSpecies] != species) {
                competitors++;
                NSLog(@"DIA LEFT DOWN of %d", i);
            }
        }
        if (i%8 != 7 && (i+9) < 64) { // get diagonal right down organism
            Organism *rd = [organisms objectAtIndex:i+9];
            if ([rd getSpecies] != Empty && [rd getSpecies] != species) {
                competitors++;
                NSLog(@"DIA RIGHT DOWN of %d", i);
            }
        }
        if (competitors > 4) [toDie addObject:[NSNumber numberWithInt:i]];
        if (competitors > 4) NSLog(@"Death to %d with competitors %d", i, competitors);
    }
    
    // convert the organisms that were outcompeted
    for (int i = 0; i < [toDie count]; i++) {
        NSNumber *dyingOrg = [toDie objectAtIndex:i];
        Organism *deadOrg = [organisms objectAtIndex:[dyingOrg intValue]];
        if ([deadOrg getSpecies] == Snapper) {
            [deadOrg setSpecies:Sea];
        } else if ([deadOrg getSpecies] == Sea) {
            [deadOrg setSpecies:Snapper];
        }
    }
    game.era = [game elapseTime];
    [self.eraLabel setText:[NSString stringWithFormat:@"%d mya", game.era]];
    [self countSpecies];
    
    if ([self checkWin]) {
        NSString *message;
        NSString *victor;
        switch ([self determineVictor]) {
            case 1:
                victor = @"Snappers Win";
                message = @"Snapping turtles have become the dominant species!";
                break;
            case 2:
                victor = @"Sea Turtles Win";
                message = @"Sea turtles rule!";
                break;
            case 3:
                victor = @"Total Extinction";
                message = @"Unfortunately, neither of you made it to the modern era...";
                break;
            case 4:
                victor = @"No Clear Victor";
                message = @"Looks like you'll have to share!";
                break;
        }
        [self.event setText:victor];
        [self.details setText:message];
        [[NSUserDefaults standardUserDefaults] setObject:victor forKey:EVENT_MESSAGE];
        [[NSUserDefaults standardUserDefaults] setObject:message forKey:EVENT_DETAIL];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.board.userInteractionEnabled = NO;
    } else {
        [self displayNextTurn];
        // update the game object
        NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:game];
        [[NSUserDefaults standardUserDefaults]setObject:savedData forKey:GAME_STATE];
        NSData *savedOrgData = [NSKeyedArchiver archivedDataWithRootObject:organisms];
        [[NSUserDefaults standardUserDefaults] setObject:savedOrgData forKey:BOARD_STATE];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.board reloadData];
    }
}

- (int) determineVictor {
    int snapCount = 0;
    int seaCount = 0;
    for (int i = 0; i < 64; i++) {
        Organism *thisCreature = [organisms objectAtIndex:i];
        if ([thisCreature getSpecies] == Snapper) snapCount++;
        else if ([thisCreature getSpecies] == Sea) seaCount++;
    }
    if (snapCount > seaCount) return 1;
    else if (seaCount > snapCount) return 2;
    else if (seaCount == snapCount == 0) return 3;
    else return 4;
}

- (BOOL) checkWin {
    NSLog(@"ERA: %d", game.era);
    if ([self isGridFull]) {
        return true;
    } else if (game.era <= 0) {
        return true;
    }
    return false;
}

// take population counts
- (void) countSpecies {
    int snapCount = 0;
    int seaCount = 0;
    for (int i = 0; i < 64; i++) {
        Organism *thisCreature = [organisms objectAtIndex:i];
        if ([thisCreature getSpecies] == Snapper) snapCount++;
        else if ([thisCreature getSpecies] == Sea) seaCount++;
    }
    [self.snapperPopulation setText:[NSString stringWithFormat:@"Snapper: %d", snapCount]];
    [self.seaPopulation setText:[NSString stringWithFormat:@"Sea: %d", seaCount]];
}

// display the organism whose next turn it is
- (void) displayNextTurn {
    UIImage *image;
    if (game.turn == P1) {
        image = [UIImage imageNamed:@"Snapper.imageset"];
    } else {
        image = [UIImage imageNamed:@"Sea.imageset"];
    }
    [self.nextTurn setImage:image];
}

// check if the grid is full
- (BOOL) isGridFull {
    for (int i = 0; i < 64; i++) {
        Organism *thisCreature = [organisms objectAtIndex:i];
        if ([thisCreature getSpecies] == Empty) return false;
    }
    return true;
}

- (IBAction)restartGame:(id)sender {
    self.board.userInteractionEnabled = YES;
    [self.event setText:@""];
    [self.details setText:@""];
    game.turn = P1;
    game.era = 300;
    // initialize the tile states to empty
    for (int i = 0; i < 64; i++) {
        Organism *thisCreature = [organisms objectAtIndex:i];
        [thisCreature setSpecies:Empty];
    }
    
    [self.eraLabel setText:[NSString stringWithFormat:@"%d mya", game.era]];
    [self countSpecies];
    [self displayNextTurn];
    
    // update the game object
    NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:game];
    [[NSUserDefaults standardUserDefaults]setObject:savedData forKey:GAME_STATE];
    NSData *savedOrgData = [NSKeyedArchiver archivedDataWithRootObject:organisms];
    [[NSUserDefaults standardUserDefaults] setObject:savedOrgData forKey:BOARD_STATE];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:EVENT_MESSAGE];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:EVENT_DETAIL];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.board reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
