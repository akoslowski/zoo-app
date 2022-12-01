import SwiftUI

struct AnimalView: View {
    let animal: Animal

    var body: some View {
        Label(title: {
            Text(animal.name).font(.largeTitle)
        }, icon: {
            Text(animal.icon).font(.system(size: 70))
        })
        .padding(.vertical)
    }
}

struct AnimalView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalView(animal: .makeRandomAnimal())
    }
}
