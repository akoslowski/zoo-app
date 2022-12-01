import SwiftUI
import Combine

final class DetailViewModel: ObservableObject {

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

struct DetailView: View {

    @StateObject var viewModel: DetailViewModel

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
            .navigationDestination(for: DetailViewModel.UserInterfaceEvent.self) {
                Text(String(describing: $0))
            }
        }
        .navigationBarTitle(viewModel.state.element.name)
    }
}


struct DetailView_Previews: PreviewProvider {
    @ObservedObject private static var navigator: Navigator = .init()

    static var previews: some View {
        TabView {
            NavigationStack(path: $navigator.navigationPath) {
                DetailView(viewModel: .init(animal: .makeRandomAnimal(), navigationPath: $navigator.navigationPath))
            }
            .tabItem {
                Label { Text("Detail") } icon: { Image(systemName: "circle") }
            }
        }
    }
}
