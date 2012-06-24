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
    NSDictionary *queryResult = [self dataFromQuery];
    
    if(queryResult == NULL) {
        NSRunInformationalAlertPanel(@"MovieTagger", @"Could not load data. Please try again later.", @"OK", nil, nil);
    } else {
        title = [queryResult objectForKey:@"title"];
        genres = [[queryResult objectForKey:@"genres"] componentsJoinedByString:@","];
        directors = [[queryResult objectForKey:@"directors"] componentsJoinedByString:@","];
        writers = [[queryResult objectForKey:@"writers"] componentsJoinedByString:@","];
        overview = [queryResult objectForKey:@"overview"];
        released = [queryResult objectForKey:@"release_date"];
        runtime = [queryResult objectForKey:@"runtime"];
        rating = [queryResult objectForKey:@"rating"];
        poster = [[NSURL alloc] initWithString:[[queryResult objectForKey:@"posters"] objectAtIndex:0]];
        actors = [[NSMutableArray alloc] init];
        for(NSDictionary *actor in [queryResult objectForKey:@"actors"]) {
            [actors addObject:[[MovieActor alloc] initWithName:[[actor allKeys] objectAtIndex:0]
                                                          role:[[actor allValues] objectAtIndex:0]]];
        }
    }
}

- (NSDictionary *)dataFromQuery {
    NSURL *url = [self urlForQuery];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSError *error = NULL;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[json_string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    if(error != NULL) {
        return NULL;
    } else if(![[result objectForKey:@"status"] isEqual:@"success"]) {
        return NULL;
    } else {
        return [result objectForKey:@"result"];
    }
}

- (NSURL *)urlForQuery {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://unified-db.heroku.com/api?b=%@&id=%@", source, externalID];
    return [NSURL URLWithString:urlString];
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
