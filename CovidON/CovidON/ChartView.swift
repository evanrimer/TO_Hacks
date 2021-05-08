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
    @Binding var thick: Double
    
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
    }
    
    func formatAxes(left: YAxis, right: YAxis, top: XAxis) {
        right.enabled = false
        top.enabled = false
        left.axisMinLabels = 10
    }
    
    func formatDataSet(dataSet: LineChartDataSet) {
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.lineWidth = CGFloat(thick)
        dataSet.setColor((entries.last?.y ?? 0 > entries.first?.y  ?? 1) ? UIColor.green : UIColor.red)
    }
    
}


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(entries: [ChartDataEntry(x: 1619290130053, y: 0.3413397951438261),
                            ChartDataEntry(x: 1619290426422, y: 0.3421743651388552),
                            ChartDataEntry(x: 1619290697044, y: 0.3422815498652049)], thick: .constant(8))
    }
}

