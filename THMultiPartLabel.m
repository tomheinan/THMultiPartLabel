/*
 * THMultiPartLabel.m v1.0.1 by Tom Heinan <http://tomheinan.com>
 * Released under a Creative Commons Attribution-ShareAlike license <http://creativecommons.org/licenses/by-sa/3.0/>
 * 
 * Much of the implementation code borrowed from Jason Miller's excellent StackOverflow response here:
 * <http://stackoverflow.com/questions/1417346/iphone-uilabel-containing-text-with-multiple-fonts-at-the-same-time/1532634#1532634>
 */

#import "THMultiPartLabel.h"

@implementation THMultiPartLabel

@synthesize containerView, labels, defaultFonts;

- (id)initWithOffsetX:(int)xVal Y:(int)yVal defaultFonts:(NSArray *)fonts
{
	if (self = [super init]) {
		self.containerView = [[UIView alloc] initWithFrame:CGRectMake(xVal, yVal, self.frame.size.width, self.frame.size.height)];
		[self addSubview:self.containerView];
		
		int numLabels = [fonts count];
		self.labels = [NSMutableArray arrayWithCapacity:numLabels];
		self.defaultFonts = [NSMutableArray arrayWithArray:fonts];
		
		for (int i = 0; i < numLabels; i++) {
			UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.font = [defaultFonts objectAtIndex:i];
			[self.containerView addSubview:label];
			[self.labels addObject:label];
		}
	}
	
	return self;
}

- (void)updateText:(NSString *)firstString, ...
{
	va_list args;
	va_start(args, firstString);
	int i = 0;
	for (NSString *arg = firstString; arg != nil; arg = va_arg(args, NSString*))
    {
        if (i >= [self.labels count]) {
			[NSException raise:@"IndexMismatch" format:@"%@", @"The number of strings supplied to updateText did not match the number of labels owned by the associated THMultiPartLabel instance."];
			return;
		} else {
			UILabel *label = [self.labels objectAtIndex:i];
			label.text = arg;
			i++;
		}
    }
	va_end(args);
	
	[self updateLayout];
}

- (void)updateOffsetX:(int)xVal Y:(int)yVal
{
	[containerView removeFromSuperview];
	self.containerView = nil;
	
	self.containerView = [[UIView alloc] initWithFrame:CGRectMake(xVal, yVal, self.frame.size.width, self.frame.size.height)];
	[self addSubview:self.containerView];
	self.labels = [NSMutableArray array];
	
	int numLabels = [self.labels count];
	for (int i = 0; i < numLabels; i++) {
		UILabel *label = [self.labels objectAtIndex:i];
		[self.containerView addSubview:label];
	}
	
	[self updateLayout];
}

- (void)updateLayout
{
	int xVal = 0;
	
	// TODO when it is time to support different sized fonts, need to adjust each y value to line up baselines
	
	for (UILabel *label in self.labels) {
		CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:label.lineBreakMode];
		CGRect frame = CGRectMake(xVal, 0, size.width, size.height);
		label.frame = frame;
		
		xVal += size.width;
	}
}

- (void)dealloc {
	self.labels = nil;
	self.containerView = nil;
	self.defaultFonts = nil;
}

@end
