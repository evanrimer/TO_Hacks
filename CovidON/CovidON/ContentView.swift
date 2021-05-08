//
//  ContentView.swift
//  CovidON
//
//  Created by Noah Wilder on 2021-05-08.
//

import SwiftUI
import SwiftyJSON
import Alamofire
import Charts

struct ContentView: View {
    
    @State var region: Region = .kfla
    @State var data: [DataPoint] = []
    @State var text: String = ""
    @State var timePeriod = TimePeriod.oneMonth
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 1.5) {
                    Text("PUBLIC HEALTH REGION")
                        .font(.caption)
                        .foregroundColor(Color("secondary-text"))
                    
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text(region.name)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                        .padding(13.5)
                        .background(
                            Rectangle()
                                .fill(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(9)
                        )
                }
                HStack(alignment: .firstTextBaseline) {
                    Text("Region: \(region.name)")
                    Image(systemName: "chevron.down")
                }
                .font(.title2)
                .padding(.bottom, 20)
                
                HStack {
                    Spacer()
                    VStack {
                        Text("New Cases")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("17")
                            .font(Font.system(size: 50, weight: .semibold, design: .rounded))
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(radius: 10)
                    )
                    Spacer()
                }
                
                HStack {
                    Text("Cases")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                }
                ChartView(entries: data.enumerated().map { ChartDataEntry(x: Double($0.offset), y: Double($0.element.cases))  }, thick: .constant(2))
                
                Picker("", selection: $timePeriod) {
                    Text("1M").tag(TimePeriod.oneMonth)
                    Text("3M").tag(TimePeriod.threeMonths)
                    Text("6M").tag(TimePeriod.sixMonths)
                    Text("1Y").tag(TimePeriod.oneYear)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: timePeriod) { _ in
                    DataModel.updateData(for: region, timePeriod: timePeriod) { newDataPoints in
                        data = newDataPoints
                    }
                }
                
                Spacer()
                
                
            }
            .padding()
            .navigationTitle("CovidON")
            .onAppear {
                DataModel.updateData(for: region, timePeriod: timePeriod) { newDataPoints in
                    data = newDataPoints
                }
            }
        }
        
        
    }
}

enum TimePeriod: CustomStringConvertible, Hashable {
    case oneMonth
    case threeMonths
    case sixMonths
    case oneYear
    
    var description: String {
        switch self {
        case .oneMonth: return "1M"
        case .threeMonths: return "3M"
        case .sixMonths: return "6M"
        case .oneYear: return "1Y"
        }
    }
    
