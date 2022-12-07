import SwiftUI
import Combine

final class Navigator: ObservableObject {
    @Published var navigationPath: NavigationPath

    private var subscriptions: Set<AnyCancellable> = .init()

    init(navigationPath: NavigationPath = .init()) {
        self.navigationPath = navigationPath

        $navigationPath
            .print("# \(Self.self).navigationPath")
            .sink { _ in }
            .store(in: &subscriptions)
    }
}
