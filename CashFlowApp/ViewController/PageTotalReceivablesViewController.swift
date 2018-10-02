//
//  PageTotalReceivablesViewController
//  CashFlowApp
//
//  Created by Harun on 30.09.2018.
//  Copyright © 2018 harun. All rights reserved.
//

import UIKit
import Charts

class PageTotalReceivablesViewController: DemoBaseViewController {
    
    var chartValueX = 2
    var chartValueY = 100
    
    let totalReceivables = ["Current", "Overdue"]
    
    
    @IBOutlet var chartView: PieChartView!
    
    @IBOutlet weak var lblCurrent1: UILabel!
    @IBOutlet weak var lblCurrent2: UILabel!
    @IBOutlet weak var lblOverdue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Pie Chart"
        
        
        self.setup(pieChartView: chartView)
        
        chartView.delegate = self
        
        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        chartView.legend.enabled = false
        
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        self.updateChartData()
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setDataCount(Int(chartValueX), range: UInt32(chartValueY))
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            
            let entryValue = Double(arc4random_uniform(range) + range / 5)
            
            if i==0 {
                self.lblCurrent1.text = "$\(entryValue)"
                self.lblCurrent2.text = "$\(entryValue)"
                
            } else {
                self.lblOverdue.text = "$\(entryValue)"
            }
            
            
            return PieChartDataEntry(value: entryValue,
                                     label: totalReceivables[i % totalReceivables.count],
                                     icon: #imageLiteral(resourceName: "ic_expenses_selected"))
        }
        
        let set = PieChartDataSet(values: entries, label: "Election Results")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = [UIColor(red:0.00, green:0.50, blue:0.50, alpha:1.0),
                    UIColor(red:0.91, green:0.50, blue:0.02, alpha:1.0)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.white)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    
    
 
}
