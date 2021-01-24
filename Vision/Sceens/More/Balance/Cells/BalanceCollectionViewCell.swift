//
//  BalanceCollectionViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 24/12/2020.
//

import UIKit
import AAInfographics

class BalanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var graphView: GraphView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String = "", subtitle: String = "") {
        let chartModel = AAChartModel()
            .chartType(.column)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title(title)//The chart title
            .subtitle(subtitle)//The chart subtitle
            .dataLabelsEnabled(true) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("USD")//the value suffix of the chart tooltip
            .categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .series([AASeriesElement()
                        .name("Tokyo")
                        .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]),
                    AASeriesElement()
                        .name("New York")
                        .data([0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]),
                    AASeriesElement()
                        .name("Berlin")
                        .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]),
                    AASeriesElement()
                        .name("London")
                        .data([3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8])])
        
        self.graphView.chartView.aa_drawChartWithChartModel(chartModel)
    }

}
