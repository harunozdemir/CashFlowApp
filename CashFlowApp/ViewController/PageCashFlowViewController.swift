//
//  PageCashFlowViewController
//  CashFlowApp
//
//  Created by Harun on 30.09.2018.
//  Copyright © 2018 harun. All rights reserved.
//

import UIKit
import Charts

private let ITEM_COUNT = 7

class PageCashFlowViewController: DemoBaseViewController {
    
    @IBOutlet weak var lblSeptemberCash1: UILabel!
    @IBOutlet weak var lblSeptemberCash2: UILabel!
    @IBOutlet var chartView: CombinedChartView!
    
    let months = ["Oct", "Dec", "Feb",
                  "Apr", "Jun", "Aug",
                  "Sep"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Combined Chart"
       
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        
        chartView.drawBarShadowEnabled = false
        chartView.highlightFullBarEnabled = false
        chartView.legend.enabled = false
        
        chartView.xAxis.drawGridLinesEnabled = false
        
        
        chartView.drawOrder = [DrawOrder.line.rawValue]
      
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 1
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " K"
        leftAxisFormatter.positiveSuffix = " K"
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 10
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = -1
        leftAxis.axisMaximum = 10
        
        let rightAxis = chartView.rightAxis
        rightAxis.axisMinimum = 0
        rightAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.valueFormatter = self
        
        self.updateChartData()
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setChartData()
    }
    
    func setChartData() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        
        
        chartView.xAxis.axisMaximum = data.xMax + 0.25
        
        chartView.data = data
    }
   
    
    func generateLineData() -> LineChartData {
        let entries = (0..<ITEM_COUNT).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i) + 0.5, y: Double(arc4random_uniform(10)))
        }
        
        let sepCashValue = entries[entries.count-1].y
        
        self.lblSeptemberCash1.text = "$\(sepCashValue*1000)"
        self.lblSeptemberCash2.text = "$\(sepCashValue*1000)"
        
        
        
        let set = LineChartDataSet(values: entries, label: "Line DataSet")
        set.setColor(UIColor(red:0.31, green:0.64, blue:0.88, alpha:1.0))
        set.lineWidth = 2.5
        set.setCircleColor(UIColor(red:0.31, green:0.64, blue:0.88, alpha:1.0))
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(red:0.31, green:0.64, blue:0.88, alpha:1.0)
        set.mode = .cubicBezier
        set.drawValuesEnabled = false
        set.valueFont = .systemFont(ofSize: 10)
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
}

extension PageCashFlowViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value) % months.count]
    }
}
