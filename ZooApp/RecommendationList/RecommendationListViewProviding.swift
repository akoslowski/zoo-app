import SwiftUI

extension RecommendationListView {
    struct Builder {
        // Note:
        // Dependencies can be stored here in order to create an `AnimalDetailView`

        @MainActor func callAsFunction(navigationPath: Binding<NavigationPath>) -> some View {
            RecommendationListView()
        }

        static func mock() -> Self {
            .init()
        }
    }
}

fileprivate extension RecommendationListView.Builder {
    struct Key: EnvironmentKey {
        static let defaultValue: RecommendationListView.Builder = .mock()
    }
}

extension EnvironmentValues {
    var recommendationListView: RecommendationListView.Builder {
        get { self[RecommendationListView.Builder.Key.self] }
        set { self[RecommendationListView.Builder.Key.self] = newValue }
    }
}

extension RecommendationListView {
    /**
     Example usage:

     ```
     .modifier(
        RecommendationListView.NavigationDestination(
            navigationPath: $viewModel.state.navigationPath
        )
     )
     ```
     */
    struct NavigationDestination: ViewModifier {

        /// Append an instance of ``Path`` to navigationPath to open a ``RecommendationListView``
        struct Path: Hashable {}


        /// Function from the environment to create an ``AnimalDetailView``
        @Environment(\.recommendationListView) var recommendationListView

        let navigationPath: Binding<NavigationPath>

        func body(content: Content) -> some View {
            content
                .navigationDestination(
                    for: Path.self,
                    destination: { animal in
                        recommendationListView(navigationPath: navigationPath)
                    }
                )
        }
    }
}

extension View {
    /**
     Example usage:

     ```
     .addRecommendationListViewNavigationDestination(
        navigationPath: $viewModel.state.navigationPath
     )
     ```
     */
    func addRecommendationListViewNavigationDestination(navigationPath: Binding<NavigationPath>) -> some View {
        modifier(RecommendationListView.NavigationDestination(navigationPath: navigationPath))
    }
}
