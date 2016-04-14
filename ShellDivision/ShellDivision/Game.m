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
- (int) elapseTime {
    self.era -= 1;
    return self.era;
}

// randomly choose who goes first
- (void) pickFirst {
    NSInteger randomNumber = arc4random() % 2;
    switch (randomNumber) {
        case 0:
            self.turn = 0;
            break;
            
        default:
            self.turn = 1;
            break;
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSMutableArray *gameInfo = [decoder decodeObjectForKey:@"GAME_INFO"];
    self.turn = (int)[[gameInfo objectAtIndex:0] integerValue];
    self.era = (int)[[gameInfo objectAtIndex:1] integerValue];
    return self;
}

// allows saving into NSUserDefaults
- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSMutableArray *gameInfo = [[NSMutableArray alloc] initWithCapacity:2];
    NSNumber* wrappedTurn = [NSNumber numberWithInt:self.turn];
    [gameInfo insertObject:wrappedTurn atIndex:0];
    NSNumber* wrappedEra = [NSNumber numberWithInt:self.era];
    [gameInfo insertObject:wrappedEra atIndex:1];
    [aCoder encodeObject:gameInfo forKey:@"GAME_INFO"];
}

- (int) getTurn {
    return self.turn;
}

- (int) getEra {
    return self.era;
}

@end
