//
//  macOSMain.swift
//  IR Connect
//
//  Created by Kwok Zonlin on 2024/5/18.
//

import SwiftUI

struct macOSMain: View {
    @State var subjectTitle=""
    var body: some View {
        //SidebarListS
        NavigationSplitView{
           
        
               // List{
//
            List{
                //Section(<#T##title: StringProtocol##StringProtocol#>, content: <#T##() -> View#>)
//                Section("123",content: {
                    
//                })
//                NavigationLink(destination: IRRemote()) { Image(systemName: "control").foregroundStyle(.link);Text("IRRemote") }
                NavigationLink(destination: IRRemote()) {Label("IRRemote", systemImage: "control") }
                NavigationLink(destination: ReciveView()) {Label("IRRecive", systemImage: "square.and.arrow.down") }
                NavigationLink(destination: IRSend()) {Label("IRSend", systemImage: "paperplane") }
                NavigationLink(destination: IRContol()) {Label("IRContol", systemImage: "av.remote") }
                
                //NavigationLink(destination: Text("IRContol")) { Text("IRContol") }
                    
            }
            .listStyle(.sidebar)
//            .safeAreaInset(edge: .bottom, content: {
//                Text("Only for Demo")
//            })
            //.listStyle(.sidebar)
            
            //.navigationBarHidden(true)
            //
            //.toolbar(removing: .sidebarToggle)
          //  .navigationBarBackButtonHidden()
          //  .toolbarRole(.editor)
           // .toolbar(.hidden, for: .automatic)
            
            .toolbar{
                #if os(macOS)
                ToolbarItem(placement: .navigation, content: {
                    Button(action: {print("1234")}, label: {Image(systemName: "plus")})
                
                })
                
                #elseif os(iOS)
                ToolbarItem(placement: ToolbarItemPlacement.navigation, content: {
                    Button(action: {print("1234")}, label: {Image(systemName: "plus")})
                })
                #endif
                
                    
                    //.padding()
                
            }
            //.minimumScaleFactor(1)
            
            
            .navigationTitle("IR Connect")
        }detail: {
            VStack(spacing: 15){
                
                Image("Icon")
                #if os(iOS)
                    .resizable()
                    .frame(width: 100,height: 100)
                    .cornerRadius(30)
                #elseif os(macOS)
                
                    .resizable()
                    .frame(width: 100,height: 100)
                    //.cornerRadius(30)
                #endif
                //Spacer()
                Text("Choose items to start.")
            }
            
        }
        .navigationTitle(subjectTitle)
    }
    
}
//#Preview {
////    macOSMain(subjectTitle: Bin"")
//}

struct aaa:Codable,Hashable{
    
    let int1:String
    
}
