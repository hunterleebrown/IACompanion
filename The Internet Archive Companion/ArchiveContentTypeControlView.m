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

        for (NSNumber *type in @[[NSNumber numberWithInteger:MediaTypeTexts], [NSNumber numberWithInteger:MediaTypeVideo], [NSNumber numberWithInteger:MediaTypeAudio], [NSNumber numberWithInteger:MediaTypeImage], [NSNumber numberWithInteger:MediaTypeEtree], [NSNumber numberWithInteger:MediaTypeCollection]]) {
            UIButton *button = [self createButtonForMediaTypeNumber:type];
            [self addSubview:button];
            [self.buttons addObject:button];
            [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        }



    }
    return self;
}


- (UIButton *)createButtonForMediaTypeNumber:(NSNumber *)mediaType
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[MediaUtils iconStringFromMediaType:(MediaType)[mediaType integerValue]] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:ICONOCHIVE size:25]];
    [button setTitleColor:[MediaUtils colorFromMediaType:(MediaType)[mediaType integerValue]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setTag:[mediaType integerValue]];
    return button;

}

- (void)layoutSubviews
{
    CGFloat width = roundf((self.bounds.size.width - 20 )/ self.buttons.count);
    CGFloat startx = 10;
    for(UIButton *button in self.buttons)
    {
        button.frame = CGRectMake(startx, 10, width, 34);
        startx += width;
    }

}

- (void) didSelectButton:(id)sender
{
    UIButton *button = sender;

    NSLog(@"------------> tag: %i", (MediaType)button.tag);
    NSLog(@"-------> selected: %@", button.selected ? @"SELECTED" : @"NOT SELECTED");

    ArchiveContentTypeControlView __weak *weakself = self;

    if(button.selected)
    {
        self.selectButtonBlock([weakself filterQueryParam:MediaTypeNone]);
        [self unselectAll];

    }
    else
    {
        self.selectButtonBlock([weakself filterQueryParam:(MediaType)button.tag]);
        [self allGreyButtons];
        [button setTitleColor:[MediaUtils colorFromMediaType:(MediaType)button.tag] forState:UIControlStateNormal];
        button.selected = !button.selected;

    }



}



- (void)allGreyButtons
{
    for(UIButton *button in self.buttons)
    {
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
}

- (void)unselectAll
{
    for(UIButton *button in self.buttons)
    {
        button.selected = NO;
        [button setTitleColor:[MediaUtils colorFromMediaType:(MediaType)button.tag] forState:UIControlStateNormal];
    }

}

- (MediaType)selectedMediaType
{
    for(UIButton *button in self.buttons)
    {
        if (button.selected) {
            return button.tag;
        }
    }

    return MediaTypeNone;
}


- (NSString *)filterQueryParam:(MediaType)type
{

    NSString *extraSearchParam = @"";

    switch (type) {
        case MediaTypeNone:
            break;
        case MediaTypeAudio:
            extraSearchParam = @"+AND+mediatype:audio";
            break;
        case MediaTypeEtree:
            extraSearchParam = @"+AND+mediatype:etree";
            break;
        case MediaTypeVideo:
            extraSearchParam = @"+AND+mediatype:movies";
            break;
        case MediaTypeTexts:
            extraSearchParam = @"+AND+mediatype:texts";
            break;
        case MediaTypeImage:
            extraSearchParam = @"+AND+mediatype:image";
            break;
        case MediaTypeCollection:
            extraSearchParam = @"+AND+mediatype:collection";
            break;
        default:
            break;
    }

    return extraSearchParam;
    
}


@end
