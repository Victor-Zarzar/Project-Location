//
//  ContentView.swift
//  Location
//
//  Created by Victor Zarzar on 08/02/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $vm.location)
                .ignoresSafeArea()
            Circle()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.blue.opacity(0.20))
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    Text("**IP**: \(vm.ipAddress)")
                    Text("\(vm.ipGeo.city), \(vm.ipGeo.country)")
                }
                .padding()
                .frame(width: 330)
                .background(.thickMaterial)
                .cornerRadius(10)
                .padding(.vertical, 50)
            }
            
        }
        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
