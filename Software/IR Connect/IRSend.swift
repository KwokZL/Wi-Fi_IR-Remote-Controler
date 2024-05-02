//
//  IRSend.swift
//  IR Connect
//
//  Created by Kwok Zonlin on 2024/5/12.
//

import SwiftUI

struct IRSend: View {
    @State var IRSign=""
    var body: some View {
        VStack{
            TextField("IRSign", text: $IRSign)
            
            Button(action: {SendIRSign(sign: IRSign)}, label: {Text("Send")})
        }
    }
    
    
    
    
}



func SendIRSign(sign:String!){
    guard let url = URL(string: "http://\(ip)/IRControl?IRSign="+sign) else {
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
                    if(String(data: data, encoding: .utf8) == "Success"){
                        print("Success")
                    }else{
                        print("F")
                    }
                    
                    //data = String(data: data, encoding: .utf8) ?? "No data"
                }
            }
            
            task.resume()
}


#Preview {
    IRSend()
}
