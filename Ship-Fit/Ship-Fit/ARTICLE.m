//
//  ARTICLE.m
//  Ship-Fit
//
//  Created by Derek Neil on 2013-11-13.
//  Copyright (c) 2013 ship-fit. All rights reserved.
//

#import "ARTICLE.h"


@implementation ARTICLE

@dynamic chapter;
@dynamic indexID;
@dynamic mainText;
@dynamic title;


- (void)prepareForDeletion
{
    [super prepareForDeletion];
    
    //http://www.adevelopingstory.com/blog/2013/04/adding-full-text-search-to-core-data.html
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    basePath = [basePath stringByAppendingPathComponent:@"shipfit_Index.sqlite"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:basePath];
    
    if (self.indexID.length) {
        [queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"DELETE FROM docs WHERE name = ?", self.indexID];
        }];
    }
}



- (void)willSave
{
    [super willSave];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"shipfit_Index.sqlite"];
    
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    /*
     test
     [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
     [db executeUpdate:@"CREATE VIRTUAL TABLE IF NOT EXISTS docs USING fts4(name, contents);"];
     }];
     
     FMDatabase *database = [FMDatabase databaseWithPath:path];
     [database open];
     [database executeUpdate:@"INSERT INTO docs (name, contents) VALUES(?, ?);", @"doc1", @"She sells sea shells by the sea shore."];
     NSLog(@"%@", path);
     */
    
    
    
    
    if (self.indexID.length) {
        [queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"UPDATE docs SET contents = ? WHERE name = ?;", self.mainText, self.indexID];
        }];
    }
    else {
        
        //create a uuid
        CFUUIDRef udid = CFUUIDCreate(NULL);
        NSString *udidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
        
        __block NSString *name = udidString;
        
        [queue inDatabase:^(FMDatabase *db) {
            if (![db executeUpdate:@"INSERT INTO docs (name, contents) VALUES(?, ?);", name, self.mainText]) {
                name = nil;
            }
        }];
        
        self.indexID = name;
    }
}

@end
