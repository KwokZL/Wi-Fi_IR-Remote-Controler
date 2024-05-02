//
//  IRRemote.swift
//  IR Connect
//
//  Created by Kwok Zonlin on 2024/5/12.
//

import SwiftUI

struct IRRemote: View {
    @AppStorage("IRControl") var Control=""
    @State var IRSaves=[KeyValuePair]()
    var body: some View {
        List{
            ForEach(0..<IRSaves.count, id: \.self){index in
                
                    Button(IRSaves[index].key, action: {SendIRSign(sign: IRSaves[index].value)})
                
//                Spacer()
//                Button("Delete", action: {
//                    IRSaves.remove(at: index)
//                    Control=encodeArrayToBase64(array: IRSaves)!
//                })
//                .foregroundStyle(.red)
            
            }
            .onDelete(perform: {indexset in
                IRSaves.remove(at: indexset.first!)
                Control=encodeArrayToBase64(array: IRSaves)!
            })
            
        }
            .onAppear(){
                if(Control != ""){
                    IRSaves=decodeBase64ToArray(base64: Control)!
                }
                
            }
    }
}





#Preview {
    IRRemote()
}
