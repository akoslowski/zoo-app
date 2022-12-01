import SwiftUI

final class Navigator: ObservableObject {
    @Published var navigationPath: NavigationPath

    init(navigationPath: NavigationPath = .init()) {
        self.navigationPath = navigationPath
    }
}
