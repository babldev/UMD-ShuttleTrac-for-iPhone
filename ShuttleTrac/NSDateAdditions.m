//
//  NSDateAdditions.m
//  iNeedToDo
//
//

#import "NSDateAdditions.h"


@implementation NSDate ( Additions )

#pragma mark Internal

- (NSString *)formattedDateWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: dateFormat];
    NSString *dateString = [formatter stringFromDate:self];
    [formatter release];
    return dateString;
}

- (NSString *)formattedDateWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:dateStyle];
    [formatter setTimeStyle:timeStyle];
    NSString *string = [formatter stringFromDate:self];
    [formatter release];
    return string;
}

#pragma mark API

- (BOOL)isYearMonthAndDayEqual:(NSDate *)date {
    NSUInteger components = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comp1 = [[NSCalendar currentCalendar] components:components fromDate:self];
    NSDateComponents *comp2 = [[NSCalendar currentCalendar] components:components fromDate:date];    
    return [comp1 isEqual:comp2];
}

- (BOOL)isOlderThanToday {
    NSUInteger components = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comp1 = [[NSCalendar currentCalendar] components:components fromDate:self];
    NSDateComponents *comp2 = [[NSCalendar currentCalendar] components:components fromDate:[NSDate date]];    
    return ([comp1 year]<[comp2 year] || [comp1 month]<[comp2 month] || [comp1 day]<[comp2 day]);
}

- (NSString *)monthAndDayLocalizedString {
    return [self formattedDateWithDateFormat:@"ccc, LLL d"];
}

- (NSString *)longEventDateLocalizedString {
    return [self formattedDateWithDateFormat:@"ccc LLL d, hh:mm:ss a"];
}

- (NSString *)timeOfDayLocalizedString {
	return [self formattedDateWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

@end
