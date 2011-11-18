/*
 * THMultiPartLabel.h v1.0.1 by Tom Heinan <http://tomheinan.com>
 * Released under a Creative Commons Attribution-ShareAlike license <http://creativecommons.org/licenses/by-sa/3.0/>
 * 
 * Much of the implementation code borrowed from Jason Miller's excellent StackOverflow response here:
 * <http://stackoverflow.com/questions/1417346/iphone-uilabel-containing-text-with-multiple-fonts-at-the-same-time/1532634#1532634>
 */

#import <Foundation/Foundation.h>

@interface THMultiPartLabel : UIView {
	UIView *containerView;
	NSMutableArray *labels;
	NSMutableArray *defaultFonts;
}

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) NSMutableArray *defaultFonts;

- (id)initWithOffsetX:(int)xVal Y:(int)yVal defaultFonts:(NSArray *)fonts;

- (void)updateText:(NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION;
- (void)updateOffsetX:(int)xVal Y:(int)yVal;
- (void)updateLayout;

@end
