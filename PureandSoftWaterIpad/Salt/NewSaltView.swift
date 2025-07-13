//
//  NewSaltView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 4/5/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI

struct NewSaltView: View {
    
    var onDismiss: () -> ()
    
    var body: some View {
        VStack(alignment: .center) {
            PageHeaderView(typePage: "New Salt Ticket", foregroundColor: Color.black, bgColor: Color.yellow)
                .padding(.init(top: 20, leading: 0, bottom: -10, trailing: 0))
            
            VStack(alignment: .center, spacing: 5) {
                        HStack(alignment: .top, spacing: 5) {
                            //Text("\(self.name)  -  \(self.address)")
                            Text("Dolson, Tom  -  16 Homestead Street, Hillsdale NJ 07642")
                                .font(.system(size: 16))
                                .bold()
                                .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                                .foregroundColor(Color.black)
                                .background(Color.white)
                                .cornerRadius(5)
                                .shadow(color: Color.yellow, radius: 3)
                                .padding(.init(top: 20, leading: 0, bottom: 5, trailing: 0))
                        }
                    }
                    
                    HStack {
                        Button(action: {
                            
                            // if self.isRequired() {
                            
                            // self.notificationShown = true
                            //   } else {
                            
                            //if self.saveNewRecord() {
                            
                            self.onDismiss()
                            
                            // }
            
                            // }
                        }) {
                            Text("SAVE")
                                .foregroundColor(.green)
                        }.buttonStyle(BorderlessButtonStyle())
                            .padding(.init(top: 0, leading: 25, bottom: 5, trailing: 0))
                        Spacer()
                        
                        Button(action: {
                            self.onDismiss()
                        }) {
                            Text("CANCEL")
                                .foregroundColor(.red)
                        }.buttonStyle(BorderlessButtonStyle())
                            .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 30))
                    }.frame(height: 30)
                    
                    Spacer()
        }
    }
}

struct NewSaltView_Previews: PreviewProvider {
    static var previews: some View {
        NewSaltView(onDismiss: {Binding.constant(false)})
    }
}
