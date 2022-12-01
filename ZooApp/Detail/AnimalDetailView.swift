import SwiftUI
import Combine

final class AnimalDetailViewModel: ObservableObject {
    enum UserInteraction: Hashable {
        case animalRecommendationsButtonTapped
    }

    enum SceneEvent: Hashable {
        case sceneAppeared
        case sceneDisappeared
    }

    enum UserInterfaceEvent: Hashable {
        case sceneEvent(SceneEvent)
        case userInteraction(UserInteraction)
    }

    @Published var state: State<Animal>

    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(animal: Animal, navigationPath: Binding<NavigationPath>) {
        self.state = .init(navigationPath: navigationPath, element: animal)

        eventSubject
            .print("## \(Self.self).\(#function)")
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
        try? state.update { state in
            state.navigationPath.append(interaction)
        }
    }

    func handleSceneEvent(_ sceneEvent: SceneEvent) {
        // nothing
    }
}

struct AnimalDetailView: View {

    @StateObject var viewModel: AnimalDetailViewModel

    var recommendationButton: some View {
        Button {
            viewModel.eventSubject.send(.userInteraction(.animalRecommendationsButtonTapped))
        } label: {
            Text("Other animals you may like")
        }
        .buttonStyle(.bordered)
        .padding()
    }

    var body: some View {
        ScrollView {
            VStack {
                Text(viewModel.state.element.icon)
                    .font(.system(size: 250))
                    .padding()
                
                Spacer()

                recommendationButton
            }
            .navigationDestination(for: AnimalDetailViewModel.UserInteraction.self) {
                // FIXME: Get view from environment
                Text(String(describing: $0))
            }
        }
        .onAppear { viewModel.eventSubject.send(.sceneEvent(.sceneAppeared)) }
        .onDisappear { viewModel.eventSubject.send(.sceneEvent(.sceneDisappeared)) }
        .navigationBarTitle(viewModel.state.element.name)
    }
}

struct AnimalDetailView_Previews: PreviewProvider {
    @ObservedObject private static var navigator: Navigator = .init()

    static var previews: some View {
        TabView {
            NavigationStack(path: $navigator.navigationPath) {
                AnimalDetailView(viewModel: .init(animal: .makeRandomAnimal(), navigationPath: $navigator.navigationPath))
            }
            .tabItem {
                Label { Text("Detail") } icon: { Image(systemName: "circle") }
            }
        }
    }
}
