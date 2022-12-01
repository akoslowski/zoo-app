import Foundation
import SwiftUI

struct DetailViewProvider {
    let dependencies: [Int]

    func callAsFunction(animal: Animal, navigationPath: Binding<NavigationPath>) -> some View {
        DetailView(viewModel: .init(animal: animal, navigationPath: navigationPath))
    }

    static func mock() -> Self {
        .init(dependencies: [1,2,4])
    }
}

private struct DetailViewProviderKey: EnvironmentKey {
    // FIXME: Optional `DetailViewProvider?` does not work, the call as a function cannot be called.
    static let defaultValue: DetailViewProvider = .mock()
}

extension EnvironmentValues {
    var detailView: DetailViewProvider {
        get { self[DetailViewProviderKey.self] }
        set { self[DetailViewProviderKey.self] = newValue }
    }
}




//extension View {
//    @ViewBuilder func navigationLink(to externalDestination: ExternalDestination) -> some View {
//        modifier(NavigationModifier(destination: externalDestination))
//    }
//
//    @ViewBuilder func navigationDestination(externalDestination: ExternalDestination) -> some View {
//        modifier(NavigationModifier(destination: externalDestination))
//    }
//}


extension View {
    @ViewBuilder func navigationLink(destination: @escaping () -> some View) -> some View {
        NavigationLink {
            destination()
        } label: {
            self
        }
    }

    func navigationDestination<Destination: View>(destination: @escaping () -> Destination) -> some View {
        NavigationLink {
            destination()
        } label: {
            self
        }
    }
}
