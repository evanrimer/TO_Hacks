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
    
    @State var region: Region = .ontario
    @State var data: [DataPoint] = []
    @State var ontarioData: [OntarioDataPoint] = []
    @State var text: String = ""
    @State var timePeriod = TimePeriod.oneMonth
    @State var isPickingRegion = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var deaths: Int {
        return (region == .ontario ? ontarioData.last?.deaths : data.last?.deaths) ?? 0
    }
    var cumulativeDeaths: Int {
        return (region == .ontario ? ontarioData.last?.cumulative_deaths : data.last?.cumulative_deaths) ?? 0
    }
    var cases: Int {
        return (region == .ontario ? ontarioData.last?.cases : data.last?.cases) ?? 0
    }
    var cumulativeCases: Int {
        return (region == .ontario ? ontarioData.last?.cumulative_cases : data.last?.cumulative_cases) ?? 0
    }
    
    var casesChartDataEntries: [ChartDataEntry] {
        if region == .ontario {
            return ontarioData.enumerated().map { ChartDataEntry(x: Double($0.offset), y: Double($0.element.cases))  }
        } else {
            return data.enumerated().map { ChartDataEntry(x: Double($0.offset), y: Double($0.element.cases))  }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    
                    
                    VStack(alignment: .leading, spacing: 1.5) {
                        Text("PUBLIC HEALTH REGION")
                            .font(.caption)
                            .foregroundColor(Color("secondary-text"))
                        
                        
                        NavigationLink(destination: RegionPickingView(region: $region)) {
                            HStack(alignment: .firstTextBaseline) {
                                Text(region.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.primary)
                            }
                            .padding(13.5)
                            .background(
                                Rectangle()
                                    .fill(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(9)
                            )
                        }
                        
                        
                    }
                    .padding(.bottom, 10)
                    
                    
                    HStack {
                        Text("Today")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Cases")
                                .bold()
                            
                            Text("\(cases)")
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        VStack {
                            Text("Deaths")
                                .bold()
                            
                            Text("\(deaths)")
                        }
                        if region == .ontario {
                            Spacer()
                            Divider()
                            Spacer()
                            VStack {
                                Text("Vaccinations")
                                    .bold()
                                    .multilineTextAlignment(.center)
                                
                                Text("\(ontarioData.last?.avaccine ?? 0)")
                            }
                            
                        }
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                    .padding(.bottom, 7.5)
                    
                    HStack {
                        Text("Cumulative Totals")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Cases")
                                .bold()
                            
                            Text("\(cumulativeCases)")
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        VStack {
                            Text("Deaths")
                                .bold()
                            
                            Text("\(cumulativeDeaths)")
                        }
                        if region == .ontario {
                            Spacer()
                            Divider()
                            Spacer()
                            VStack {
                                Text("Vaccinations")
                                    .bold()
                                    .multilineTextAlignment(.center)
                                
                                Text("\(ontarioData.last?.cumulative_avaccine ?? 0)")
                            }
                            
                        }
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                    .padding(.bottom, 7.5)
                    
                    

                    
                    HStack {
                        Text("New Cases")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                    }
                    
                    ChartView(entries: casesChartDataEntries, lineThickness: 1.5)
                        .padding(10)
                        .frame(height: 250)
                        .background(
                            Rectangle()
                                .fill(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                        )
                    
                    if region == .ontario {
                        HStack {
                            Text("Active Cases")
                                .font(.title)
                                .bold()
                            
                            Spacer()
                        }
                        .padding(.top, 7.5)
                        
                        ChartView(entries: ontarioData.enumerated().map { ChartDataEntry(x: Double($0.offset), y: Double($0.element.active_cases))  }, lineThickness: 1.5)
                            .padding(10)
                            .frame(height: 250)
                            .background(
                                Rectangle()
                                    .fill(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 1.5) {
                        Text("TIME PERIOD")
                            .font(.caption)
                            .foregroundColor(Color("secondary-text"))
                        
                        
                        Picker("", selection: $timePeriod) {
                            Text("1W").tag(TimePeriod.oneWeek)
                            Text("1M").tag(TimePeriod.oneMonth)
                            Text("3M").tag(TimePeriod.threeMonths)
                            Text("6M").tag(TimePeriod.sixMonths)
                            Text("1Y").tag(TimePeriod.oneYear)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: timePeriod) { _ in
                            if region == .ontario {
                                DataModel.updateDataForOntario(timePeriod: timePeriod) { newDataPoints in
                                    ontarioData = newDataPoints
                                }
                            } else {
                                DataModel.updateData(for: region, timePeriod: timePeriod) { newDataPoints in
                                    data = newDataPoints
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    Spacer()
                    
                }
            }
            .navigationBarHidden(true)
            .padding()
            .onAppear {
                if region == .ontario {
                    DataModel.updateDataForOntario(timePeriod: timePeriod) { newDataPoints in
                        ontarioData = newDataPoints
                    }
                    data = []
                } else {
                    DataModel.updateData(for: region, timePeriod: timePeriod) { newDataPoints in
                        data = newDataPoints
                    }
                    ontarioData = []
                }
                
            }
        }
        
        
    }
}

enum TimePeriod: CustomStringConvertible, Hashable {
    case oneWeek
    case oneMonth
    case threeMonths
    case sixMonths
    case oneYear
    
    var description: String {
        switch self {
        case .oneWeek: return "1W"
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
        case .oneWeek:
            newDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
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

struct RegionPickingView: View {
    @Binding var region: Region
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        List(Region.allCases) { currentRegion in
            Button(action: {
                if currentRegion != region {
                    region = currentRegion
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                HStack {
                    Text(currentRegion.name)
                    Spacer()
                    if region == currentRegion {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .navigationBarTitle("Region Selection")
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
    var deaths: Int
    var province: String
}

struct OntarioDataPoint: Codable {
    var active_cases: Int
    var active_cases_change: Int
    var avaccine: Int
    var cases: Int
    var cumulative_avaccine: Int
    var cumulative_cases: Int
    var cumulative_cvaccine: Int
    var cumulative_deaths: Int
    var cumulative_dvaccine: Int
    var cumulative_recovered: Int
    var cumulative_testing: Int
    var cvaccine: Int
    var date: String
    var deaths: Int
    var dvaccine: Int
    var province: String
    var recovered: Int
    var testing: Int
}

class DataModel {
    static func updateData(for region: Region, timePeriod: TimePeriod, completion: @escaping ([DataPoint]) -> Void) {
        let params = APIParameters(
            stat: "cases",
            loc: region.rawValue,
            after: timePeriod.dateString
        )
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
    
    static func updateDataForOntario(timePeriod: TimePeriod, completion: @escaping ([OntarioDataPoint]) -> Void){
        let params = APIParameters(
            stat: "cases",
            loc: "ON",
            after: timePeriod.dateString
        )
        let url = "https://api.opencovid.ca/summary"
        AF.request(url, method: .get, parameters: params).responseJSON { response in
            guard let data = response.data else {
                fatalError("Error, could not parse JSON.")
            }
            
            if let json = try? JSON(data: data) {
                if let arr = json["summary"].array {
                    let dataPoints: [OntarioDataPoint] = arr.map { dataPoint in
                        
                        OntarioDataPoint(
                            active_cases: dataPoint["active_cases"].intValue,
                            active_cases_change: dataPoint["active_cases_change"].intValue,
                            avaccine: dataPoint["avaccine"].int ?? 0,
                            cases: dataPoint["cases"].intValue,
                            cumulative_avaccine: dataPoint["cumulative_avaccine"].int ?? 0,
                            cumulative_cases: dataPoint["cumulative_cases"].intValue,
                            cumulative_cvaccine: dataPoint["cumulative_cvaccine"].int ?? 0,
                            cumulative_deaths: dataPoint["cumulative_deaths"].intValue,
                            cumulative_dvaccine: dataPoint["cumulative_dvaccine"].int ?? 0,
                            cumulative_recovered: dataPoint["cumulative_recovered"].intValue,
                            cumulative_testing: dataPoint["cumulative_testing"].intValue,
                            cvaccine: dataPoint["cvaccine"].int ?? 0,
                            date: dataPoint["date"].stringValue,
                            deaths: dataPoint["deaths"].intValue,
                            dvaccine: dataPoint["dvaccine"].int ?? 0,
                            province: dataPoint["province"].stringValue,
                            recovered: dataPoint["recovered"].intValue,
                            testing: dataPoint["testing"].intValue
                        )
//                        dataPoint["active_cases"]
//                        dataPoint["active_cases_change"]
//                        dataPoint["avaccine"]
//                        dataPoint["cases"]
//                        dataPoint["cumulative_avaccine"]
//                        dataPoint["cumulative_cases"]
//                        dataPoint["cumulative_cvaccine"]
//                        dataPoint["cumulative_deaths"]
//                        dataPoint["cumulative_dvaccine"]
//                        dataPoint["cumulative_recovered"]
//                        dataPoint["cumulative_testing"]
//                        dataPoint["cvaccine"]
//                        dataPoint["date"]
//                        dataPoint["deaths"]
//                        dataPoint["dvaccine"]
//                        dataPoint["province"]
//                        dataPoint["recovered"]
//                        dataPoint["testing"]
//
//                        let decoder = JSONDecoder()
//                        return try! decoder.decode(OntarioDataPoint.self, from: dataPoint.rawData())
                    }
                    completion(dataPoints)
                }
            }
            
        }
    }
    
}

enum Region: String, Identifiable, CaseIterable {
    case ontario = "ON"
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
    
    
    var id: String {
        return rawValue
    }
    
    var name: String {
        switch self {
        case .ontario: return "All (Ontario)"
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
