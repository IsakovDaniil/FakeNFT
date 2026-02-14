import SwiftUI

struct NftDetailBridgeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = NftDetailViewController

    let nftId: String

    @Environment(ServicesAssembly.self) var servicesAssembly

    func makeUIViewController(context: Context) -> NftDetailViewController {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftInput = NftDetailInput(id: nftId)
        guard let nftViewController = assembly.build(with: nftInput) as? NftDetailViewController else {
            fatalError("NftDetailAssembly.build() вернул не NftDetailViewController")
        }
        return nftViewController
    }

    func updateUIViewController(_ uiViewController: NftDetailViewController, context: Context) {
        // Обновляет состояние указанного контроллера представления новой информацией из SwiftUI.
    }
}
