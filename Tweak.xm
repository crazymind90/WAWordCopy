// By @CrazyMind90

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#pragma GCC diagnostic ignored "-Wunused-function"
#pragma GCC diagnostic ignored "-Wunknown-pragmas"

#define rgbValue
#define UIColorFromHEX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface CMManager : NSObject
+(UITapGestureRecognizer *) InitTapGestureRecognizerInView:(UIView *)InView NumberOfTapsRequired:(NSUInteger)TapsRequired NumberOfTouchesRequired:(NSUInteger)TouchesRequired Target:(id)Target Actions:(SEL)Action;
+(UITextView *_Nullable) InitTextViewWithFrame:(CGRect)Frame BackgroundColor:(UIColor *_Nullable)BGColor TextColor:(UIColor *_Nullable)TextColor InView:(UIView *_Nullable)InView;
@end

@implementation CMManager

+(UITextView *_Nullable) InitTextViewWithFrame:(CGRect)Frame BackgroundColor:(UIColor *_Nullable)BGColor TextColor:(UIColor *_Nullable)TextColor InView:(UIView *_Nullable)InView {

    UITextView *TextV = [[UITextView alloc] initWithFrame:Frame];

    TextV.backgroundColor = BGColor;
    TextV.textColor = TextColor;

    [InView addSubview:TextV];

    return TextV;
}


+(UITapGestureRecognizer *) InitTapGestureRecognizerInView:(UIView *)InView NumberOfTapsRequired:(NSUInteger)TapsRequired NumberOfTouchesRequired:(NSUInteger)TouchesRequired Target:(id)Target Actions:(SEL)Action {

    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:Target action:Action];

    Tap.numberOfTapsRequired = TapsRequired;
    Tap.numberOfTouchesRequired = TouchesRequired;

    Tap.delegate = Target;

    [InView addGestureRecognizer:Tap];


    return Tap;

}

@end






@interface WAMessage : NSObject

@property NSString *textToSpeak;
@end

@interface WAChatCellData : NSObject

@property WAMessage *message;
@end

@interface WAMessageContainerView : UIView

@property WAChatCellData *cellData;
-(void) WAWordCopy;
@end

UITextView *TextView;

%hook WAMessageContainerView
-(void) layoutSubviews {

     %orig;
     
    [CMManager InitTapGestureRecognizerInView:self NumberOfTapsRequired:2 NumberOfTouchesRequired:1 Target:self Actions:@selector(WAWordCopy)];
}

%new
-(void) WAWordCopy {

 #pragma Gettin_Message_From_Tapped_Cell
 NSString *OriginalText = self.cellData.message.textToSpeak;


 if (OriginalText) {

 #pragma Drawing_TextView_On_Tapped_Cell
 TextView = [CMManager InitTextViewWithFrame:CGRectNull BackgroundColor:UIColorFromHEX(0x252525) TextColor:UIColor.whiteColor InView:self];

 TextView.editable = YES;
 TextView.layer.cornerRadius = 7;
 TextView.clipsToBounds = YES;
 TextView.text = OriginalText;
 TextView.font = [UIFont systemFontOfSize:15];

 [TextView setTranslatesAutoresizingMaskIntoConstraints:NO];

 [NSLayoutConstraint activateConstraints:@[

 [TextView.topAnchor constraintEqualToAnchor:self.topAnchor constant:5],
 [TextView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5],
 [TextView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5],
 [TextView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5],

 ]];

 }

}

%end


@interface WAChatViewController : UIViewController

@end

%hook WAChatViewController
-(void) viewDidLoad {
  %orig;
  [CMManager InitTapGestureRecognizerInView:self.view NumberOfTapsRequired:2 NumberOfTouchesRequired:1 Target:self Actions:@selector(Dismiss)];
}

%new
-(void) Dismiss {

  #pragma Dismissing_TextView
  [TextView setHidden:YES];
  [TextView removeFromSuperview];

}
%end
















//
