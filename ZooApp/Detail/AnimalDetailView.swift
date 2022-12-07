import SwiftUI

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
                Text(viewModel.state.value.icon)
                    .font(.system(size: 250))
                    .padding()
                
                Spacer()

                if viewModel.shouldShowRecommendationButton {
                    recommendationButton
                }
            }
            .addRecommendationListViewNavigationDestination(
                navigationPath: $viewModel.state.navigationPath
            )
        }
        .onAppear { viewModel.eventSubject.send(.sceneEvent(.sceneAppeared)) }
        .onDisappear { viewModel.eventSubject.send(.sceneEvent(.sceneDisappeared)) }
        .navigationBarTitle(viewModel.state.value.name)
    }
}

struct AnimalDetailView_Previews: PreviewProvider {
    @ObservedObject private static var navigator: Navigator = .init()

    static var previews: some View {
        TabView {
            NavigationStack(path: $navigator.navigationPath) {
                AnimalDetailView(viewModel: .init(animal: .makeRandomAnimal(), navigationPath: $navigator.navigationPath))
            }
            .environmentObject(navigator)
            .tabItem {
                Label { Text("Detail") } icon: { Image(systemName: "circle") }
            }
        }
    }
}
