//
//  UPLabel.h
//  MPOS
//
//  Created by liwang on 14-7-22.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    UPVerticalAlignmentTop = 0, // default
    UPVerticalAlignmentMiddle,
    UPVerticalAlignmentBottom,
} UPVerticalAlignment;

@interface UPLabel : UILabel

@property (nonatomic) UPVerticalAlignment verticalAlignment;

@end
