//
//  WHSwitch.h
//  
//
//  Created by CWH on 2023/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHSwitch : UIControl

@property (nonatomic ,strong) UIColor *onTintColor;

@property (nonatomic ,strong) UIColor *thumbTintColor;

@property (nonatomic ,strong) UIColor *offTintColor;

@property(nonatomic,getter=isOn) BOOL on;

@property (nonatomic ,assign) CGFloat thumbMargin;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
