import SwiftUI

extension AnimalDetailView {
    struct Builder {
        // Note:
        // Dependencies can be stored here in order to create an `AnimalDetailView`

        func callAsFunction(animal: Animal, navigationPath: Binding<NavigationPath>) -> some View {
            AnimalDetailView(viewModel: .init(animal: animal, navigationPath: navigationPath))
        }

        static func mock() -> Self {
            .init()
        }
    }
}

fileprivate extension AnimalDetailView.Builder {
    struct Key: EnvironmentKey {
        // FIXME: Optional `AnimalDetailViewProvider?` does not work, the call as a function cannot be called.
        static let defaultValue: AnimalDetailView.Builder = .mock()
    }
}

extension EnvironmentValues {
    var detailView: AnimalDetailView.Builder {
        get { self[AnimalDetailView.Builder.Key.self] }
        set { self[AnimalDetailView.Builder.Key.self] = newValue }
    }
}

extension AnimalDetailView {
    struct NavigationDestination: ViewModifier {
        /// Function from the environment to create an ``AnimalDetailView``
        @Environment(\.detailView) var detailView
        
        let navigationPath: Binding<NavigationPath>
        
        func body(content: Content) -> some View {
            content
                .navigationDestination(
                    for: Animal.self,
                    destination: { animal in
                        detailView(animal: animal, navigationPath: navigationPath)
                    }
                )
        }
    }
}
