//
//  Game.m
//  ShellDivision
//
//  Created by Melanie Lislie Hsu on 2/24/16.
//  Copyright © 2016 Melanie Lislie Hsu. All rights reserved.
//

#import "Game.h"

@implementation Game

// advance the era every two turns (P1 and P2 both went)
- (void) elapseTime {
    era -= 2;
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

- (id)initWithCoder:(NSCoder *)decoder {
    NSMutableArray *gameInfo = [decoder decodeObjectForKey:@"GAME_INFO"];
    turn = (int)[[gameInfo objectAtIndex:0] integerValue];
    era = (int)[[gameInfo objectAtIndex:1] integerValue];
    return self;
}

// allows saving into NSUserDefaults
- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSMutableArray *gameInfo = [[NSMutableArray alloc] initWithCapacity:2];
    NSNumber* wrappedTurn = [NSNumber numberWithInt:turn];
    [gameInfo insertObject:wrappedTurn atIndex:0];
    NSNumber* wrappedEra = [NSNumber numberWithInt:era];
    [gameInfo insertObject:wrappedEra atIndex:1];
    [aCoder encodeObject:gameInfo forKey:@"GAME_INFO"];
}

- (int) getTurn {
    return turn;
}

- (int) getEra {
    return era;
}

@end
