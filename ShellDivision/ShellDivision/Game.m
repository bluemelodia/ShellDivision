//
//  Game.m
//  ShellDivision
//
//  Created by Melanie Lislie Hsu on 2/24/16.
//  Copyright © 2016 Melanie Lislie Hsu. All rights reserved.
//

#import "Game.h"

@implementation Game

- (void) elapseTime {
    era -= 5;
}

// randomly choose who goes first
- (void) pickFirst {
    NSInteger randomNumber = arc4random() % 2;
    switch (randomNumber) {
        case 0:
            turn = 0;
            break;
            
        default:
            turn = 1;
            break;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSMutableArray *gameInfo = [[NSMutableArray alloc] initWithCapacity:2];
    NSNumber* wrappedTurn = [NSNumber numberWithInt:turn];
    [gameInfo insertObject:wrappedTurn atIndex:0];
    NSNumber* wrappedEra = [NSNumber numberWithInt:era];
    [gameInfo insertObject:wrappedEra atIndex:1];
    [aCoder encodeObject:gameInfo forKey:@"GAME_INFO"];
}

@end
