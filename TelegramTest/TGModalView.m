//
//  TGModalView.m
//  Telegram
//
//  Created by keepcoder on 08.05.15.
//  Copyright (c) 2015 keepcoder. All rights reserved.
//

#import "TGModalView.h"
#import "TGAllStickersTableView.h"
@interface TGModalView ()
@property (nonatomic,strong) TMView *containerView;
@property (nonatomic,strong) TMView *backgroundView;

@property (nonatomic,strong) TMView *animationContainerView;


@end

@implementation TGModalView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(instancetype)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
       [self initializeModalView];
    }
    
    return self;
}

-(void)enableCancelAndOkButton {
    weak();
    
    _ok = [[BTRButton alloc] initWithFrame:NSMakeRect(self.containerSize.width/2, 0, self.containerSize.width/2, 49)];
    _ok.autoresizingMask = NSViewWidthSizable;
    _ok.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    [_ok setTitleColor:LINK_COLOR forControlState:BTRControlStateNormal];
    [_ok setTitleFont:TGSystemFont(15) forControlState:BTRControlStateNormal];
    [_ok setTitle:NSLocalizedString(@"OK", nil) forControlState:BTRControlStateNormal];
    
    [_ok addBlock:^(BTRControlEvents events) {
        
        [weakSelf okAction];
        
    } forControlEvents:BTRControlEventMouseDownInside];
    
    
    [self addSubview:_ok];
    
    
    
    _cancel = [[BTRButton alloc] initWithFrame:NSMakeRect(0, 0, self.containerSize.width/2, 50)];
    _cancel.autoresizingMask = NSViewWidthSizable;
    _cancel.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    [_cancel setTitleColor:LINK_COLOR forControlState:BTRControlStateNormal];
    [_cancel setTitleFont:TGSystemFont(15) forControlState:BTRControlStateNormal];
    [_cancel setTitle:NSLocalizedString(@"Cancel", nil) forControlState:BTRControlStateNormal];
    
    [_cancel addBlock:^(BTRControlEvents events) {
        
        [weakSelf cancelAction];
        
        
    } forControlEvents:BTRControlEventMouseDownInside];
    
    [self addSubview:_cancel];
    
    
    TMView *separator = [[TMView alloc] initWithFrame:NSMakeRect(0, 49, self.containerSize.width, 1)];
    [separator setBackgroundColor:DIALOG_BORDER_COLOR];
    
    separator.autoresizingMask = NSViewWidthSizable;
    [self addSubview:separator];

}


-(void)okAction {
    
}

-(void)cancelAction {
    [self close:YES];
}

-(void)initializeModalView {
    
    self.wantsLayer = YES;
    
    self.layer.backgroundColor = [NSColor clearColor].CGColor;
    
    _backgroundView = [[TMView alloc] initWithFrame:self.bounds];
    
    self.autoresizingMask = _backgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    _backgroundView.wantsLayer = YES;
    
    _backgroundView.layer.backgroundColor = NSColorFromRGBWithAlpha(0x000000, 0.6).CGColor;
    
    _containerView = [[TMView alloc] initWithFrame:NSMakeRect(0, 0, 300, 300)];
    
//    _containerView.wantsLayer = YES;
//    _containerView.layer.cornerRadius = 4;
    
    _containerView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    
    [super addSubview:_backgroundView];
    
    
    
    _animationContainerView = [[TMView alloc] initWithFrame:_containerView.bounds];
    
    _animationContainerView.wantsLayer = YES;
    _animationContainerView.layer.cornerRadius = 4;
    _animationContainerView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    [_animationContainerView addSubview:_containerView];
    
    [super addSubview:_animationContainerView];

}

-(void)mouseDown:(NSEvent *)theEvent {
    
    
    if(![self mouse:[self convertPoint:[theEvent locationInWindow] fromView:nil] inRect:_animationContainerView.frame]) {
        [self close:YES];
    }
}

-(void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    
    [_backgroundView setFrameSize:newSize];
    
    [self setContainerFrameSize:self.containerSize];
    
}

