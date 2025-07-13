//
//  Extensions+Modifiers.swift
//  WaterWorks
//
//  Created by Tom Dolson on 12/28/19.
//  Copyright © 2019 Tom Dolson. All rights reserved.
//

import SwiftUI
import UIKit


struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
            .frame(minWidth: 0, maxWidth: 200, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.mainColor))
            //.padding(.bottom)
    }
}

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}

extension Text {
    func customTitleText() -> Text {
        self
            .fontWeight(.black)
            .font(.system(size: 42))
    }
}

extension Color {
    static var mainColor = Color(UIColor.systemBlue)
}

