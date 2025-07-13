//  RemoteImageView.swift
import SwiftUI

struct RemoteImageView: View {
    var url: String
    var placeholder: Image = Image(systemName: "1.circle")
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 115, height: 230)
                    .pinchToZoom()
            case .empty:
                placeholder
                    .resizable()
                    .frame(width: 115, height: 230)
            case .failure:
                placeholder
                    .resizable()
                    .frame(width: 115, height: 230)
            @unknown default:
                EmptyView()
            }
        }

    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(url: "http://www.pureandsoftwater.com/manager/installation_pics/1063_1.jpg")
    }
}

// --------------------------------------------------------------
//  PinchToZoom.swift
import SwiftUI

struct PinchToZoom: ViewModifier {
    @State var scale: CGFloat = 1.0
    @GestureState var isPinching: Bool = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .gesture(MagnificationGesture().updating($isPinching) { (currentState, gestureState, _) in
                gestureState = true
                withAnimation(.none) {
                    scale = currentState
                }
            }.onEnded { finalScale in
                withAnimation(.spring()) {
                    scale = finalScale
                }
            })
    }
}
extension View {
    func pinchToZoom() -> some View {
        self.modifier(PinchToZoom())
    }
}
