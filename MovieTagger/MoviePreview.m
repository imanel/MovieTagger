//
//  MoviePreview.m
//  MovieTagger
//
//  Created by Bernard Potocki on 23.06.2012.
//  Copyright (c) 2012 Imanel. All rights reserved.
//

#import "MoviePreview.h"

@implementation MoviePreview

+ (NSArray *)findByTitle:(NSString *)t source:(NSString *)s {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:[[self alloc] initWithExternalID:@"12"
                                                 title:@"test 1"
                                                  year:@"1999"
                                                source:s]];
    [result addObject:[[self alloc] initWithExternalID:@"13"
                                                 title:@"test 2"
                                                  year:@"2000"
                                                source:s]];
    [result addObject:[[self alloc] initWithExternalID:@"14"
                                                 title:@"test 3"
                                                  year:@"2001"
                                                source:s]];
    return result;
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

- (NSString *)externalID {
    return externalID;
}

- (NSString *)title {
    return title;
}

- (NSString *)year {
    return year;
}

- (NSString *)source {
    return source;
}

- (NSString *)url {
    if([source isEqual:@"imdb"])
        return [@"http://www.imdb.com/title/" stringByAppendingString:externalID];
    if([source isEqual:@"tvdb"])
        return [@"http://thetvdb.com/?tab=series&id=" stringByAppendingString:externalID];
    return @"about:blank";
}

@end
