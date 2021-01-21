//
//  ChartViewController.swift
//  B-more
//
//  Created by Idan Moshe on 12/01/2021.
//

import UIKit
import AAInfographics

class ChartViewController: UIViewController {
    
    class func build(frame: CGRect = .zero, configuration: GraphConfiguration) -> ChartViewController {
        let viewController = ChartViewController()
        viewController.configuration = configuration
        viewController.view.frame = frame
        return viewController
    }
    
    private var chartView: AAChartView!
    var configuration: GraphConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chartView = AAChartView()
        self.chartView.frame = .zero
        self.view.addSubview(self.chartView)
        self.chartView.constraints(to: self.view)
        
        self.chartView.frame = self.view.frame
        
        // self.configure()
        
        if configuration.isRefresh {
            self.chartView.aa_refreshChartWholeContentWithChartModel(self.configurePieChart())
        } else {
            self.chartView.aa_drawChartWithChartModel(self.configurePieChart())
        }
    }
    
    private func configurePieChart() -> AAChartModel {
        return AAChartModel()
            .chartType(.pie)
            .backgroundColor(AAColor.white)
            .title(self.configuration.title)
            .subtitle(self.configuration.subtitle)
            .dataLabelsEnabled(true)
            .tooltipValueSuffix(configuration.tooltip)//the value suffix of the chart tooltip
            .colorsTheme([UIColor.systemBlue.hexString!, UIColor.systemGreen.hexString!, UIColor.systemRed.hexString!])
            .yAxisTitle("℃")
            .series([
                AASeriesElement()
                    .name("Reports")
                    .innerSize("20%")
                    .allowPointSelect(true)
                    .states(AAStates()
                        .hover(AAHover()
                            .enabled(true)
                    ))
                    .data([
                        [NSLocalizedString("none", comment: "")  ,configuration.balance.none],
                        [NSLocalizedString("revenue", comment: ""),configuration.balance.revenue],
                        [NSLocalizedString("expenses", comment: ""),configuration.balance.expenses]
                    ])
            ])
    }

}
