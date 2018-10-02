//
//  CombinedChartViewController.swift
//  CashFlowApp
//
//  Created by Harun on 1.10.2018.
//  Copyright © 2018 harun. All rights reserved.
//

import UIKit
import Charts

private let ITEM_COUNT = 7


class PageIncomeExpenseViewController: DemoBaseViewController {
    
    @IBOutlet weak var lblSepIncome: UILabel!
    @IBOutlet weak var lblSepExpense: UILabel!
    
    @IBOutlet weak var lblTotalIncome: UILabel!
    @IBOutlet weak var lblTotalExpense: UILabel!
    
    @IBOutlet var chartView: CombinedChartView!
    
    let months = ["Mar","Apr", "May",
                  "Jun","Jul", "Aug",
                  "Sep"]
    
    var totalIncome: Double = 0.0
    var totalExpense: Double = 0.0
    
    
    
    
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
        
        
        chartView.drawOrder = [DrawOrder.bar.rawValue]
     
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 1
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 700
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        
        let rightAxis = chartView.rightAxis
        rightAxis.axisMinimum = 0
        rightAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMaximum = 700
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
        data.barData = generateBarData()
     
        
        chartView.xAxis.axisMaximum = data.xMax + 0.25
        
        chartView.data = data
    }
    
    
    
    func generateLineData() -> LineChartData {
        let entries = (0..<ITEM_COUNT).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i) + 0.5, y: Double(arc4random_uniform(15) + 5))
        }
        
        let set = LineChartDataSet(values: entries, label: "Line DataSet")
        set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.lineWidth = 2.5
        set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 10)
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        
        
        set.axisDependency = .left
        
        
        return LineChartData(dataSet: set)
    }
    
    func generateBarData() -> BarChartData {
        let entries1 = (0..<ITEM_COUNT).map { i -> BarChartDataEntry in
            
            let incomeValue = Double(arc4random_uniform(700))
            totalIncome += incomeValue
            
            return BarChartDataEntry(x: 0, y: incomeValue)
        }
        let entries2 = (0..<ITEM_COUNT).map { i -> BarChartDataEntry in
            let entry1Value = Double(arc4random_uniform(700))
            let entry2Value = Double(arc4random_uniform(700))
            
           
            totalExpense += (entry1Value + entry2Value)
          
            
            return BarChartDataEntry(x: 0, yValues: [entry1Value, entry2Value])
        }
      
        
        let incomeValue:Double = entries1[entries1.count-1].y
        let expenseValue:Double = (entries2[entries2.count-1].yValues?[0])! + (entries2[entries2.count-1].yValues?[1])!
        
        
        self.lblSepIncome.text = "$\(incomeValue)"
        self.lblSepExpense.text = "$\(expenseValue)"
        
        
        self.lblTotalIncome.text = "$\(totalIncome)"
        self.lblTotalExpense.text = "$\(totalExpense)"
        
        let set1 = BarChartDataSet(values: entries1, label: "")
        set1.setColor(UIColor(red:0.75, green:0.87, blue:0.60, alpha:1.0))
        set1.valueTextColor = UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1)
        set1.valueFont = .systemFont(ofSize: 10)
        set1.axisDependency = .left
        set1.drawValuesEnabled = false
        
        
        let set2 = BarChartDataSet(values: entries2, label: "")
        set2.stackLabels = ["Stack 1", "Stack 2"]
        set2.colors = [UIColor(red:0.93, green:0.82, blue:0.48, alpha:1.0)
        ]
        set2.valueTextColor = UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1)
        set2.valueFont = .systemFont(ofSize: 10)
        set2.axisDependency = .left
        set2.drawValuesEnabled = false
        
        let groupSpace = 0.06
        let barSpace = 0.0 // x2 dataset
        let barWidth = 0.45 // x2 dataset
        // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
        
        let data = BarChartData(dataSets: [set1, set2])
        data.barWidth = barWidth
        
        // make this BarData object grouped
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        return data
    }
    
 
}

extension PageIncomeExpenseViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value) % months.count]
    }
}
