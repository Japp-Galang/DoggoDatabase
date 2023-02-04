//
//  DatabaseController.m
//  Dogs
//
//  Created by Japp Galang on 1/27/23.
//

#import "DatabaseController.h"
#import "FMDB.h"


@interface DatabaseController()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation DatabaseController

+ (instancetype)sharedInstance
{
    static DatabaseController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"database.sqlite"];
        
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:writableDBPath];
        
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Dog(ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, breed TEXT, weight INTEGER, dateAdded TEXT)"];
        }];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Image(imageID INTEGER PRIMARY KEY AUTOINCREMENT, dogID INTEGER NOT NULL, image BLOB, FOREIGN KEY(dogID) REFERENCES Dog(ID))"];
        }];
    }
    return self;
}



/*
Adds dog to database of table: Dog
 */
- (void)addDog:(NSString *)name age:(NSInteger)age breed:(NSString *)breed weight:(NSInteger)weight dateAdded:(NSDate *)dateAdded
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateAddedString = [dateFormatter stringFromDate:dateAdded];
        
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO Dog (name, age, breed, weight, dateAdded) VALUES (?, ?, ?, ?, ?)", name, @(age), breed, @(weight), dateAddedString];
    }];
}
- (void)deleteTable
{
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DROP TABLE Dog"];
    }];
}



/*
 Adds image to associated dog ID, where
 ident: Dog ID
 image: The image to be uploaded
 */
- (void)addImage:(NSData *)image ident:(NSString *)ident
{
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:@"INSERT INTO Image (dogID, image) VALUES (?, ?)", ident, image];
        if (!success) {
            NSLog(@"Error deleting row: %@", [db lastErrorMessage]);
        }
    }];
}



/*
 Call to return an Array of dictionaries of each entity in the table: Dog
 */
- (NSArray *)getAllDogs
{
    __block NSMutableArray *dogs = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM Dog"];
        while ([result next]) {
            
            NSInteger ident     = [result intForColumn:@"ID"];
            NSString *name      = [result stringForColumn:@"name"];
            NSInteger age       = [result intForColumn:@"age"];
            NSString *breed     = [result stringForColumn:@"breed"];
            NSInteger weight    = [result intForColumn:@"weight"];
            NSString *dateAdded = [result stringForColumn:@"dateAdded"];
            
            [dogs addObject:@{@"ID": @(ident), @"name": name, @"age": @(age), @"breed": breed, @"weight": @(weight), @"dateAdded":dateAdded}];
        }
    }];
    return [dogs copy];
}



/*
 Returns the images of a selected Dog ID
 */
- (NSArray *)returnDogImages:(NSString *)ident
{
    __block NSMutableArray *dogImages = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM Image WHERE dogID = %@", ident]];
        while ([result next]) {
            NSData *dogData     = [result dataForColumn:@"image"];
            [dogImages addObject:dogData];
        }
    }];
    NSLog(@"%@", dogImages);
    return [dogImages copy];
}



/*
 returns the size of table: Dog
 */
- (NSInteger)getDogSize
{
  __block NSInteger finalResult = 0;
  [self.databaseQueue inDatabase:^(FMDatabase *db) {
    FMResultSet *result = [db executeQuery:@"SELECT COUNT(*) FROM Dog"];
    if ([result next]) {
      finalResult = [result intForColumnIndex:0];
    }
  }];
    NSLog(@"size: %ld", (long)finalResult);
  return finalResult;
}



/*
 Method to update the table given paremeter of the column being updated
 Parameters:
 NSString: table
 NSString: column
 */
- (void)updateTable:(NSString *)table column:(NSString *)column newValue:(NSString *)newValue ident:(NSString *)ident
{
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = %@ WHERE ID = %@", table, column, newValue, ident]];
    }];
    NSLog(@"UPDATE %@ SET %@ = %@ WHERE ID = %@", table, column, newValue, ident);
}
 


/*
 Deletes a row,
 Parameters:
 NSInteger: ident
 NSString: table
 */
- (void)deleteRowFromTable:(NSString *)ident table:(NSString *)table
{
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE ID = %@", table, ident]];
        if (!success) {
            NSLog(@"Error deleting row: %@", [db lastErrorMessage]);
        }
    }];
}




@end
