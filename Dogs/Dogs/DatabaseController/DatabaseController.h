//
//  DatabaseController.h
//  Dogs
//
//  Created by Japp Galang on 1/27/23.
//

#ifndef DatabaseController_h
#define DatabaseController_h

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DatabaseController : NSObject


+ (instancetype)sharedInstance;

- (NSArray *)getAllDogs;
- (NSInteger)getDogSize;

- (NSArray *)returnDogImages:(NSString *)ident;

- (void)addDog:(NSString *)name age:(NSInteger)age breed:(NSString *)breed weight:(NSInteger)weight dateAdded:(NSDate *)dateAdded;
- (void)addImage:(NSData *)image ident:(NSString *)ident;
- (void)updateTable:(NSString *)table column:(NSString *)column newValue:(NSString *)newValue ident:(NSString*)ident;
- (void)deleteTable;
- (void)deleteRowFromDog:(NSString *)ident;
- (void)deleteRowFromImage:(NSString *)ident;

@end


#endif /* DatabaseController_h */
