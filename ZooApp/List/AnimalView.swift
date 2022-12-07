import SwiftUI

struct AnimalView: View {
    let animal: Animal

    var body: some View {
        Label(title: {
            Text(animal.name).font(.largeTitle)
        }, icon: {
            Text(animal.icon).font(.title)
        })
        .padding()
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

struct AnimalView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalView(animal: .makeRandomAnimal())
            .border(Color.red)
    }
}
