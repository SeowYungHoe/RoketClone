//
//  HistoryViewController.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 18/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import Charts

class HistoryViewController: UIViewController {
    

    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let chart = HorizontalBarChartView(frame: self.view.frame)
        
        let yVals = [ 873, 568, 937, 726, 696, 687, 180, 389, 90, 928, 890, 437]
        var entries = [ BarChartDataEntry]()
        for (i, v) in yVals.enumerated() {
            let entry = BarChartDataEntry()
            entry.x = Double( i)
            entry.y = Double(v)
            
            entries.append( entry)
        }
        

        
        
        let set = BarChartDataSet( values: entries, label: "Score")
        let data = BarChartData( dataSet: set)
        barChartView.data = data
        barChartView.noDataText = "No data available"
        barChartView.isUserInteractionEnabled = false
        
        
        self.view.addSubview(barChartView)

    }



}
