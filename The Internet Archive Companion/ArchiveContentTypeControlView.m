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
@property (nonatomic, strong) NSMutableArray *subTitles;

@property (nonatomic, strong) UILabel *filterLabel;
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
        self.subTitles = [NSMutableArray new];

        for (NSNumber *type in @[[NSNumber numberWithInteger:MediaTypeTexts], [NSNumber numberWithInteger:MediaTypeVideo], [NSNumber numberWithInteger:MediaTypeAudio], [NSNumber numberWithInteger:MediaTypeImage], [NSNumber numberWithInteger:MediaTypeEtree], [NSNumber numberWithInteger:MediaTypeCollection]]) {
            UIButton *button = [self createButtonForMediaTypeNumber:type];
            [self addSubview:button];
            [self.buttons addObject:button];

            [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];

            UILabel *subLabel = [self textTitleForMediaTypeNumber:type];
            [self addSubview:subLabel];
            [self.subTitles addObject:subLabel];
        }

        self.filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 12)];
        [self.filterLabel setFont:[UIFont systemFontOfSize:11]];
        [self.filterLabel setText:@"filter toggles"];
        [self.filterLabel setTextColor:[UIColor lightGrayColor]];
        [self.filterLabel setTextAlignment:NSTextAlignmentCenter];
//        [self addSubview:self.filterLabel];
        
        self.currentMediaType = MediaTypeNone;
        [self recolorAllButtons];
    }
    return self;
}

- (UILabel *)textTitleForMediaTypeNumber:(NSNumber *)mediaType
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.text = [MediaUtils stringFromMediaType:(MediaType)[mediaType integerValue]];
    [lab setFont:[UIFont systemFontOfSize:11]];
    [lab setTextColor:[UIColor lightGrayColor]];
    [lab setTextAlignment:NSTextAlignmentCenter];
    return lab;
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
    int count = 0;
    for(UIButton *button in self.buttons)
    {
        button.frame = CGRectMake(startx, 0, width, 34);
        startx += width;
//        button.layer.borderColor = [UIColor redColor].CGColor;
//        button.layer.borderWidth = 1.0;

        UILabel *lab = [self.subTitles objectAtIndex:count];
        CGRect fr = lab.frame;
        fr.origin.x = button.frame.origin.x;
        fr.origin.y = button.frame.size.height;
        fr.size.height = 12;
        fr.size.width   = button.frame.size.width;
        lab.frame = fr;
        lab.center = CGPointMake(button.center.x, lab.center.y);

        count ++;
    }
    
    self.filterLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 12);

    
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
