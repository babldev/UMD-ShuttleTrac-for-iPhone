//
//  NSDateAdditions.h
//  iNeedToDo
//
//

#import <Foundation/Foundation.h>

@interface NSDate ( Additions )

- (BOOL)isYearMonthAndDayEqual:(NSDate *)date;
- (BOOL)isOlderThanToday;

- (NSString *)monthAndDayLocalizedString;
- (NSString *)longEventDateLocalizedString;
- (NSString *)timeOfDayLocalizedString;
    
@end
