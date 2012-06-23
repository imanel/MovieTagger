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
    NSMutableArray *actors;
    NSURL *poster;
}

@property NSString *externalID, *source, *title, *genres, *directors, *writers, *overview, *released, *runtime, *rating;
@property NSMutableArray *actors;
@property NSURL *poster;

- (id)initWithExternalID:(NSString *)eID source:(NSString *)s;

- (void)loadData;

@end



// Movie Actor interface
@interface MovieActor : NSObject {
    NSString *name;
    NSString *role;
}

@property NSString *name, *role;

- (id)initWithName:(NSString *)n role:(NSString *)r;

@end