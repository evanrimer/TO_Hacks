//
//  ContentView.swift
//  CovidON
//
//  Created by Noah Wilder on 2021-05-08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("CovidON")
                .padding()
                .foregroundColor(.blue)
                .font(.title2)
                .navigationTitle("CovidON")
                
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
