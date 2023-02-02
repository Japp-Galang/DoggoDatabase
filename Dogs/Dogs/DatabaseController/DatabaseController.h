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
- (void)addDog:(NSString *)name age:(NSInteger)age breed:(NSString *)breed weight:(NSInteger)weight dateAdded:(NSDate *)dateAdded;
- (void)updateTable:(NSString *)table column:(NSString *)column newValue:(NSString *)newValue ident:(NSString*)ident;
- (void)deleteTable;
- (void)deleteRowFromTable:(NSString *)ident table:(NSString *)table;

@end


#endif /* DatabaseController_h */
