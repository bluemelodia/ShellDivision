//
//  Time.m
//  ShellDivision
//
//  Created by Melanie Lislie Hsu on 2/24/16.
//  Copyright © 2016 Melanie Lislie Hsu. All rights reserved.
//

#import "Time.h"

@implementation Time

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

@end
