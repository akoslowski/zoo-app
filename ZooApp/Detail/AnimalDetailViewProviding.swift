import SwiftUI

extension AnimalDetailView {
    struct Builder {
        // Note:
        // Dependencies can be stored here in order to create an `AnimalDetailView`

        @MainActor func callAsFunction(animal: Animal, navigationPath: Binding<NavigationPath>) -> some View {
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
    /**
     Example usage:

     ```
     .modifier(
        AnimalDetailView.NavigationDestination(
            navigationPath: $viewModel.state.navigationPath
        )
     )
     ```

     - Notes:
     - How does the interface communicate which type is required to be appended to the ``navigationPath`` for this modifier to take effect?
     - The type has to be known to the caller to be able to append it to the ``navigationPath``.
     */
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

extension View {
    /**
     Example usage:

     ```
     .addAnimalDetailViewNavigationDestination(
        navigationPath: $viewModel.state.navigationPath
     )
     ```
     */
    func addAnimalDetailViewNavigationDestination(navigationPath: Binding<NavigationPath>) -> some View {
        modifier(AnimalDetailView.NavigationDestination(navigationPath: navigationPath))
    }
}
