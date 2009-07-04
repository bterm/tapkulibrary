//
//  FSIndicatorCell.m
//  TapkuLibrary
//
//  Created by Devin Ross on 7/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FSIndicatorCell.h"




@implementation FSIndicatorCell
@synthesize text = _text, count = _count;



static UIFont *textFont = nil;
static UIFont *indicatorFont = nil;
static UIColor *indicatorColor = nil;
static UIColor *indicatorBackgroundColor = nil;

+ (void)initialize
{
	if(self == [FSIndicatorCell class])
	{
		textFont = [[UIFont boldSystemFontOfSize:18] retain];
		indicatorFont = [[UIFont boldSystemFontOfSize:16] retain];
		indicatorColor = [[UIColor whiteColor] retain];
		indicatorBackgroundColor = [[UIColor colorWithRed:140/255.0 green:153/255.0 blue:180/255.0 alpha:1.0] retain];

	}
}

- (void)dealloc
{
	[textFont release];
	[indicatorFont release];
	[indicatorBackgroundColor release];
    [super dealloc];
}

// the reason I don't synthesize setters for 'firstText' and 'lastText' is because I need to 
// call -setNeedsDisplay when they change

- (void) setText:(NSString*)s{
	[_text release];
	_text = [s copy];
	[self setNeedsDisplay];
}

- (void) setCount:(int)s{
	if(s==_count) return;
	_count = s;
	_countStr = [[NSString stringWithFormat:@"%d",s] retain];
	[self setNeedsDisplay];
}


- (void)drawContentView:(CGRect)r{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = [UIColor whiteColor];
	UIColor *textColor = [UIColor blackColor];
	
	if(self.selected || self.highlighted){
		backgroundColor = [UIColor clearColor];
		textColor = [UIColor whiteColor];
	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	
	CGRect rect = CGRectInset(r, 12, 12);
	rect.size.width -= 45;
	
	if(self.editing){
		rect.origin.x += 30;
	}
	
	
	[textColor set];
	
	[_text drawInRect:rect withFont:textFont lineBreakMode:UILineBreakModeTailTruncation];
	
	if(_count > 0 && !self.editing){
		
		
		[indicatorBackgroundColor set];
		CGRect rrect = CGRectMake(rect.size.width+ rect.origin.x, 12, 30,20);
		CGFloat radius = 10.0;
		CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
		CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
		CGContextMoveToPoint(context, minx, midy);
		CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
		CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
		CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
		CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
		CGContextClosePath(context);
		CGContextDrawPath(context, kCGPathFill);
		
		
		[indicatorColor set];
		//[_countStr drawInRect:rrect withFont:indicatorFont];
		[_countStr drawInRect:rrect withFont:indicatorFont lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
					   
					   
	}
	
	
}

- (void)willTransitionToState:(UITableViewCellStateMask)state{
	[super willTransitionToState:state];
	[self setNeedsDisplay];
}

@end




