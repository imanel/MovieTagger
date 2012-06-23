//
//  Movie.h
//  MovieTagger
//
//  Created by Bernard Potocki on 23.06.2012.
//  Copyright (c) 2012 Rebased. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject {
    NSString *externalID;
    NSString *source;
}

- (id)initWithExternalID:(NSString *)eID source:(NSString *)s;

- (NSString *)externalID;
- (NSString *)source;

@end