-(void)show:(NSWindow *)window animated:(BOOL)animated {
    

    [self setFrameSize:window.frame.size];
    
    [self setContainerFrameSize:self.containerSize];
    
    [window.contentView addSubview:self];
    
    [window makeFirstResponder:self];
    
    self.layer.opacity = 1;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSWindowDidBecomeKeyNotification object:window];

    if(animated) {
        
        self.containerView.layer.opacity = 0;

        
        POPBasicAnimation *anim = [TMViewController popAnimationForProgress:self.containerView.layer.opacity to:1];
        anim.duration = 0.2;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.containerView.layer pop_addAnimation:anim forKey:@"fade"];
        
        weak();
        
        [anim setCompletionBlock:^(POPAnimation *pop, BOOL anim) {
            [weakSelf modalViewDidShow];
        }];
        
        
//        _animationContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
//        
//        _animationContainerView.layer.position = CGPointMake(roundf(NSWidth(self.frame) / 2), roundf(NSHeight(self.frame) / 2));
//        
//        POPBasicAnimation *sizeAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
//        
//        sizeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//        
//        sizeAnim.fromValue = [NSValue valueWithSize:NSMakeSize(0, 0)];
//        sizeAnim.toValue = [NSValue valueWithSize:self.containerSize];
//        sizeAnim.duration = 0.15;
//        
//        
//        
//        POPBasicAnimation *originContainerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
//        originContainerAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//        originContainerAnim.fromValue = [NSValue valueWithPoint:NSMakePoint(- roundf(NSWidth(_animationContainerView.frame)/2), - roundf(NSHeight(_animationContainerView.frame)/2))];
//        originContainerAnim.toValue = [NSValue valueWithPoint:NSMakePoint(0, 0)];
//        originContainerAnim.duration = 0.15;
        
        
        
        
    } else {
         [self modalViewDidShow];
    }

    
   
    
    
    int bp = 0;
    
}

/*
 [[[Telegram delegate] window] makeFirstResponder:self];
 
 //  self.layer.opacity = 0;
 
 //[_containerView.layer setFrameOrigin:];
 [self setContainerFrameSize:NSMakeSize(self.containerSize.width + 20, self.containerSize.height + 20)];
 
 [self setFrameSize:self.frame.size];
 
 POPBasicAnimation *anim = [TMViewController popAnimationForProgress:self.layer.opacity to:1];
 
 //  [self.layer pop_addAnimation:anim forKey:@"fade"];
 
 _animationContainerView.layer.backgroundColor = [NSColor redColor].CGColor;
 
 _containerView.layer.backgroundColor = [NSColor blueColor].CGColor;
 
 _animationContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
 
 _animationContainerView.layer.position = CGPointMake(roundf(NSWidth(self.frame) / 2), roundf(NSHeight(self.frame) / 2));
 
 POPBasicAnimation *sizeAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
 
 sizeAnim.fromValue = [NSValue valueWithSize:NSMakeSize(0, 0)];
 sizeAnim.toValue = [NSValue valueWithSize:self.containerSize];
 sizeAnim.duration = 0.2;
 [_animationContainerView.layer pop_addAnimation:sizeAnim forKey:@"size"];
 
 
 [sizeAnim setCompletionBlock:^(POPAnimation *anim, BOOL completed) {
 
 POPBasicAnimation *c = (POPBasicAnimation *) anim;
 c.removedOnCompletion = YES;
 c.completionBlock = nil;
 
 c.fromValue = [NSValue valueWithSize:_animationContainerView.layer.frame.size];
 c.toValue = [NSValue valueWithSize:NSMakeSize(self.containerSize.width - 20, self.containerSize.height - 20)];
 
 
 [_animationContainerView.layer pop_addAnimation:c forKey:@"size"];
 
 }];
 
 POPBasicAnimation *originContainerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
 
 originContainerAnim.fromValue = [NSValue valueWithPoint:NSMakePoint(- roundf(NSWidth(_animationContainerView.frame)/2), - roundf(NSHeight(_animationContainerView.frame)/2))];
 originContainerAnim.toValue = [NSValue valueWithPoint:NSMakePoint(-10, -10)];
 originContainerAnim.duration = 0.2;
 
 [_containerView.layer pop_addAnimation:originContainerAnim forKey:@"origin"];
 
 
 [originContainerAnim setCompletionBlock:^(POPAnimation *anim, BOOL completed) {
 
 
 
 POPBasicAnimation *c = (POPBasicAnimation *) anim;
 c.removedOnCompletion = YES;
 c.completionBlock = nil;
 
 c.fromValue = [NSValue valueWithPoint:_containerView.layer.frame.origin];
 c.toValue = [NSValue valueWithPoint:NSMakePoint(0, 0)];
 [_containerView.layer pop_addAnimation:c forKey:@"origin"];
 
 
 
 POPBasicAnimation *s = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
 s.removedOnCompletion = YES;
 s.fromValue = [NSValue valueWithSize:_containerView.layer.frame.size];
 s.toValue = [NSValue valueWithSize:NSMakeSize(self.containerSize.width - 20, self.containerSize.height - 20)];
 s.duration = 5;
 [_containerView.layer pop_addAnimation:s forKey:@"size"];
 
 [s setCompletionBlock:^(POPAnimation *anim, BOOL completed) {
 //  [self setContainerFrameSize:NSMakeSize(self.containerSize.width - 20, self.containerSize.height - 20)];
 }];
 
 }];
 
 */


