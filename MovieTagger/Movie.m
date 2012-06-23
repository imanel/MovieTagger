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
        actors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadData {
    title = @"Batman";
    genres = @"Crime, Fantasy, Thriller";
    directors = @"Tim Burton";
    writers = @"Bob Kane, Sam Hamm";
    overview = @"The Dark Knight of Gotham City begins his war on crime with his first major enemy being the clownishly homicidal Joker.";
    released = @"1989-06-23";
    runtime = @"126";
    rating = @"7.6";
    [actors addObject:[[MovieActor alloc] initWithName:@"Michael Keaton" role:@"Batman/Bruce Wayne"]];
    [actors addObject:[[MovieActor alloc] initWithName:@"Jack Nicholson" role:@"Joker/Jack Napier"]];
    poster = [[NSURL alloc] initWithString:@"http://ia.media-imdb.com/images/M/MV5BMjExNjMzMTUxNV5BMl5BanBnXkFtZTYwNzQyMTg4._V1_.jpg"];
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
