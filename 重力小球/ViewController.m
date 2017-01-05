#import "ViewController.h"
#import "ballUIView.h"

@interface ViewController ()

@property (nonatomic, strong) ballUIView *ballView; //显示小球运动的 UIView 实例

@end



@implementation ViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];

    self.ballView = [[ballUIView alloc] init];
    
    [self.view addSubview: self.ballView];
}


//调用停止小球运动的方法
- (void) viewDidDisappear: (BOOL)animated {
    
    [self.ballView stopRunning];
}

@end
