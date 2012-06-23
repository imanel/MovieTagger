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
    genres = @"Crime,Fantasy,Thriller";
    directors = @"Tim Burton";
    writers = @"Bob Kane,Sam Hamm";
    overview = @"The Dark Knight of Gotham City begins his war on crime with his first major enemy being the clownishly homicidal Joker.";
    released = @"1989-06-23";
    runtime = @"126";
    rating = @"7.6";
    [actors addObject:[[MovieActor alloc] initWithName:@"Michael Keaton" role:@"Batman/Bruce Wayne"]];
    [actors addObject:[[MovieActor alloc] initWithName:@"Jack Nicholson" role:@"Joker/Jack Napier"]];
    poster = [[NSURL alloc] initWithString:@"http://ia.media-imdb.com/images/M/MV5BMjExNjMzMTUxNV5BMl5BanBnXkFtZTYwNzQyMTg4._V1_.jpg"];
}

- (NSString *)escapeForXML:(NSString *)string {
    return [[[[[string stringByReplacingOccurrencesOfString: @"&"  withString: @"&amp;"]
                       stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
                       stringByReplacingOccurrencesOfString: @"'"  withString: @"&#39;"]
                       stringByReplacingOccurrencesOfString: @">"  withString: @"&gt;"]
                       stringByReplacingOccurrencesOfString: @"<"  withString: @"&lt;"];
}

- (NSString *)xmlForKey:(NSString *)key value:(NSString *)value escape:(BOOL)escape {
    NSString *newValue = (escape ? [self escapeForXML:value] : value);
    return [[NSString alloc] initWithFormat:@"<%@>%@</%@>", key, newValue, key];
}

- (NSString *)toXML {
    if([[self source] isEqual:@"imdb"])
        return [self movieToXML];
    else
        return [self tvToXML];
}

- (NSString *)movieToXML {
    NSMutableArray *props = [[NSMutableArray alloc] init];
    [props addObject:[self xmlForKey:@"id" value:[self externalID] escape:NO]];
    [props addObject:[self xmlForKey:@"title" value:[self title] escape:YES]];
    [props addObject:[self xmlForKey:@"rating" value:[self rating] escape:NO]];
    [props addObject:[self xmlForKey:@"year" value:[[[self released] componentsSeparatedByString:@"-"] objectAtIndex:0] escape:NO]];
    [props addObject:[self xmlForKey:@"outline" value:[self overview] escape:YES]];
    [props addObject:[self xmlForKey:@"runtime" value:[[NSString alloc] initWithFormat:@"%@min", [self runtime]] escape:NO]];
    [props addObject:[self xmlForKey:@"thumb" value:[[self poster] absoluteString] escape:NO]];
    [props addObject:[self xmlForKey:@"genre" value:[self genres] escape:YES]];
    [props addObject:[self xmlForKey:@"director" value:[[[self directors] componentsSeparatedByString:@","] objectAtIndex:0] escape:YES]];
    for (id actor in actors) {
        NSMutableArray *actorProps = [[NSMutableArray alloc] init];
        [actorProps addObject:[self xmlForKey:@"name" value:[actor name] escape:YES]];
        [actorProps addObject:[self xmlForKey:@"role" value:[actor role] escape:YES]];
        NSString *actorXML = [[NSString alloc] initWithFormat:@"\n    %@\n  ", [actorProps componentsJoinedByString:@"\n    "]];
        [props addObject:[self xmlForKey:@"actor" value:actorXML escape:NO]];
    }
    NSString *propsXML = [[NSString alloc] initWithFormat:@"\n  %@\n", [props componentsJoinedByString:@"\n  "]];
    return [self xmlForKey:@"movie" value:propsXML escape:NO];
}

- (NSString *)tvToXML {
    NSMutableArray *props = [[NSMutableArray alloc] init];
    [props addObject:[self xmlForKey:@"id" value:[self externalID] escape:NO]];
    [props addObject:[self xmlForKey:@"title" value:[self title] escape:YES]];
    [props addObject:[self xmlForKey:@"plot" value:[self overview] escape:YES]];
    [props addObject:[self xmlForKey:@"thumb" value:[[self poster] absoluteString] escape:NO]];
    [props addObject:[self xmlForKey:@"genre" value:[self genres] escape:YES]];
    for (id actor in actors) {
        NSMutableArray *actorProps = [[NSMutableArray alloc] init];
        [actorProps addObject:[self xmlForKey:@"name" value:[actor name] escape:YES]];
        [actorProps addObject:[self xmlForKey:@"role" value:[actor role] escape:YES]];
        NSString *actorXML = [[NSString alloc] initWithFormat:@"\n    %@\n  ", [actorProps componentsJoinedByString:@"\n    "]];
        [props addObject:[self xmlForKey:@"actor" value:actorXML escape:NO]];
    }
    NSString *propsXML = [[NSString alloc] initWithFormat:@"\n  %@\n", [props componentsJoinedByString:@"\n  "]];
    return [self xmlForKey:@"tvshow" value:propsXML escape:NO];
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
