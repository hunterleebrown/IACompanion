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
        [self recolorAllButtons];
    }
    return self;
}


- (UIButton *)createButtonForMediaTypeNumber:(NSNumber *)mediaType
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];


    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[MediaUtils iconStringFromMediaType:(MediaType)[mediaType integerValue]] attributes:@{NSFontAttributeName : [UIFont fontWithName:ICONOCHIVE size:25], NSForegroundColorAttributeName : [MediaUtils colorFromMediaType:(MediaType)[mediaType integerValue]]}];
    [button setAttributedTitle:attString forState:UIControlStateNormal];

    NSAttributedString *attStringSelected = [[NSAttributedString alloc] initWithString:[MediaUtils iconStringFromMediaType:(MediaType)[mediaType integerValue]] attributes:@{NSFontAttributeName : [UIFont fontWithName:ICONOCHIVE size:30], NSForegroundColorAttributeName : [MediaUtils colorFromMediaType:(MediaType)[mediaType integerValue]]}];
    [button setAttributedTitle:attStringSelected forState:UIControlStateSelected];



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


    button.selected = !button.selected;
    NSLog(@"------> %@", [weakself selectedFilters]);
    self.selectButtonBlock([weakself selectedFilters]);

    [self allGreyButtons];

    if(![self IsAnyButtonSelected])
    {
        [self recolorAllButtons];
    }
}



- (void)allGreyButtons
{
    for(UIButton *button in self.buttons){
        if(!button.selected) {
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[MediaUtils iconStringFromMediaType:(MediaType)button.tag] attributes:@{NSFontAttributeName : [UIFont fontWithName:ICONOCHIVE size:25], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
            [button setAttributedTitle:attString forState:UIControlStateNormal];
        }
    }
    
}


- (void)recolorAllButtons
{
    for(UIButton *button in self.buttons)
    {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[MediaUtils iconStringFromMediaType:(MediaType)button.tag] attributes:@{NSFontAttributeName : [UIFont fontWithName:ICONOCHIVE size:25], NSForegroundColorAttributeName : [MediaUtils colorFromMediaType:(MediaType)button.tag]}];
        [button setAttributedTitle:attString forState:UIControlStateNormal];    }

}

- (BOOL)IsAnyButtonSelected
{

    for(UIButton *button in self.buttons)
    {
        if(button.selected)
        {
            return YES;
        }

    }
    return NO;
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
