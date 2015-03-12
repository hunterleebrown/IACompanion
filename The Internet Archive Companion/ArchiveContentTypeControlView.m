//
//  ArchiveContentTypeControlView.m
//  IA
//
//  Created by Hunter on 3/11/15.
//  Copyright (c) 2015 Hunter Lee Brown. All rights reserved.
//

#import "ArchiveContentTypeControlView.h"
#import "FontMapping.h"
#import "MediaUtils.h"

@interface ArchiveContentTypeControlView ()
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation ArchiveContentTypeControlView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {

        self.buttons = [NSMutableArray new];

        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [firstButton setTitle:@"ALL" forState:UIControlStateNormal];
        [firstButton.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
        [firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [firstButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [firstButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        [self addSubview:firstButton];
        [self.buttons addObject:firstButton];
        [firstButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [firstButton setSelected:YES];

        for (NSNumber *type in @[[NSNumber numberWithInteger:MediaTypeTexts], [NSNumber numberWithInteger:MediaTypeVideo], [NSNumber numberWithInteger:MediaTypeAudio], [NSNumber numberWithInteger:MediaTypeImage], [NSNumber numberWithInteger:MediaTypeEtree], [NSNumber numberWithInteger:MediaTypeCollection]]) {
            UIButton *button = [self createButtonForMediaTypeNumber:type];
            [self addSubview:button];
            [self.buttons addObject:button];
            [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];

        }

//        UIButton *firstButton = (UIButton *)[self.buttons objectAtIndex:0];
//        firstButton.selected = YES;
//        firstButton.backgroundColor = [MediaUtils colorFromMediaType:MediaTypeTexts];


    }
    return self;
}


- (UIButton *)createButtonForMediaTypeNumber:(NSNumber *)mediaType
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[MediaUtils iconStringFromMediaType:[mediaType integerValue]] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:ICONOCHIVE size:25]];
    [button setTitleColor:[MediaUtils colorFromMediaType:[mediaType integerValue]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];

    return button;

}

- (void)layoutSubviews
{

    NSLog(NSStringFromCGRect(self.bounds));


    CGFloat width = roundf((self.bounds.size.width - 20 )/ self.buttons.count);
    CGFloat startx = 10;
    for(UIButton *button in self.buttons)
    {
        button.frame = CGRectMake(startx, 10, width, 34);
//        button.layer.borderColor = [UIColor redColor].CGColor;
//        button.layer.borderWidth = 1.0;
        startx += width;
    }


}

- (void) didSelectButton:(id)sender
{
    [self unselectAll];

    UIButton *button = sender;
    button.selected = YES;

}

- (void)unselectAll
{
    for(UIButton *button in self.buttons)
    {
        button.selected = NO;
    }

}


//- (NSString *)filterQueryParam
//{
//
//    NSInteger selectedSegment = [self selectedButtonIndex];
//    // audio, video, text, image
//
//    NSString *extraSearchParam = @"";
//
//    switch (selectedSegment) {
//        case 0:
//
//            break;
//        case 1:
//            extraSearchParam = @"+AND+mediatype:audio";
//            break;
//        case 2:
//            extraSearchParam = @"+AND+mediatype:movies";
//            break;
//        case 3:
//            extraSearchParam = @"+AND+mediatype:texts";
//            break;
//        case 4:
//            extraSearchParam = @"+AND+mediatype:image";
//            break;
//        default:
//            break;
//    }
//
//    return extraSearchParam;
//    
//}


@end
