import SwiftUI
import Combine

final class AnimalDetailViewModel: ObservableObject {

    enum UserInterfaceEvent {
        case animalsYouMayLikeTapped
    }

    @Published var state: State<Animal>

    let eventSubject = PassthroughSubject<UserInterfaceEvent, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(animal: Animal, navigationPath: Binding<NavigationPath>) {
        self.state = .init(navigationPath: navigationPath, element: animal)

        eventSubject
            .sink { print("DetailViewModel:received: \($0)") }
            .store(in: &subscriptions)

        eventSubject
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &subscriptions)
    }

    func handleEvent(_ event: UserInterfaceEvent) {
        try? state.update { state in
            state.navigationPath.append(event)
        }
    }
}

struct AnimalDetailView: View {

    @StateObject var viewModel: AnimalDetailViewModel

    var body: some View {
        ScrollView {
            VStack {
                Text(viewModel.state.element.icon)
                    .font(.system(size: 300))
                    .padding()
                
                Spacer()
                
                Button {
                    viewModel.eventSubject.send(.animalsYouMayLikeTapped)
                } label: {
                    Text("Other animals you may like")
                }
                .buttonStyle(.bordered)
                .padding()
            }
            .navigationDestination(for: AnimalDetailViewModel.UserInterfaceEvent.self) {
                Text(String(describing: $0))
            }
        }
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
