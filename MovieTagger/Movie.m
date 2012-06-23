//
//  Movie.m
//  MovieTagger
//
//  Created by Bernard Potocki on 23.06.2012.
//  Copyright (c) 2012 Rebased. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithExternalID:(NSString *)eID source:(NSString *)s {
    if(self = [super init]) {
        externalID = eID;
        source = s;
    }
    return self;
}

- (NSString *)externalID {
    return externalID;
}

- (NSString *)source {
    return source;
}

@end
