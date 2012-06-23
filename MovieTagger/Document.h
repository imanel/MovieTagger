//
//  Document.h
//  MovieTagger
//
//  Created by Bernard Potocki on 23.06.2012.
//  Copyright (c) 2012 Imanel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument {
    NSRegularExpression *regexpClearCharacters;
    NSRegularExpression *regexpClearWhitespaces;
    
    // Search View
    IBOutlet NSView *searchView;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSSegmentedControl *searchType;
    IBOutlet NSTableView *searchResultsTable;
}

@end
