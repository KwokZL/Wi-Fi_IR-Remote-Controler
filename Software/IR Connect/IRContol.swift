//
//  IRContol.swift
//  IR Connect
//
//  Created by Kwok Zonlin on 2024/5/12.
//

import SwiftUI

struct IRContol: View {
    @AppStorage("IRControl") var Control=""
    @State var Name=""
    @State var IRSign=""
    @State var DeviceName=""
    @State var IRSave=[KeyValuePair]()
    var body: some View {
        VStack{
            TextField("DeviceName", text: $DeviceName)
            TextField("Name", text: $Name)
            TextField("IRSign", text: $IRSign)
            Button(action: {
                var irdata=KeyValuePair(key:DeviceName+":"+Name,value: IRSign)
                IRSave.append(irdata)
                Control=encodeArrayToBase64(array: IRSave)!
                Name=""
                IRSign=""
            }, label: {Text("Save")})
        }
        .onAppear(){
            if(Control != ""){
                IRSave=decodeBase64ToArray(base64: Control)!
            }
            
        }
    }
}

struct KeyValuePair: Codable,Hashable {
    let key: String
    let value: String
}

// 将数组编码为Base64字符串
func encodeArrayToBase64(array: [KeyValuePair]) -> String? {
    do {
        let jsonData = try JSONEncoder().encode(array)
        return jsonData.base64EncodedString()
    } catch {
        print(error)
        return nil
    }
}

// 将Base64字符串解码为数组
func decodeBase64ToArray(base64: String) -> [KeyValuePair]? {
    guard let jsonData = Data(base64Encoded: base64) else { return nil }
    do {
        return try JSONDecoder().decode([KeyValuePair].self, from: jsonData)
    } catch {
        print(error)
        return nil
    }
}


#Preview {
    IRContol()
}
