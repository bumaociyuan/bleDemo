//
//  UPLabel.m
//  MPOS
//
//  Created by liwang on 14-7-22.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "UPLabel.h"

@implementation UPLabel
@synthesize verticalAlignment;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        // Initialization code
        self.verticalAlignment = UPVerticalAlignmentMiddle;
        self.font = [UIFont systemFontOfSize:13.0f];
    }

    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];

    switch (self.verticalAlignment) {
        case UPVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;

        case UPVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;

        case UPVerticalAlignmentMiddle:
        // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
