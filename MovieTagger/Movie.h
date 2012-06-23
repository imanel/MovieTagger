//
//  Movie.h
//  MovieTagger
//
//  Created by Bernard Potocki on 23.06.2012.
//  Copyright (c) 2012 Imanel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject {
    NSString *externalID;
    NSString *source;
    NSString *title;
    NSString *genres;
    NSString *directors;
    NSString *writers;
    NSString *overview;
    NSString *released;
    NSString *runtime;
    NSString *rating;
    NSArray *actors;
    NSURL *poster;
}

@property NSString *externalID, *source, *title, *genres, *directors, *writers, *overview, *released, *runtime, *rating;
@property NSArray *actors;
@property NSURL *poster;

- (id)initWithExternalID:(NSString *)eID source:(NSString *)s;

@end
