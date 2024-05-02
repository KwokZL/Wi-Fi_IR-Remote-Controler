//
//  ReciveView.swift
//  IR Connect
//
//  Created by Kwok Zonlin on 2024/5/12.
//

import SwiftUI
//#if os(ios)
struct ReciveView: View {
    @State var RecivedDatas=[String]()
    @State private var timer: Timer?
    var body: some View {
        VStack{
//            Spacer()
//            Button(action: {RecivedDatas=[]}, label: {Text("Clean All")})
            List{
                ForEach(RecivedDatas,id: \.self){recivedData in
                    HStack{
                        Text(recivedData)
                        Spacer()
                        
//                            Button(action: {NSPasteboard.general.setString(recivedData, forType: .string)}, label: {Text("Copy")})
                        
                        Button(action: {
                            //#if os(ios)
                            
                            #if os(macOS)
                            NSPasteboard.general.setString(recivedData, forType: .string)
                            #else
                            UIPasteboard.general.string=recivedData
                            #endif
                        }, label: {Text("Copy")})
                        
                        
                    }
                    
                }
            }
            .onAppear(){
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    //let url = URL(string: "http://192.168.0.115/IRReSend")
                    guard let url = URL(string: "http://\(ip)/IRReSend") else {
                        print("Invalid URL")
                        return
                    }
                    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let error = error {
                            print("Error fetching data: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let data = data else {
                            print("No data in response")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            if(String(data: data, encoding: .utf8) != ""){
                                RecivedDatas.append(String(data: data, encoding: .utf8)!)
                            }
                            
                            //data = String(data: data, encoding: .utf8) ?? "No data"
                        }
                    }
                    
                    task.resume()
                }
                
            }
            .toolbar{
                ToolbarItem(placement: .automatic, content: {
                    Button(action: {RecivedDatas=[]}, label: {Text("Clean All")})
                })
            }
            
            .onDisappear {
                // 当视图消失时，停止计时器
                timer?.invalidate()
            }
        }
    }
}

#Preview {
    ReciveView()
}
//#endif
