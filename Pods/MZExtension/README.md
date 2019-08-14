# MZExtension
A extension for OC

##
自定义控件（Extends）

###
1、MZBannerView（广告轮播）

###
2、MZCircleProgress（圆形倒计时）

###
3、MZMarqueeLabel（滚动字符串）

###
4、MZMobileField（手机号码344格式）

###
5、MZTableView（横向tableView）

###
6、MZTextField（textField字符串长度限制）

###
7、MZTextView（textView字符串长度限制和placeholder设置）

###
8、MZWaveView（双波浪试图）

###
9、MZImageBrowsing（图片浏览器）

###
10、MZAlertController（半透明控制器，类似UIAlertController功能）

###
11、MZDrawBoardView（CAShapeLayer实现画板功能,可在画板上写字绘画）

##
自定义类别

###
1、NSDictionary+MZTool

1. 从字典中取出一个字典
-  -(NSDictionary *)dictionaryForKey:(NSString *)key;
2. 从字典中取出一个数组
-  -(NSArray *)arrayForKey:(NSString *)key;
3. 从字典中取出一个字符串
-  -(NSString *)stringForKey:(NSString *)key;
4. 从字典中取出一个布尔值
-  -(BOOL)boolForKey:(NSString *)key;
5. 从字典中取出一个整型数字
-  -(NSInteger)intForKey:(NSString *)key;
6. 从字典中取出一个双精度型数字
-  -(double)doubleForKey:(NSString *)key;

2、UIImage+MZTool

