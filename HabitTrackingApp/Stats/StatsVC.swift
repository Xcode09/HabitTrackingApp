//
//  StatsVC.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 02/11/2021.
//

import UIKit
import Charts
import Alamofire
enum WeekDayName: String {
    case Sunday = "Sun"
    case Monday = "Mon"
    case Tuesday = "Tue"
    case Wednesday = "Wed"
    case Thursday = "Thu"
    case Friday = "Fri"
    case Saturday = "Sat"

}
struct Day{
    let date:Date
    let value:String
}

class StatsVC: UIViewController {
    @IBOutlet weak private var chart1:BarChartView!
    @IBOutlet weak private var chart2:BarChartView!
    var week = [String]()
    var staticSteps = [Int]()
    private var arrar = [Day(date: Date(), value: "45"),Day(date: Date(), value: "78")]
    
    var referenceTimeInterval: TimeInterval = 0
    var todayName:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setChart(dataPoints: week, values: staticSteps)
        Networking.shareInstance.callNetwork(uri: ApiEndPoints.getTracks,method: .post,parameters: ["id":"\(golbalUser.id ?? 0)"]) { (result:Result<TrackModel>) in
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else {return}
                switch result{
                case .success(let user):
                    guard let track = user.result else{
                        return
                    }
                    
                    let dic = Dictionary(grouping: track) { (t) -> String in
                        
                        return (t.day ?? "")
                    }
                    for (index,dic) in dic.enumerated(){
                        print("Adding values")
                        self.week.append(dic.key)
                        self.staticSteps.append(Int(dic.value[index].nailBiteCounter ?? "0") ?? 0)
                    }
                    
//
                    
                    print(self.week)
                    print(self.staticSteps)
                    self.setup(barLineChartView: self.chart1)
                case .failure(let er):
                    print(er)
                }
            }
        }
    }
    
    func setup(barLineChartView chartView: BarChartView) {
        chartView.chartDescription.enabled = false

            chartView.isUserInteractionEnabled = false //Disables the selection for bar charts
            chartView.dragEnabled = true
            chartView.setScaleEnabled(false) //turn off scaling /kinda pinch zoom type
            chartView.pinchZoomEnabled = false //disables pinch zoom


            let xAxis = chartView.xAxis
            xAxis.labelPosition = .bottom
            xAxis.labelFont = .systemFont(ofSize: 10)
            xAxis.granularity = 1
            //hides grid
            xAxis.drawGridLinesEnabled = false


        chartView.xAxis.valueFormatter = WeekValueFormatter(weeks: week)



        //xAxis.labelCount = week.count
            chartView.animate(yAxisDuration: 3)
           chartView.rightAxis.enabled = false

            let leftAxisFormatter = NumberFormatter()
//            leftAxisFormatter.minimumFractionDigits = 0
//            leftAxisFormatter.maximumFractionDigits = 1

            let leftAxis = chartView.leftAxis
            leftAxis.labelFont = .systemFont(ofSize: 10)
            //leftAxis.granularity = 1
            //leftAxis.labelCount =
            leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
//            leftAxis.labelPosition = .outsideChart
//            leftAxis.spaceTop = 0.15
//            leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES


            let l = chartView.legend
            l.horizontalAlignment = .left
            l.verticalAlignment = .bottom
            l.orientation = .horizontal
            l.drawInside = false
            l.form = .circle
            //l.formSize = 9
            l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
            //l.xEntrySpace = 4

            //setChart(dataPoints: months, values: unitsSold.map { Double($0) })
            setChart(dataPoints: week, values: staticSteps)
        }
    
    
   
    
    func setChart(dataPoints: [String], values: [Int]) {
        chart1.noDataText = "You need to provide data for the chart."

           var dataEntries: [BarChartDataEntry] = []

           for i in 0..<values.count {
               print(i)
            let dataEntry = BarChartDataEntry(x:Double(i), y: Double(values[i]))
               dataEntries.append(dataEntry)
           }
           let chartDataSet = BarChartDataSet(entries: dataEntries)
           chartDataSet.colors = ChartColorTemplates.colorful()
           let chartData = BarChartData(dataSet: chartDataSet)
        chart1.data = chartData
       }
    
    func getCurrentDayName(){
            let weekday = Calendar.current.component(.weekday, from: Date())
            print(weekday)
            switch weekday {
            case 1:
               todayName = WeekDayName.Sunday.rawValue
            case 2:
               todayName = WeekDayName.Monday.rawValue
            case 3:
               todayName = WeekDayName.Tuesday.rawValue
            case 4:
               todayName = WeekDayName.Wednesday.rawValue
            case 5:
               todayName = WeekDayName.Thursday.rawValue
            case 6:
               todayName = WeekDayName.Friday.rawValue
            case 7:
               todayName = WeekDayName.Saturday.rawValue
            default:
                print("nothng")
            }
            print(todayName)
        }
    
}

//MARK: Weeks Bottom Label Class for x-Axis labels
public class WeekValueFormatter:AxisValueFormatter {
    var weeks : [String]
    init(weeks:[String]) {
        self.weeks = weeks
    }
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return weeks[Int(value)]
    }
}
