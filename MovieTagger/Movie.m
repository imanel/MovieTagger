//
//  Movie.m
//  MovieTagger
//
//  Created by Bernard Potocki on 23.06.2012.
//  Copyright (c) 2012 Imanel. All rights reserved.
//

#import "Movie.h"

@implementation Movie

@synthesize externalID, source, title, genres, directors, writers, overview, released, runtime, rating, actors, poster;

- (id)initWithExternalID:(NSString *)eID source:(NSString *)s {
    if(self = [super init]) {
        externalID = eID;
        source = s;
        title = genres = directors = writers = overview = released = runtime = rating = @"";
    }
    return self;
}

@end



// Movie Actor implementation
@implementation MovieActor

@synthesize name, role;

- (id)initWithName:(NSString *)n role:(NSString *)r {
    if(self = [super init]) {
        name = n;
        role = r;
    }
    return self;
}


@end
