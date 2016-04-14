//
//  Organism.h
//  ShellDivision
//
//  Created by Melanie Lislie Hsu on 2/24/16.
//  Copyright © 2016 Melanie Lislie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum species {
    Empty = 0,
    Snapper = 1,
    Sea = 2,
};

@interface Organism : NSObject {
    enum species sp;
}

- (void) spawn:(int) species;
- (enum species) getSpecies;
- (void) setSpecies:(int) species;

@end
