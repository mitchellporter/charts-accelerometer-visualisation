//
//  ViewController.m
//  ChartsAccelerometer
//
//  Created by Colin Eberhardt on 04/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController () <SChartDatasource>

@end

@implementation ViewController
{
    ShinobiChart* _chart;
    NSMutableArray* _data[3];
    CMMotionManager* _motion;
    double _currentX;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add a chart with a margin
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, 40.0f, 40.0f)];
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
    
    // add the axes
    _chart.yAxis = [self createAxis];
    _chart.xAxis = [self createAxis];
    _chart.yAxis.defaultRange = [[SChartNumberRange alloc] initWithMinimum:@-2 andMaximum:@2];

    // initialise the chart data
    _currentX=0;
    for(int i=0;i<3;i++) {
        _data[i] = [NSMutableArray new];
    }
    
    // start reaing the accelerometer
    _motion = [CMMotionManager new];
    [_motion startAccelerometerUpdatesToQueue:[NSOperationQueue new]
                                  withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(),^{
                                          [self addData:accelerometerData];
                                      });
                                  }];
    
}

- (void)addData:(CMAccelerometerData*) accelerometerData {
    
    for (int i=0; i<3; i++) {
        
        // create a new datapoint
        SChartDataPoint* pt = [SChartDataPoint new];
        pt.xValue = @(_currentX);
        
        if (i==0) {
            pt.yValue = @(accelerometerData.acceleration.x);
        } else if (i==1) {
            pt.yValue = @(accelerometerData.acceleration.y);
        } else {
            pt.yValue = @(accelerometerData.acceleration.z);
        }
        
        // add to the series
        [_data[i] addObject:pt];
        [_chart appendNumberOfDataPoints:1 toEndOfSeriesAtIndex:i];
        
        if (_data[i].count > 500) {
            // when we hit 500, remove the first point in the series
            [_data[i] removeObjectsInRange:NSMakeRange(0, 1)];
            [_chart removeNumberOfDataPoints:1 fromStartOfSeriesAtIndex:i];
        }
    }
    _currentX+=1.0;
    
    
    [_chart redrawChart];
    
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - SChartDatasource implementation methods

- (SChartAxis*) createAxis {
    SChartNumberAxis* axis = [[SChartNumberAxis alloc] init];
    return axis;
}

- (int)numberOfSeriesInSChart:(ShinobiChart*)chart
{
    return 3;
}


-(int)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex {
    return _data[seriesIndex].count;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(int)index {
    return [[SChartLineSeries alloc] init];
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex {
    
    return _data[seriesIndex][dataIndex];
}


@end
