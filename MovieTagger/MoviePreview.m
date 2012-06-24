//
//  MoviePreview.m
//  MovieTagger
//
//  Created by Bernard Potocki on 23.06.2012.
//  Copyright (c) 2012 Imanel. All rights reserved.
//

#import "MoviePreview.h"

@implementation MoviePreview

@synthesize externalID, title, year, source;

+ (NSArray *)findByTitle:(NSString *)t source:(NSString *)s {
    NSArray *queryResults = [self queryForTitle:t source:s];
    
    if(queryResults == NULL) {
        NSRunInformationalAlertPanel(@"MovieTagger", @"Could not load data. Please try again later.", @"OK", nil, nil);
        return [[NSArray alloc] init];
    } else {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for(id queryResult in queryResults) {
            [results addObject:[[self alloc] initWithExternalID:[queryResult objectForKey:@"id"]
                                                          title:[queryResult objectForKey:@"title"]
                                                           year:[queryResult objectForKey:@"year"]
                                                         source:s]];
        }
        return results;
    }
}

+ (NSArray *)queryForTitle:(NSString *)t source:(NSString *)s {
    NSURL *url = [self urlForTitle:t source:s];
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

+ (NSURL *)urlForTitle:(NSString *)t source:(NSString *)s {
    CFStringRef escapeChars = (CFStringRef) @":/?#[]@!$&’()*+,;=";
    NSString *titleForSearch = (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge_retained CFStringRef) t, NULL, escapeChars, kCFStringEncodingUTF8);
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://unified-db.heroku.com/api?b=%@&t=%@", s, titleForSearch];
    return [NSURL URLWithString:urlString];
}

- (id)initWithExternalID:(NSString *)eID title:(NSString *)t year:(NSString *)y source:(NSString *)s {
    if(self = [super init]) {
        externalID = eID;
        title = t;
        year = y;
        source = s;
    }
    return self;
}

- (NSString *)url {
    if([source isEqual:@"imdb"])
        return [@"http://www.imdb.com/title/" stringByAppendingString:externalID];
    if([source isEqual:@"tvdb"])
        return [@"http://thetvdb.com/?tab=series&id=" stringByAppendingString:externalID];
    return @"about:blank";
}

@end
