import SwiftUI

struct ContentView: View {
    let servicesAssembly: ServicesAssembly

    var body: some View {
        TabBarView(servicesAssembly: servicesAssembly)
    }
}
