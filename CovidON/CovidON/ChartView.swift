//
//  ChartView.swift
//  CovidON
//
//  Created by Noah Wilder on 2021-05-08.
//

import Foundation
import Charts
import SwiftUI

struct ChartView: UIViewRepresentable {
    typealias UIViewType = LineChartView
    let entries: [ChartDataEntry]
    var lineThickness: CGFloat
    
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView()
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries)
        uiView.noDataText =  "No Data"
        uiView.data = LineChartData(dataSet: dataSet)
        uiView.setScaleEnabled(false)
        uiView.legend.enabled = false
        formatAxes(left: uiView.leftAxis, right: uiView.rightAxis, top: uiView.xAxis)
        formatDataSet(dataSet: dataSet)
        uiView.xAxis.drawGridLinesEnabled = false
        uiView.xAxis.drawAxisLineEnabled = false
        uiView.leftAxis.drawAxisLineEnabled = false
//        uiView.leftAxis.drawGridsLineEnabled = false


    }
    
    func formatAxes(left: YAxis, right: YAxis, top: XAxis) {
        right.enabled = false
        top.enabled = false
        left.axisMinLabels = 10
    }
    
    func formatDataSet(dataSet: LineChartDataSet) {
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.lineWidth = lineThickness
        dataSet.setColor(UIColor.blue)
//        let colors = [Color.blue.cgColor, Color.clear.cgColor] as CFArray
//        let colorLocations: [CGFloat] = [0.0, 1.0]
//        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: colorLocations)
//        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90)
//        dataSet.drawFilledEnabled = true
    }
    
}


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(entries: [ChartDataEntry(x: 1619290130053, y: 0.3413397951438261),
                            ChartDataEntry(x: 1619290426422, y: 0.3421743651388552),
                            ChartDataEntry(x: 1619290697044, y: 0.3422815498652049)], lineThickness: 8)
    }
}

