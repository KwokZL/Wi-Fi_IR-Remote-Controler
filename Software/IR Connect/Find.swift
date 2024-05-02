//
//  Find.swift
//  IR Connect
//
//  Created by Kwok Zonlin on 2024/5/12.
//

import SwiftUI
import Network

struct FindView: View {
    @State private var esp8266IP: String = ""
    
    var body: some View {
        VStack {
            Text("ESP8266 IP: \(esp8266IP)")
        }
        .onAppear {
            //startMonitoringESP8266()
        }
    }
    
//    func startMonitoringESP8266() {
//        let queue = DispatchQueue(label: "com.example.udp-monitor")
//        let group = DispatchGroup()
//        //NWListener(using: <#T##NWParameters#>, on: 4210)
//        let udpSocket = NWUDPSession(listenOn: NWEndpoint.hostPort(host: "0.0.0.0", port: 4210)) { (data, address, error) in
//            if let data = data, let ipString = String(data: data, encoding: .utf8) {
//                self.esp8266IP = ipString
//            }
//        }
//        
//        udpSocket.resume()
//        
//        // 你可以添加其他逻辑来定期检查ESP8266的IP，或者通过其他方式（如HTTP请求）来获取
//    }
}
