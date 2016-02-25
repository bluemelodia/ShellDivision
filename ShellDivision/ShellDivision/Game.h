//
//  Game.h
//  ShellDivision
//
//  Created by Melanie Lislie Hsu on 2/24/16.
//  Copyright © 2016 Melanie Lislie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum Turn {
    P1 = 0,
    P2 = 1
};

static int era = 160;
static int turn = 0;

@interface Game : NSObject

- (int) getTurn;
- (int) getEra;
- (void) elapseTime;

@end
