//
//  CustomButton.m
//  Madar
//
//  Created by Damian on 7/28/14.


#import "CustomButton.h"

@implementation CustomButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        //self.titleLabel.font = [UIFont fontWithName:@"Myriad Pro" size:14.0f];
    }
    return self;
}

- (void)status {
    if (self.isSelected) {
        [self setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    }
    else {
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
