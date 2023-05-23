//
//  WHSwitch.m
//
//
//  Created by CWH on 2023/5/19.
//

#import "WHSwitch.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define kWKSwitchViewAnimateDuration 0.2

#define kWKSwitchViewAnimateOffsetX 7

@interface WHSwitch ()

@property (nonatomic ,strong) UIControl *containerView;

@property (nonatomic ,strong) UIView *onBgView;

@property (nonatomic ,strong) UIView *thumbBtn;

@property (nonatomic ,weak) id wh_Target;

@property (nonatomic ,assign) SEL wh_selector;

@end

@implementation WHSwitch

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _thumbMargin = 2.f;
        _thumbTintColor = UIColor.whiteColor;
        _onTintColor = UIColor.greenColor;
        _offTintColor = [[UIColor alloc] initWithWhite:0.9 alpha:1];
        
        [self addSubview:self.containerView];
        [self addSubview:self.onBgView];
        [self addSubview:self.thumbBtn];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerView.frame = self.bounds;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    self.onBgView.frame = self.bounds;
    if (self.thumbBtn.frame.size.width == 0) {
        [self setupThumbFrame];
    }
}

#pragma mark - Setup UI

#pragma mark - Public Method
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (controlEvents == UIControlEventValueChanged) {
        self.wh_Target = target;
        self.wh_selector = action;
    } else {
        [super addTarget:target action:action forControlEvents:controlEvents];
    }
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    if (animated) {
        _on = on;
        
        self.containerView.enabled = NO;
        [UIView animateWithDuration:kWKSwitchViewAnimateDuration animations:^{
            CGFloat length = CGRectGetHeight(self.bounds) - (self.thumbMargin * 2.f);
            CGFloat x = self.isOn ? CGRectGetWidth(self.bounds) - length - self.thumbMargin : self.thumbMargin;
            self.thumbBtn.frame = CGRectMake(x, self.thumbMargin, length, length);
            
            self.onBgView.alpha = self.isOn ? 1 : 0;
            
        } completion:^(BOOL finished) {
            self.containerView.enabled = YES;
        }];
    } else {
        self.on = on;
    }
}

#pragma mark - Private Method
- (void)setupThumbFrame {
    CGFloat length = CGRectGetHeight(self.bounds) - (self.thumbMargin * 2.f);
    CGFloat x = self.isOn ? CGRectGetWidth(self.bounds) - length - self.thumbMargin : self.thumbMargin;
    self.thumbBtn.frame = CGRectMake(x, _thumbMargin, length, length);
    self.thumbBtn.layer.cornerRadius = length / 2.f;
}

- (void)thumbBigger {
    [UIView animateWithDuration:kWKSwitchViewAnimateDuration animations:^{
        CGFloat length = CGRectGetHeight(self.bounds) - (self.thumbMargin * 2.f);
        CGRect frame = self.thumbBtn.frame;
        CGSize size = CGSizeMake(length + kWKSwitchViewAnimateOffsetX, length);
        CGFloat x = CGRectGetMinX(frame);
        x = self.isOn ? x - kWKSwitchViewAnimateOffsetX : x;
        frame.size = size;
        self.thumbBtn.frame = CGRectMake(x, CGRectGetMinY(frame), size.width, size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)sendTargetSelector {
    if ([self.wh_Target respondsToSelector:self.wh_selector]) {
        ((void (*)(void *, SEL, UIView *))objc_msgSend)((__bridge void *)(self.wh_Target), self.wh_selector ,self);
    }
}

#pragma mark - Target Action
- (void)touchAction:(UIButton *)btn {
    [self setOn:!self.on animated:YES];
    [self sendTargetSelector];
}

- (void)touchBegin:(UIButton *)btn {
    [self thumbBigger];
}

#pragma mark - -- Delegate --

#pragma mark - Setter
- (void)setOn:(BOOL)on {
    _on = on;
    [self setupThumbFrame];
}

- (void)setOnTintColor:(UIColor *)onTintColor {
    _onTintColor = onTintColor;
    self.onBgView.backgroundColor = self.onTintColor;
}

- (void)setOffTintColor:(UIColor *)offTintColor {
    _offTintColor = offTintColor;
    self.containerView.backgroundColor = self.offTintColor;
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor {
    _thumbTintColor = thumbTintColor;
    self.thumbBtn.backgroundColor = thumbTintColor;
}

#pragma mark - Getter

- (UIControl *)containerView {
    if (!_containerView) {
        _containerView = [[UIControl alloc] init];
        _containerView.backgroundColor = self.offTintColor;
        [_containerView addTarget:self action:@selector(touchBegin:) forControlEvents:UIControlEventTouchDown];
        [_containerView addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _containerView;
}

- (UIView *)onBgView {
    if (!_onBgView) {
        _onBgView = [[UIView alloc] init];
        _onBgView.backgroundColor = self.onTintColor;
        _onBgView.userInteractionEnabled = NO;
        _onBgView.alpha = 0.f;
    }
    return _onBgView;
}

- (UIView *)thumbBtn {
    if (!_thumbBtn) {
        _thumbBtn = [[UIView alloc] init];
        _thumbBtn.backgroundColor = self.thumbTintColor;
        _thumbBtn.userInteractionEnabled = NO;
    }
    return _thumbBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
