import SwiftUI

struct TabBarView: View {
    let assembly: ServicesAssembly

    var body: some View {
        TabView {
            CatalogView(assembly: assembly)
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
