import Foundation
import class Combine.AnyCancellable
import class Combine.PassthroughSubject
import struct Combine.Published
import struct SwiftUI.Binding
import protocol SwiftUI.ObservableObject
import struct SwiftUI.NavigationPath

final class AnimalListViewModel: ObservableObject {

    enum UserInteraction: Hashable {
        case animalViewTapped(Animal)
        case refreshRequested
    }

    enum SceneEvent: Hashable {
        case sceneAppeared
        case sceneDisappeared
    }

    enum UserInterfaceEvent: Hashable {
        case sceneEvent(SceneEvent)
        case userInteraction(UserInteraction)
    }

    @Published var state: SceneState<[Animal]>

    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(navigationPath: Binding<NavigationPath>) {
        state = .init(
            navigationPath: navigationPath,
            value: []
        )

        eventSubject
            .print("# \(Self.self)")
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
        switch interaction {
        case .animalViewTapped(let animal):
            state.update {
                $0.navigationPath.append(animal)
            }

        case .refreshRequested:
            state.update {
                $0.navigationPath.removeLast($0.navigationPath.count)
                $0.value = Animal.makeRandomAnimals()
            }
        }
    }

    func handleSceneEvent(_ sceneEvent: SceneEvent) {
        switch sceneEvent {
        case .sceneAppeared:
            state.update {
                $0.value = Animal.makeRandomAnimals()
            }

        case .sceneDisappeared:
            break
        }
    }
}