1. 根据颜色生成图片
- +(UIImage *)getImageWithColor:(UIColor *)color;
2. 根据字符串和二维码图片大小来生成二维码图片
- +(UIImage *)createBarCodeImageWithString:(NSString *)string size:(CGFloat)size;
3. 根据颜色的渐变色获取图片
- +(UIImage *)createImageWithFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
4. base64字符串转图片
- +(UIImage *)stringToImage:(NSString *)base64String;
5. 图片转base64字符串
- -(NSString *)imageToBase64String;
6. 截取view成图片
- +(UIImage *)clipsImage:(UIView *)view;
7. 对图片进行剪切，获取指定范围的图片
- +(UIImage *)clipsImage:(UIImage *)image frame:(CGRect)frame;
8. 新生成指定大小图片
- +(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;
9. 生成圆形图片
- +(UIImage *)cutCircleImage:(UIImage *)image;
10. 生成部分圆角图片
- +(UIImage *)cutPartCircleImage:(UIImage *)image corners:(UIRectCorner)corners radii:(CGSize)radii;

3、UIView+MZTool

1. 设置试图背景颜色的渐变色
- -(void)setupGradientColorWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
2. 给view添加点击事件
- -(void)addTapGestureRecognizerWithTarget:(id)target selector:(SEL)selector;
3. 根据一个VC上的view得到该VC
- -(UIViewController *)getVC;
4. 设置试图圆角
- -(void)setRadius:(CGFloat)radius;
5. 设置部分圆角
- -(void)setRoundedCorners:(UIRectCorner)corners radii:(CGSize)radii;

4、NSObject+MZTool

1. 获取当前显示的ViewController
- +(UIViewController *)currentViewController;
2. 获取屏幕窗口
- +(UIView *)getWindowView;
3. 获取手机当前连接的SSID（iOS12后要开启capabilities中的Access WiFi Information）
- +(NSString *)SSID;
4. 获取app版本号
- +(NSString *)getAppVersion;
5. 获取app Build
- +(NSString *)getAppBuild;
6. 获取app名称
- +(NSString *)getAppName;
7. 获取app BundleID
- +(NSString *)getAppBundleIdentifier;
8. 获取app Icon
- +(UIImage *)getAppIcon;

5、NSString+MZTool

1. 字符串MD5加密
- -(NSString *)MD5;
2. 普通字符串转换成十六进制字符串
- +(NSString *)hexStringFromString:(NSString *)string;
3. 十六进制字符串转换成普通字符串
- +(NSString *)stringFromHexString:(NSString *)hexString;
4. data转16进制字符串
- +(NSString *)dataToHexString:(NSData *)data;
5. 转为本地大端模式 返回Unsigned类型的数据
- +(unsigned short)unsignedDataTointWithData:(NSData *)data Location:(NSInteger)location Offset:(NSInteger)offset;

6、UIViewController+MZAlert

1. 系统提示框（确认按钮在左，取消按钮在右）
- -(void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirm:(void(^)(void))confirm cancel:(void(^)(void))cancel;
2. 系统提示款（确认按钮在右，取消按钮在左）
- -(void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle confirm:(void(^)(void))confirm cancel:(void(^)(void))cancel;
3. 系统提示款（只有一个按钮）
- -(void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirm:(void (^)(void))confirm;
4. 系统提示框（自定义标题和内容）
- -(void)showAlertWithAttributedTitle:(NSAttributedString *)attributedTitle attributedMessage:(NSAttributedString *)attributedMessage confirmTitle:(NSString *)confirmTitle confirmStyle:(UIAlertActionStyle)confirmStyle cancelTitle:(NSString *)cancelTitle cancelStyle:(UIAlertActionStyle)cancelStyle confirm:(void(^)(void))confirm cancel:(void(^)(void))cancel;
5. 系统提示框（自定义标题和内容以及按钮标题颜色）
- -(void)showAlertWithAttributedTitle:(NSAttributedString *)attributedTitle attributedMessage:(NSAttributedString *)attributedMessage confirmTitle:(NSString *)confirmTitle confirmColor:(UIColor *)confirmColor cancelTitle:(NSString *)cancelTitle cancelColor:(UIColor *)cancelColor confirm:(void(^)(void))confirm cancel:(void(^)(void))cancel;
6. 系统操作框
- -(void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)actionTitles cancelTitle:(NSString *)cancelTitle cancelColor:(UIColor *)cancelColor callback:(void(^)(NSString *actionTitle))callback;
7. 系统操作框（自定义标题和内容以及按钮标题颜色）
- -(void)showActionSheetWithAttributedTitle:(NSAttributedString *)attributedTitle attributedMessage:(NSAttributedString *)attributedMessage actionTitles:(NSArray<NSString *> *)actionTitles actionColors:(NSArray<UIColor *> *)actionColors cancelTitle:(NSString *)cancelTitle cancelColor:(UIColor *)cancelColor callback:(void(^)(NSString *actionTitle))callback;

7、NSObject+MZDate

1. 时间转字符串
- +(NSString *)dateToStringWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat;
2. 字符串转时间
- +(NSDate *)stringToDateWithString:(NSString *)string dateFormat:(NSString *)dateFormat;
3. 间戳转字符串
- +(NSString *)timeIntervalToStringWithTimeInterval:(NSTimeInterval)timeInterval dateFormat:(NSString *)dateFormat;
4. 字符串转时间戳
- +(NSTimeInterval)stringToTimeIntervalWithString:(NSString *)string dateFormat:(NSString *)dateFormat;
5. 时间戳转特殊字符串（如果是今明两天,会将月日转换成“今天”或“明天”）
- +(NSString *)specialTimeIntervalToStringWithTimeInterval:(NSTimeInterval)timeInterval dateFormat:(NSString *)dateFormat;
6. 获取当前时间戳
- +(NSTimeInterval)getNowTimeInterval;

8、UIButton+MZTool

1. 设置不同状态下的背景颜色
- -(void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
2. 添加点击事件
- -(void)setClickedBlock:(void(^)(UIButton *sender))clickedBlock;

9、UIButton+MZTouch

1. 通过eventTimeInterval来设置UIButton点击间隔

10、NSArray+MZTool

1. 获取数组中的最大值数组
- -(void)caculateMaxArray:(void(^)(NSArray *maxArray,NSInteger startIndex,NSInteger endIndex))callback;

11、UIColor+MZTool

1. 获取图片上某个点的颜色
- +(UIColor *)colorAtPixel:(CGPoint)point withImage:(UIImage *)image;
2. 根据16进制字符串获取颜色
- +(UIColor *)colorWithHexString:(NSString *)hexString;

12、UIView+MZFrame

- @property (nonatomic, assign) CGFloat mz_x;
- @property (nonatomic, assign) CGFloat mz_y;
- @property (nonatomic, assign) CGFloat mz_width;
- @property (nonatomic, assign) CGFloat mz_height;
- @property (nonatomic, assign) CGFloat mz_centerX;
- @property (nonatomic, assign) CGFloat mz_centerY;
