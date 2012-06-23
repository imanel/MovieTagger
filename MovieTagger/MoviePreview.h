//
//  MoviePreview.h
//  MovieTagger
//
//  Created by Bernard Potocki on 23.06.2012.
//  Copyright (c) 2012 Imanel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoviePreview : NSObject {
    NSString *externalID;
    NSString *title;
    NSString *year;
    NSString *source;
}

@property NSString *externalID, *title, *year, *source;

+ (NSArray *)findByTitle:(NSString *)t source:(NSString *)s;

- (id)initWithExternalID:(NSString *)eID title:(NSString *)t year:(NSString *)y source:(NSString *)s;

- (NSString *)url;

@end
