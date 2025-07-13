//
//  TitleView.swift
//  WaterWorks
//
//  Created by Tom Dolson on 12/28/19.
//  Copyright © 2019 Tom Dolson. All rights reserved.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack {
            
            Text("Welcome to")
                .customTitleText()
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
            
            Text("Water Werkz!")
                .customTitleText()
                .foregroundColor(.mainColor)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
            
            Image("WaterWave")
                .frame(width: 600, height: 300, alignment: .center)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 4, x: 5, y: 5)
                .padding(.bottom)
            
        }
    }
}
