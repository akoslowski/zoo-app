import class Combine.AnyCancellable
import class Combine.PassthroughSubject
import struct Combine.Published
import struct SwiftUI.Binding
import protocol SwiftUI.ObservableObject
import struct SwiftUI.NavigationPath

final class AnimalDetailViewModel: ObservableObject {

    enum UserInteraction: Hashable {
        case animalRecommendationsButtonTapped
    }

    enum SceneEvent: Hashable {
        case sceneAppeared
        case sceneDisappeared
        case sceneDestroyed
    }

    enum UserInterfaceEvent: Hashable {
        case sceneEvent(SceneEvent)
        case userInteraction(UserInteraction)
    }

    deinit {
        eventSubject.send(.sceneEvent(.sceneDestroyed))
    }

    @Published var state: SceneState<Animal>
    var shouldShowRecommendationButton: Bool

    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(animal: Animal, shouldShowRecommendationButton: Bool = true, navigationPath: Binding<NavigationPath>) {
        self.state = .init(navigationPath: navigationPath, value: animal)
        self.shouldShowRecommendationButton = shouldShowRecommendationButton

        eventSubject
            .print("## \(Self.self)")
            .sink { _ in /* do tracking maybe */}
            .store(in: &subscriptions)

        eventSubject
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &subscriptions)
    }

    func handleEvent(_ event: UserInterfaceEvent) {
        switch event {
        case .sceneEvent(let sceneEvent):
            handleSceneEvent(sceneEvent)

        case .userInteraction(let interaction):
            handleInteraction(interaction)
        }
    }

    func handleInteraction(_ interaction: UserInteraction) {
        guard case .animalRecommendationsButtonTapped = interaction else { return }
        state.update { state in
            state.navigationPath.append(RecommendationListView.NavigationDestination.Path())
        }
    }

    func handleSceneEvent(_ sceneEvent: SceneEvent) {
        // nothing
    }
}
