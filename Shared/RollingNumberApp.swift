import SwiftUI

@main
struct RollingNumberApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                RollingNumberLabelTestScreen()
                    .tabItem { Label("Numbers", systemImage: "123.rectangle")}
                OneNumberAnimationTestView()
                    .tabItem { Label("Debug", systemImage: "7.square") }
            }
        }
    }
}
