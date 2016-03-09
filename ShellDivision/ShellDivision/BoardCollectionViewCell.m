//
//  BoardCollectionViewCell.m
//  ShellDivision
//
//  Created by Melanie Lislie Hsu on 2/24/16.
//  Copyright © 2016 Melanie Lislie Hsu. All rights reserved.
//

#import "BoardCollectionViewCell.h"

@implementation BoardCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellImageByState:(int) state {
    //NSLog(@"State: %d", state);
    UIImage *image;
    if (state == 0) {
        image = [UIImage imageNamed:@"Shell.imageset"];
        [self.cellImage setImage:image];
        [self.cellImage setAlpha:0.2];
        self.userInteractionEnabled = YES;
    } else if (state == 1) {
        image = [UIImage imageNamed:@"Snapper.imageset"];
        [self.cellImage setImage:image];
        [self.cellImage setAlpha:1];
        self.userInteractionEnabled = NO;
    } else {
        image = [UIImage imageNamed:@"Sea.imageset"];
        [self.cellImage setImage:image];
        [self.cellImage setAlpha:1];
        self.userInteractionEnabled = NO;
    }
}

@end
