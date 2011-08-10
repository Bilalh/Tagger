//
//  PSDDFormatter.h
//

#import "DDLog.h"

@interface PSDDFormatter : NSObject <DDLogFormatter> {
  NSDateFormatter *dateFormatter;
}

@end
