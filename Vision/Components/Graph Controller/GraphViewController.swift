//
//  GraphViewController.swift
//  B-more
//
//  Created by Idan Moshe on 07/01/2021.
//

import UIKit
import AAInfographics

class GraphViewController: UIViewController {
    
    @IBOutlet private weak var graphView: GraphView!
    
    var configuration: GraphConfiguration?
    var destinationFrame: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var obj = self.graphView.frame
        obj.size.height = self.destinationFrame.size.height
        self.graphView.chartView.frame = obj
        
        self.configure()
    }
    
    private func configure() {
        guard let configuration = self.configuration else { return }
        
        let chartModel = AAChartModel()
            .chartType(.column)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title(configuration.title)//The chart title
            .subtitle(configuration.subtitle)//The chart subtitle
            .dataLabelsEnabled(true) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix(configuration.tooltip)//the value suffix of the chart tooltip
            .categories(configuration.categories)
            .colorsTheme([UIColor.systemGreen.hexString!, UIColor.systemRed.hexString!])
            .series([AASeriesElement()
                        .name(NSLocalizedString("revenue", comment: ""))
                        .data(configuration.revenue),
                    AASeriesElement()
                        .name(NSLocalizedString("expenses", comment: ""))
                        .data(configuration.expenses)])
        
        if configuration.isRefresh {
            self.graphView.chartView.aa_refreshChartWholeContentWithChartModel(chartModel)
        } else {
            self.graphView.chartView.aa_drawChartWithChartModel(chartModel)
        }
    }

}