-(void)close:(BOOL)animated {
    
    if(self.window) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NSWindowDidBecomeKeyNotification object:self.window];
        
        if(animated) {
            POPBasicAnimation *anim = [TMViewController popAnimationForProgress:self.layer.opacity to:0];
            
            weak();
            
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL success) {
                [weakSelf removeFromSuperview];
            }];
            
            [self.layer pop_addAnimation:anim forKey:@"fade"];
            
        } else {
            [self removeFromSuperview];
        }
        [self resignFirstResponder];
        
        [self modalViewDidHide];
    }
    
    
    
    
    
    
}

-(void)setOpaqueContent:(BOOL)opaqueContent {
    _opaqueContent = opaqueContent;
    _animationContainerView.layer.backgroundColor = self.containerView.layer.backgroundColor = _opaqueContent ? [NSColor clearColor].CGColor : [NSColor whiteColor].CGColor;
    _animationContainerView.layer.cornerRadius = self.containerView.layer.cornerRadius = _opaqueContent ? 0 : 4;
}

-(void)modalViewDidShow {
    [self setContainerFrameSize:self.containerSize];
}
-(void)modalViewDidHide {
    
}

-(BOOL)isShown {
    return self.window != nil;
}

-(void)mouseUp:(NSEvent *)theEvent {
    
}

-(void)scrollWheel:(NSEvent *)theEvent {
    
}

-(void)keyDown:(NSEvent *)theEvent {
    
}

-(void)keyUp:(NSEvent *)theEvent {
    if(theEvent.keyCode == 53) {
        [self close:YES];
    }
}

-(void)mouseMoved:(NSEvent *)theEvent {
    
}

-(void)mouseEntered:(NSEvent *)theEvent {
    
}


-(void)mouseExited:(NSEvent *)theEvent {
    
}

-(void)addSubview:(NSView *)aView {
    [_containerView addSubview:aView];
}

-(void)setContainerFrameSize:(NSSize)size {
    
    [_containerView setFrameSize:size];
    [_animationContainerView setFrameSize:size];
    
    float x = roundf((NSWidth(self.frame) - NSWidth(_animationContainerView.frame)) / 2);
    float y = roundf((NSHeight(self.frame) - NSHeight(_animationContainerView.frame) - 20) / 2);
    
    [_animationContainerView setFrameOrigin:NSMakePoint(x,y)];
    
    
    [_ok setFrame:NSMakeRect(self.containerSize.width/2, 0, self.containerSize.width/2, 49)];
    [_cancel setFrame:NSMakeRect(0, 0, self.containerSize.width/2, 50)];
}

-(NSSize)containerSize {
    return _containerView.frame.size;
}

@end