    var date: Date {
        let currentDate = Date()
        let newDate: Date
        switch self {
        case .oneMonth:
            newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        case .threeMonths:
            newDate = Calendar.current.date(byAdding: .month, value: -3, to: currentDate)!
        case .sixMonths:
            newDate = Calendar.current.date(byAdding: .month, value: -6, to: currentDate)!
        case .oneYear:
            newDate = Calendar.current.date(byAdding: .year, value: -1, to: currentDate)!
        }
        return newDate
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
}


struct APIParameters: Codable {
    var stat: String
    var loc: String
    var after: String
}

struct DataPoint: Codable {
    var cases: Int
    var cumulative_cases: Int
    var cumulative_deaths: Int
    var date: String
    var deaths: Double
    var province: String
    var health_region: String
}
//struct DataPoint: Codable {
//    var active_cases: Int
//    var active_cases_change: Int
//    var avaccine: Int
//    var cases: Int
//    var cumulative_avaccine: Int
//    var cumulative_cases: Int
//    var cumulative_cvaccine: Int
//    var cumulative_deaths: Int
//    var cumulative_dvaccine: Int
//    var cumulative_recovered: Int
//    var cumulative_testing: Int
//    var cvaccine: Int
//    var date: String
//    var deaths: Int
//    var dvaccine: Int
//    var province: String
//    var recovered: Int
//    var testing: Int
//}
class DataModel {
    static func updateData(for region: Region, timePeriod: TimePeriod, completion: @escaping ([DataPoint]) -> Void){
        let params = APIParameters(
            stat: "cases",
            loc: region.rawValue,
            after: timePeriod.dateString
        )
        print(DataModel.monthAgoDateString())
        let url = "https://api.opencovid.ca/summary"
        AF.request(url, method: .get, parameters: params).responseJSON { response in
            guard let data = response.data else {
                fatalError("Error, could not parse JSON.")
            }
            
            if let json = try? JSON(data: data) {
                if let arr = json["summary"].array {
                    let dataPoints: [DataPoint] = arr.map { dataPoint in
                        let decoder = JSONDecoder()
                        return try! decoder.decode(DataPoint.self, from: dataPoint.rawData())
                    }
                    completion(dataPoints)
                }
            }
            
        }
    }
    static func monthAgoDateString() -> String {
        let currentDate = Date()
        let date = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
}

enum Region: String, CaseIterable {
    case algoma = "3526"
    case brant = "3527"
    case chatamKent = "3540"
    case durham = "3530"
    case eastern = "3558"
    case greyBruce = "3533"
    case haldimandNorfolk = "3534"
    case haliburtonKawarthaPineridge = "3535"
    case halton = "3536"
    case hamilton = "3537"
    case hastingPriceEdward = "3538"
    case huronPerth = "3539"
    case kfla = "3541"
    case lambton = "3542"
    case leedsGrenvilleLanark = "3543"
    case middlesexLondon = "3544"
    case niagra = "3546"
    case northBayNorth = "3547"
    case northwestern = "3549"
    case ottawa = "3551"
    case peel = "3553"
    case peterborough = "3555"
    case porcupine = "3556"
    case renfrew = "3557"
    case simcoeMuskoka = "3560"
    case southwestern = "3575"
    case sudbury = "3561"
    case thunderBay = "3562"
    case timiskaming = "3563"
    case toronto = "3595"
    case waterloo = "3565"
    case wellingtonDufferinGuelph = "3566"
    case womdsorEssex = "3568"
    case york = "3570"
    
    var name: String {
        switch self {
        case .algoma: return "Algoma"
        case .brant: return "Brant"
        case .chatamKent: return "Chatham-Kent"
        case .durham: return "Durham"
        case .eastern: return "Eastern"
        case .greyBruce: return "Grey Bruce"
        case .haldimandNorfolk: return "Haldimand-Norfolk"
        case .haliburtonKawarthaPineridge: return "Haliburton Kawartha Pineridge"
        case .halton: return "Halton"
        case .hamilton: return "Hamilton"
        case .hastingPriceEdward: return "Hastings Prince Edward"
        case .huronPerth: return "Huron Perth"
        case .kfla: return "Kingston Frontenac Lennox & Addington"
        case .lambton: return "Lambton"
        case .leedsGrenvilleLanark: return "Leeds Grenville and Lanark"
        case .middlesexLondon: return "Middlesex-London"
        case .niagra: return "Niagara"
        case .northBayNorth: return "North Bay Parry Sound"
        case .northwestern: return "Northwestern"
        case .ottawa: return "Ottawa"
        case .peel: return "Peel"
        case .peterborough: return "Peterborough"
        case .porcupine: return "Porcupine"
        case .renfrew: return "Renfrew"
        case .simcoeMuskoka: return "Simcoe"
        case .southwestern: return "Southwestern"
        case .sudbury: return "Sudbury"
        case .thunderBay: return "Thunder Bay"
        case .timiskaming: return "Timiskaming"
        case .toronto: return "Toronto"
        case .waterloo: return "Waterloo"
        case .wellingtonDufferinGuelph: return "Wellington Dufferin Guelph "
        case .womdsorEssex: return "Windsor-Essex"
        case .york: return "York"
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
