//
//  CalendarHeaderView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 1/5/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import SwiftUI

struct PageHeaderView: View {
    
    var typePage = "Customer Search"
    var foregroundColor: Color = Color.white
    var bgColor: Color = Color.green
    
    var body: some View {
        
        HStack {
            Text("\(typePage)")
                .font(.system(size: 24))
                .bold()
                .foregroundColor(foregroundColor)
                .padding(.init(top: 5, leading: 150, bottom: 5, trailing: 150))
                .background(bgColor)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
                .padding(.init(top: 5, leading: 0, bottom: 25, trailing: 0))
            
            
        }
    }
}

struct PageHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PageHeaderView()
    }
}
