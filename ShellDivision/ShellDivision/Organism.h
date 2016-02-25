//
//  Organism.h
//  ShellDivision
//
//  Created by Melanie Lislie Hsu on 2/24/16.
//  Copyright © 2016 Melanie Lislie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum species {
    Snapper = 0,
    Sea = 1,
    Empty = 2
};

@interface Organism : NSObject {
    enum species sp;
}

- (void) spawn:(int) species;
- (enum species) getSpecies;

@end
