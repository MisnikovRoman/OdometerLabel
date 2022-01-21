import SwiftUI

struct TestRepeat: View {
    let isMoved: Bool
    var body: some View {
        Text("Hello, World!1")
            .offset(x: 0, y: isMoved ? 100 : 0)
            .animation(animation, value: isMoved)
    }
    
    let animation = Animation.linear(duration: 3.0).repeatCount(4)
}

struct TestRepeat_Previews: PreviewProvider {
    
    struct Screen: View {
        @State var isMoved = false
        
        var body: some View {
            VStack {
                TestRepeat(isMoved: isMoved)
                Button("move") { isMoved.toggle() }
            }
        }
    }
    
    static var previews: some View {
        Screen()
    }
}
