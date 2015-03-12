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

        self.currentMediaType = MediaTypeNone;

    }
    return self;
}


- (UIButton *)createButtonForMediaTypeNumber:(NSNumber *)mediaType
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[MediaUtils iconStringFromMediaType:(MediaType)[mediaType integerValue]] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:ICONOCHIVE size:25]];

//    [button setTitleColor:[MediaUtils colorFromMediaType:(MediaType)[mediaType integerValue]] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];

    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[MediaUtils colorFromMediaType:(MediaType)[mediaType integerValue]] forState:UIControlStateSelected];


    [button setTag:[mediaType integerValue]];
    return button;

}

- (void)layoutSubviews
{
    CGFloat width = roundf((self.bounds.size.width - 20 )/ self.buttons.count);
    CGFloat startx = 10;
    for(UIButton *button in self.buttons)
    {
        button.frame = CGRectMake(startx, 0, width, 34);
        startx += width;
    }

}

- (void) didSelectButton:(id)sender
{
    UIButton *button = sender;

    NSLog(@"------------> tag: %i", (MediaType)button.tag);
    NSLog(@"-------> selected: %@", button.selected ? @"SELECTED" : @"NOT SELECTED");

    ArchiveContentTypeControlView __weak *weakself = self;

//    if(button.selected)
//    {
//        self.selectButtonBlock([weakself filterQueryParam:MediaTypeNone]);
//        [self unselectAll];
//        self.currentMediaType = MediaTypeNone;
//
//    }
//    else
//    {
//        self.selectButtonBlock([weakself filterQueryParam:(MediaType)button.tag]);
//        self.currentMediaType = (MediaType)button.tag;
//        [self allGreyButtons];
//        [button setTitleColor:[MediaUtils colorFromMediaType:(MediaType)button.tag] forState:UIControlStateNormal];
//        button.selected = !button.selected;
//
//    }

    button.selected = !button.selected;
    NSLog(@"------> %@", [weakself selectedFilters]);
    self.selectButtonBlock([weakself selectedFilters]);
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


- (NSString *)selectedFilters
{
    NSMutableString *filter = [[NSMutableString alloc] initWithString:@""];
    int count = 0;
    for (UIButton *button in self.buttons) {
        if(button.selected){
            [filter appendString:[NSString stringWithFormat:@"%@%@",count == 0 ? @"+AND+(" : @"+OR+", [self filterQueryParam:(MediaType)button.tag]]];
            count ++;
        }

    }

    return [NSString stringWithFormat:@"%@%@", filter, filter.length == 0 ? @"" : @")"];
}


- (NSString *)filterQueryParam:(MediaType)type
{

    switch (type) {
        case MediaTypeNone:
            return @"";
        case MediaTypeAudio:
            return @"mediatype:audio";
        case MediaTypeEtree:
            return @"mediatype:etree";
        case MediaTypeVideo:
            return @"mediatype:movies";
        case MediaTypeTexts:
            return @"mediatype:texts";
        case MediaTypeImage:
            return @"mediatype:image";
        case MediaTypeCollection:
            return @"mediatype:collection";
        default:
            return @"";
    }

}


@end
