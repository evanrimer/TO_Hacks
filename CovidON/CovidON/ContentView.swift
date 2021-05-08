//
//  ContentView.swift
//  CovidON
//
//  Created by Noah Wilder on 2021-05-08.
//

import SwiftUI
import SwiftyJSON
import Alamofire

struct ContentView: View {
    
    @State var region: Region = .ontario
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Region: \(region.name)")
                    Image(systemName: "chevron.down")
                }
                .font(.title2)
                .padding(.bottom, 20)
                
                HStack {
                    Text("Active cases")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("CovidON")
                
        }
        
        
    }
}

//class DataModel {
//    static func getJSON(for region: Region) -> JSON {
//
//    }
//}

enum Region {
    
    case ontario
    
    var name: String {
        switch self {
        case .ontario: return "Ontario"
        }
    }
}

struct ChartView: View {
    var body: some View {
        Text("")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
