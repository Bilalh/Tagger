//
//  PSDDFormatter.m
//

#import "PSDDFormatter.h"


@implementation PSDDFormatter

- (id)init {
  if((self = [super init]))
  {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
  }
  return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
  NSString *logLevel;
  switch (logMessage->logFlag) {
    case LOG_FLAG_ERROR : logLevel = @"Error: "; break;
    case LOG_FLAG_WARN  : logLevel = @"Warning: "; break;
    case LOG_FLAG_INFO  : logLevel = @""; break;
    default             : logLevel = @"V"; break;
  }
  
  NSString *dateAndTime = [dateFormatter stringFromDate:(logMessage->timestamp)];
  NSString *logMsg = logMessage->logMsg;
  
  return [NSString stringWithFormat:@"%@%@(%@) [%@ %@/%d] %@", logLevel, dateAndTime, [logMessage threadID], [logMessage fileName], [logMessage methodName], logMessage->lineNumber, logMsg];  
}

@end
