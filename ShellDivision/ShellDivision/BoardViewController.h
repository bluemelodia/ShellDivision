//
//  BoardViewController.h
//  ShellDivision
//
//  Created by Melanie Lislie Hsu on 2/24/16.
//  Copyright © 2016 Melanie Lislie Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *board;
@property (weak, nonatomic) IBOutlet UILabel *eraLabel;
@property (weak, nonatomic) IBOutlet UILabel *snapperPopulation;
@property (weak, nonatomic) IBOutlet UILabel *seaPopulation;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextTurn;
@property (weak, nonatomic) IBOutlet UILabel *event;
@property (weak, nonatomic) IBOutlet UILabel *details;

@end
