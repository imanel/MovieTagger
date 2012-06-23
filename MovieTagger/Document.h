//
//  Document.h
//  MovieTagger
//
//  Created by Bernard Potocki on 23.06.2012.
//  Copyright (c) 2012 Imanel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Movie.h"

@interface Document : NSDocument <NSTableViewDataSource> {
    NSRegularExpression *regexpClearCharacters;
    NSRegularExpression *regexpClearWhitespaces;
    
    // Search View
    IBOutlet NSView *searchView;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSSegmentedControl *searchType;
    IBOutlet NSTableView *searchResultsTable;
    NSArray *searchResults;
    
    // Movie View
    IBOutlet NSView *movieView;
    IBOutlet NSTextField *movieTitle;
    IBOutlet NSTextField *movieGenres;
    IBOutlet NSTextField *movieDirectors;
    IBOutlet NSTextField *movieWriters;
    IBOutlet NSTextField *movieOverview;
    IBOutlet NSTextField *movieReleased;
    IBOutlet NSTextField *movieRuntime;
    IBOutlet NSTextField *movieRating;
    IBOutlet NSImageView *moviePoster;
    IBOutlet NSTableView *movieActors;
    Movie *movie;
}

// Search View
- (IBAction)performSearch:(id)sender;
- (IBAction)tableClicked:(id)sender;
- (IBAction)selectMovie:(id)sender;

// Movie View
- (IBAction)cancelSelection:(id)sender;

@end
