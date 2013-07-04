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
    NSMutableArray* _data;
    CMMotionManager* _motion;
    double _currentX;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, 40.0f, 40.0f)];
    
    _currentX=0;
    
    [self.view addSubview:_chart];
    _chart.datasource = self;
    
    _chart.yAxis = [self createAxis];
    _chart.xAxis = [self createAxis];
    
    _chart.yAxis.defaultRange = [[SChartNumberRange alloc] initWithMinimum:@-1 andMaximum:@1];
    
    _data = [NSMutableArray new];
    
    _motion = [CMMotionManager new];
    [_motion startAccelerometerUpdatesToQueue:[NSOperationQueue new]
                                  withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(),^{
                                          [self addData:accelerometerData];
                                      });
                                  }];
    
}

- (void)addData:(CMAccelerometerData*) accelerometerData {
    // create a new datapoint
    SChartDataPoint* pt = [SChartDataPoint new];
    pt.xValue = @(_currentX);
    pt.yValue = @(accelerometerData.acceleration.x);
    _currentX+=1.0;
    
    // add to the series
    [_data addObject:pt];
    [_chart appendNumberOfDataPoints:1 toEndOfSeriesAtIndex:0];
    
    if (_data.count > 1000) {
        // when we hit 1000, remove the first point in the series
        [_data removeObjectsInRange:NSMakeRange(0, 1)];
        [_chart removeNumberOfDataPoints:1 fromStartOfSeriesAtIndex:0];
    }
    [_chart redrawChart];
    
}

- (SChartAxis*) createAxis {
    SChartNumberAxis* axis = [[SChartNumberAxis alloc] init];
    return axis;
}




- (int)numberOfSeriesInSChart:(ShinobiChart*)chart
{
    return 1;
}


-(int)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex {
    return _data.count;
}

// Returns the series at the specified index for a given chart
-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(int)index {
    
    // In our example all series are line series.
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    
    return lineSeries;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex {
    
    return _data[dataIndex];
}


@end
