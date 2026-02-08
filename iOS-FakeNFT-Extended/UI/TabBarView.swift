import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            CartScreen()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .backgroundStyle(.background)
        }
    }
}

#Preview {
    TabBarView()
}
