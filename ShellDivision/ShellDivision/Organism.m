//
//  Organism.m
//  ShellDivision
//
//  Created by Melanie Lislie Hsu on 2/24/16.
//  Copyright © 2016 Melanie Lislie Hsu. All rights reserved.
//

#import "Organism.h"



@implementation Organism

- (void) spawn: (int) species {
    switch (species) {
        case 0:
            sp = Snapper;
            break;
        case 1:
            sp = Sea;
            break;
        case 2:
            sp = Empty;
            break;
    }
}

- (enum species) getSpecies {
    return sp;
}

- (void) setSpecies:(int) species {
    sp = species;
}

@end
