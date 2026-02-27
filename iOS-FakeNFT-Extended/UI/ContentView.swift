import SwiftUI

struct ContentView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly

    var body: some View {
        TabBarView(servicesAssembly: servicesAssembly)
    }
}
