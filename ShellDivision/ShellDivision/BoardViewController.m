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

@interface BoardViewController () {
    NSMutableArray *organisms;
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
    
    // initialize the tile states to empty
    for (int i = 0; i < 64; i++) {
        Organism *newCreature = [[Organism alloc] init];
        [newCreature spawn:Empty];
        [organisms addObject:newCreature];
    }
    for (int i = 0; i < 64; i++) {
        Organism *thisCreature = [organisms objectAtIndex:i];
        //NSLog(@"%d", [thisCreature getSpecies]);
    }
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
        switch (turn) {
            case P1:
                [thisCreature setSpecies:Snapper];
                turn = P2;
                break;
            case P2:
                [thisCreature setSpecies:Sea];
                turn = P1;
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
 */
- (void)interCompetition {
    NSMutableArray *toDie = [[NSMutableArray alloc] init];
    for (int i = 0; i < 64; i++) {
        Organism *thisCreature = [organisms objectAtIndex:i];
        int species = [thisCreature getSpecies];
        int competitors = 0;
        if (species == Empty) continue;
        if (i%8 != 0) { // get the left organism, can't get left if on the left edge
            Organism *left = [organisms objectAtIndex:i-1];
            if ([left getSpecies] != Empty && [left getSpecies] != species) {
                competitors++;
            }
        } if (i%8 != 7) { // get the right organism, can't get right if on the right corner
            Organism *right = [organisms objectAtIndex:i+1];
            if ([right getSpecies] != Empty && [right getSpecies] != species) {
                competitors++;
            }
        } if (i-8 > 0) { // get the organism above it, can't go further up if in first row
            Organism *up = [organisms objectAtIndex:i-8];
            if ([up getSpecies] != Empty && [up getSpecies] != species) {
                competitors++;
            }
        } if (i+8 < 56) { // get the organism below it, can't go further down if in the last row
            Organism *down = [organisms objectAtIndex:i+8];
            if ([down getSpecies] != Empty && [down getSpecies] != species) {
                competitors++;
            }
        }
        if (i%8 != 0 && (i-9) > 0) { // get diagonal left up organism
            Organism *lu = [organisms objectAtIndex:i-9];
            if ([lu getSpecies] != Empty && [lu getSpecies] != species) {
                competitors++;
            }
        }
        if (i%8 != 7 && (i-7) > 0) { // get diagonal right up organism
            Organism *ru = [organisms objectAtIndex:i-7];
            if ([ru getSpecies] != Empty && [ru getSpecies] != species) {
                competitors++;
            }
        }
        int diag = i+7;
        if (i%8 != 0 && (i+7) < 64) { // get diagonal left down organism
            Organism *ld = [organisms objectAtIndex:i+7];
            if ([ld getSpecies] != Empty && [ld getSpecies] != species) {
                competitors++;
            }
        }
        if (i%8 != 7 && (i+9) < 64) { // get diagonal right down organism
            Organism *rd = [organisms objectAtIndex:i+9];
            if ([rd getSpecies] != Empty && [rd getSpecies] != species) {
                competitors++;
            }
        }
        if (competitors >= 5) [toDie addObject:[NSNumber numberWithInt:i]];
        if (competitors > 0) NSLog(@"Competitors for %d: %d", i, competitors);
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
