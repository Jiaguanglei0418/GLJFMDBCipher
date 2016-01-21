
/**
 *  设置View 的frame属性
 *
 *  @ 2015年10月28日 
 */

#import <UIKit/UIKit.h>

@interface UIView (Extension)

 /**  加载xib文件 ***/
+ (id)loadFromNib;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;



- (void)setFrameCenterWithSuperView:(UIView *)superView size:(CGSize)size;
- (void)setFrameInBottomCenterWithSuperView:(UIView *)superView size:(CGSize)size;

- (void)addCornerWithCornerRadius:(CGFloat)cornerRadius;



@end
