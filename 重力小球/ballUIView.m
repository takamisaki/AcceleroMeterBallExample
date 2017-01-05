#import "ballUIView.h"
#import <CoreMotion/CoreMotion.h>

#define SCREEN_W [UIScreen mainScreen].bounds.size.width   //屏幕宽
#define SCREEM_H [UIScreen mainScreen].bounds.size.height  //屏幕高
#define BALL_D 40                                          //球直径


@interface ballUIView ()

@property (nonatomic, strong) UIView          *ball;        //运动的球
@property (nonatomic, strong) CMMotionManager *manager;
@property (nonatomic, assign) float           accelerateX;  //获取的加速度的 x 值
@property (nonatomic, assign) float           accelerateY;  //获取的加速度的 y 值

@end


@implementation ballUIView


//重写 init, 设置 frame, 如果是横屏需要手机设置才能运行. 如果竖屏就添加球, 开始运动
- (instancetype) init {
    
    if (self = [super init]) {
        self = [[ballUIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

            [self addBall];
            [self startRunning];
    }
    return self;
}


//添加球, 通过把正方形的 View 的圆角半径设置成边长的一半,让它变成圆形
- (void) addBall {

    self.ball = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W/2 - BALL_D/2, //球初始在画面中心
                                                         SCREEM_H/2 - BALL_D/2,
                                                         BALL_D, BALL_D)];
    self.ball.backgroundColor    = [UIColor redColor];
    self.ball.layer.cornerRadius = BALL_D / 2;
    
    [self addSubview:self.ball];
}


//启动加速度传感器, 回调 更新小球位置的方法
- (void) startRunning {
    
    self.manager = [CMMotionManager new];
    
    self.manager.accelerometerUpdateInterval = 0.01f;
    
    if (self.manager.accelerometerAvailable) {
    
        [self.manager startAccelerometerUpdatesToQueue: [NSOperationQueue currentQueue]
                                           withHandler: ^(CMAccelerometerData * accelerometerData,
                                                         NSError *  error)
        {
            [self updateBallPositionBasedOn: accelerometerData];
        }];
    }
}


#pragma mark 更新小球位置
/*  逻辑:
    1. 获取 x轴 和 y轴 上的加速度累加值, 转换为要移动到的小球的center的位置
    2. 判断是否小球的边缘碰壁, 设置反弹速度
    3. 更新小球的 center 值, 实现小球的运动
 */
- (void) updateBallPositionBasedOn: (CMAccelerometerData*) accelerometerData {
    
    self.accelerateX += accelerometerData.acceleration.x;
    self.accelerateY += accelerometerData.acceleration.y;
    
    CGFloat newX = self.ball.center.x + self.accelerateX;
    CGFloat newY = self.ball.center.y - self.accelerateY;
    
    if (newX < BALL_D/2 ) {         //判断是否小球中心离边缘小于小球的半径
        newX = BALL_D/2;            //如果小于, 就把小球真心移出来
        self.accelerateX *= -0.5;   //并赋予反方向的速度系数. (以下判断都同理)
    
    } else
    if (newX > SCREEN_W - BALL_D/2){
        newX = SCREEN_W - BALL_D/2;
        self.accelerateX *= -0.5;
    }
    
    
    if (newY < BALL_D/2 ) {
        newY = BALL_D/2;
        self.accelerateY *= -0.5;
    
    } else
    if (newY > SCREEM_H - BALL_D/2) {
        newY = SCREEM_H - BALL_D/2;
        self.accelerateY *= -0.5;
    }
    
    self.ball.center = CGPointMake(newX, newY);
}


//停止运动
- (void) stopRunning {
    
    if (self.manager.accelerometerActive) {
       [self.manager stopAccelerometerUpdates];
    }
}

@end
