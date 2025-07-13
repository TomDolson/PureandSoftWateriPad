//
//  UtilityFile.swift
//  WaterWorks
//
//  Created by Tom Dolson on 3/11/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 4,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}

// The code below is used to create a TextField using UITextField for multiple lines.

fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if nil != onDone {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
//        if uiView.window != nil, !uiView.isFirstResponder {
//            uiView.becomeFirstResponder()
//        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }

}

struct MultilineTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?

    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false

    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, onDone: onCommit)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}

struct ColorButton: View {
    var bgColor: Color = Color(.white)
    var fgColor: Color = Color(.black)
    var btnText = "Button Text Here"
    var btnWidth: Double = 100.00
    var body: some View {
        
        Button {
            // Procedure goes here.
            
            
        } label: {
            Text(btnText)
                .bold()
                .padding(.init(top: 2, leading: 2, bottom: 2, trailing: 2))
        }
        .frame(width: btnWidth)
        .foregroundColor(fgColor)
        .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
        .background(bgColor)
        .cornerRadius(5)
        .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
        .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 2))
    }
        
}


struct TestButton: ButtonStyle {
    var bgColor: Color = Color(.white)
    var fgColor: Color = Color(.black)
    var btnText = "Button Text Here"
    var btnWidth: Double = 100.00
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: btnWidth)
            .foregroundColor(fgColor)
            .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
            .background(bgColor)
            .cornerRadius(5)
            .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
            .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 2))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


#if DEBUG
struct MultilineTextField_Previews: PreviewProvider {
    static var test:String = ""//some very very very long description string to be initially wider than screen"
    static var testBinding = Binding<String>(get: { test }, set: {
//        print("New value: \($0)")
        test = $0 } )

    static var previews: some View {
        VStack(alignment: .leading) {
            Text("Description:")
            MultilineTextField("Enter some text here", text: testBinding, onCommit: {
                print("Final text: \(test)")
            })
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray).opacity(0.5))
            Text("Something static here...")
            
            
            
            ColorButton(bgColor: .yellow, fgColor: .black, btnText: "Salt")
            ColorButton(bgColor: .blue, fgColor: .white, btnText: "Service")
            ColorButton(bgColor: .green, fgColor: .white, btnText: "Details")
            ColorButton(bgColor: .purple, fgColor: .white, btnText: "Follow Up")
            
            
            Spacer()
            Button {
                print("Test Service Button")
            } label: {
                Text("Service")
            }
            .buttonStyle(TestButton(bgColor: .blue, fgColor: .white, btnText: "Service", btnWidth: 100.00))
            
        
        }
        .padding()
    }
}
#endif
