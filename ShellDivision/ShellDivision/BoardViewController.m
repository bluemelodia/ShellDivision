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
        NSLog(@"%d", [thisCreature getSpecies]);
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
    NSLog(@"Hi I am %d", [thisCreature getSpecies]);
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
