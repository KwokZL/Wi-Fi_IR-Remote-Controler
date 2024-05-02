//
//  ContentView.swift
//  IR Connect
//
//  Created by Kwok Zonlin on 2024/5/11.
//

import SwiftUI

var ip="192.168.0.101"
struct ContentView: View {
    var body: some View {
        
        TabView{
            IRRemote()
                .tabItem({
                    Text("IRRemote")
                })
            
            ReciveView()
                .tabItem({
                    Text("IRRecive")
                })
            
            IRSend()
                .tabItem({
                    Text("IRSend")
                })
            IRContol()
                .tabItem({
                    Text("IRContol")
                })
        }
        .navigationTitle("Subtitle")
    }
    
}

#Preview {
    ContentView()
}
