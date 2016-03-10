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
            sp = Empty;
            break;
        case 1:
            sp = Snapper;
            break;
        case 2:
            sp = Sea;
            break;
    }
}

- (enum species) getSpecies {
    return sp;
}

- (void) setSpecies:(int) species {
    sp = species;
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSMutableArray *orgInfo = [decoder decodeObjectForKey:@"ORG_INFO"];
    sp = (int)[[orgInfo objectAtIndex:0] integerValue];
    return self;
}

// allows saving into NSUserDefaults
- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSMutableArray *orgInfo = [[NSMutableArray alloc] initWithCapacity:1];
    NSNumber* wrappedSpecies = [NSNumber numberWithInt:sp];
    [orgInfo insertObject:wrappedSpecies atIndex:0];
    [aCoder encodeObject:orgInfo forKey:@"ORG_INFO"];
}

@end
