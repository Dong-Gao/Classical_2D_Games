//
//  ChartViewController.swift
//  NPD_GAMES
//
//  Created by DongGao on 23/5/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit
import Charts



class ChartViewController: UIViewController, ChartViewDelegate {
    var cgid: Int = -1
    
    @IBOutlet weak var barChartView: BarChartView!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        cgid = gameUser.gid
        barChartView.delegate = self
        
        barChartView.noDataText = "No data is available. Try some games!"
        barChartView.noDataFont = NSUIFont(name: "Avenir-Medium", size: 18)
        barChartView.noDataTextColor = .red

        // Do any additional setup after loading the view.
//        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        var time: [String] = []
        var score: [Int] = []
        for level in 0...6 {
            dbConnect.findLevelRecord(level, cgid) { (results) in
                if results.isEmpty == false {
                    print(results)
                    for i in 0..<results.count {
                        time.append(results[i]["time"]! as! String)
                        score.append((results[i]["score"]! as! NSString).integerValue)
                        
                      }
                   }
                DispatchQueue.main.sync {
                    if !time.isEmpty {
                        self.setChart(time, values: score)
                    }
                    
                }
                    
            }

            
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(_ dataPoints: [String], values: [Int]) {
        barChartView.noDataText = "No data is available, try some games!"
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]) )
            dataEntries.append(dataEntry)
        
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Score")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.chartDescription?.text = ""
        barChartView.drawValueAboveBarEnabled = true
        barChartView.dragEnabled = true
        barChartView.dragDecelerationEnabled = true
        barChartView.dragDecelerationFrictionCoef = 0.9
        barChartView.leftAxis.axisMinimum = 0.0
        
    }
    
    
    

}
