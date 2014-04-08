# Plotting Accelerometer Values

This is a demo project that demonstrates how to plot the accelerometer readings from the CoreMotion framework onto a ShinobiChart.

![Screenshot](screenshot.png?raw=true)

This project makes use of a couple of new methods that have been added to the chart:

    /** Notifies the data controller that the specified number of data points are available to be appended to the end of the specified chart series.
 
     @param numberOfDataPoints  The number of data points which are available to be appended to the end of the series.
     @param seriesIndex The index of the series which should append the new data.
     */
    - (void)appendNumberOfDataPoints:(unsigned int)numberOfDataPoints toEndOfSeriesAtIndex:(unsigned int)seriesIndex;

    /** Notifies the data controller that the specified number of data points should be removed from the start of the specified chart series.
 
     @param numberOfPointsToRemoveFromStart The number of data points which should be removed from the start of the series.
     @param seriesIndex The index of the series which should append the new data.
     */
    - (void)removeNumberOfDataPoints:(unsigned int)numberOfDataPoints fromStartOfSeriesAtIndex:(unsigned int)seriesIndex;

These methods allow you to inform the chart when data is appended to a series, or removed from the start of the series. When either occurs the chart is able to optimise its redraw process.

Following one or more calls to the above methods you must send the `redrawChart` message to the chart in order to tell it to update the GL layer.
