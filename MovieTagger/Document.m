//
//  Document.m
//  MovieTagger
//
//  Created by Bernard Potocki on 23.06.2012.
//  Copyright (c) 2012 Imanel. All rights reserved.
//

#import "Document.h"
#import "MoviePreview.h"

@implementation Document

+ (BOOL)autosavesInPlace {
    return NO;
}

- (id)init {
    self = [super init];
    if (self) {
        NSError *regexpError = NULL;
        regexpClearCharacters = [NSRegularExpression regularExpressionWithPattern:@"\\.\\w{1,4}$|[\\,\\.\\-\\_\\[\\]\\(\\)]"
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:&regexpError];
        regexpClearWhitespaces = [NSRegularExpression regularExpressionWithPattern:@"\\ \\ "
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&regexpError];
    }
    return self;
}

- (NSString *)windowNibName {
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    [searchField setStringValue:[self guessName]];
    [self performSearch:NULL];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)isEntireFileLoaded {
    return NO;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError {
    return YES;
}

- (NSURL *)documentDirectory {
    return [[self fileURL] URLByDeletingLastPathComponent];
}

- (void)setCurrentView:(NSView *)view {
    NSWindow *mainWindow = [[[self windowControllers] objectAtIndex:0] window];
    
    NSRect newFrameRect = [mainWindow frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [mainWindow frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;
    
    NSRect frame = [mainWindow frame];
    frame.size = newSize;
    frame.origin.y -= (newSize.height - oldSize.height) / 2;
    frame.origin.x -= (newSize.width - oldSize.width) / 2;
    
    [mainWindow setContentView:view];
    [mainWindow setFrame:frame display:YES animate:YES];
}

- (NSString *)guessName {
    NSString *result = [[self fileURL] lastPathComponent];
    // Replace extenstion and unnecessary characters with spaces
    result = [regexpClearCharacters stringByReplacingMatchesInString:result
                                                             options:0
                                                               range:NSMakeRange(0, [result length])
                                                        withTemplate:@" "];
    // Strip duplicate spaces
    result = [regexpClearWhitespaces stringByReplacingMatchesInString:result
                                                              options:0
                                                                range:NSMakeRange(0, [result length])
                                                         withTemplate:@" "];
    // Strip trailing spaces
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result;
}

- (NSString *)backendName {
    switch([searchType selectedSegment]) {
        case 0: default:
            return @"imdb";
            break;
        case 1:
            return @"tvdb";
            break;
    }
}

- (IBAction)performSearch:(id)sender {
    NSString *backend = [self backendName];
    searchResults = [MoviePreview findByTitle:[searchField stringValue] source:backend];
    [searchResultsTable reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if([[tableView identifier] isEqual:@"search table"]) {
        return [searchResults count];
    } else {
        return [movieActorsList count];
    }
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)col row:(NSInteger)rowIndex {
    NSString *rv;
    if([[aTableView identifier] isEqual:@"search table"]) {
        MoviePreview *mp = [searchResults objectAtIndex:rowIndex];
        if([[col identifier] isEqual:@"title"]) {
            rv = [mp title];
        } else if([[col identifier] isEqual:@"year"]) {
            rv = [mp year];
        } else {
            rv = @"see \u25B8";
        }
    } else {
        MovieActor *ma = [movieActorsList objectAtIndex:rowIndex];
        if([[col identifier] isEqual:@"actor"]) {
            rv = [ma name];
        } else {
            rv = [ma role];
        }
    }
    return rv;
}

- (IBAction)tableClicked:(id)sender {
    int column = [sender clickedColumn];
    if(column == 2) {
        int row = [sender clickedRow];
        MoviePreview *mp = [searchResults objectAtIndex:row];
        if(mp)
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[mp url]]];
    }
}

- (IBAction)selectMovie:(id)sender {
    if([searchResultsTable selectedRow] >= 0) {
        MoviePreview *mp = [searchResults objectAtIndex:[searchResultsTable selectedRow]];
        movie = [[Movie alloc] initWithExternalID:[mp externalID] source:[mp source]];
        [self setCurrentView:movieView];
        [movie loadData];
        [self showMovie];
    } else {
        NSRunInformationalAlertPanel(@"MovieTagger", @"Please select movie first", @"OK", nil, nil);
    }
}

- (void)showMovie {
    [movieTitle setStringValue:[movie title]];
    [movieGenres setStringValue:[movie genres]];
    [movieDirectors setStringValue:[movie directors]];
    [movieWriters setStringValue:[movie writers]];
    [movieOverview setStringValue:[movie overview]];
    [movieReleased setStringValue:[movie released]];
    [movieRuntime setStringValue:[movie runtime]];
    [movieRating setStringValue:[movie rating]];
    movieActorsList = [movie actors];
    [movieActors reloadData];
    NSImage *poster = [[NSImage alloc] initWithContentsOfURL:[movie poster]];
    [moviePoster setImage:poster];
}

- (IBAction)cancelSelection:(id)sender {
    [self setCurrentView:searchView];
}

@end
