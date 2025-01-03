import SwiftUI

struct eleccionPokemon: View {
    @Environment(\.presentationMode) var presentationMode
    @State var contrincante: Bool
    @State private var pokemonsUsuario: [Pokemon2?] = Array(repeating: Pokemon2(
        id: 0,
        name: "",
        description: "",
        types: [],
        weakTypes: [],
        weight: 0.0,
        height: 0.0,
        stats: [:],
        image: Image("PulsaParaElegir"),
        image_shiny: Image(""),
        evolution_chain_id: 0
    ), count: 6)
    
    var pokemonActual: Pokemon2 = Pokemon2(
        id: -1,
        name: "",
        description: "",
        types: [],
        weakTypes: [],
        weight: 0.0,
        height: 0.0,
        stats: [:],
        image: Image("PulsaParaElegir"),
        image_shiny: Image(""),
        evolution_chain_id: 0
    )
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Título principal
                VStack {
                    Text("Elección")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black)
                    Text("de equipos")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black)
                }
                .offset(y : -170)

                // Primera fila de Pokémon
                HStack {
                    pokemonRow(startIndex: 0, endIndex: 3)
                }
                .padding()
                
                Text("VS")
                    .font(.custom("Press Start 2P Regular", size: 24))
                    .foregroundColor(.black)
                    .padding()
                
                // Segunda fila de Pokémon
                HStack {
                    pokemonRow(startIndex: 3, endIndex: 6)
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                handleOnAppear()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Ocultar el botón "Back"
                    EmptyView()
                }
            }
        }
    }
    
    @ViewBuilder
    private func pokemonRow(startIndex: Int, endIndex: Int) -> some View {
        ForEach(startIndex..<endIndex, id: \.self) { hueco in
            if let pokemon = pokemonsUsuario[hueco] {
                NavigationLink(
                    destination: VistaBusquedaElegir()
                ) {
                    pokemon.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .shadow(radius: 10)
                }
            }
        }
    }
    
    private func handleOnAppear() {
        if pokemonActual.id != -1 {
            for index in 0..<pokemonsUsuario.count {
                if let pokemon = pokemonsUsuario[index], pokemon.image == Image("PulsaParaElegir") {
                    pokemonsUsuario[index] = pokemonActual
                    break
                }
            }
        }
        if !contrincante {
            let replacementPokemon = Pokemon2(
                id: 0,
                name: "",
                description: "",
                types: [],
                weakTypes: [],
                weight: 0.0,
                height: 0.0,
                stats: [:],
                image: Image("Zekrom"),
                image_shiny: Image(""),
                evolution_chain_id: 0
            )
            for index in 3..<6 {
                pokemonsUsuario[index] = replacementPokemon
            }
        }
    }
}


struct eleccionPokemon_Preview: PreviewProvider {
    static var previews: some View {
        eleccionPokemon(contrincante: false,
                        pokemonActual: Pokemon2(
                            id: -1,
                            name: "Pikachu",
                            description: "Pikachu es un Pokémon de tipo Eléctrico, conocido por ser el compañero de Ash Ketchum en la serie de anime.",
                            types: ["Electric"],
                            weakTypes: ["Ground"],
                            weight: 6.0,
                            height: 0.4,
                            stats: [
                                "HP": 35,
                                "Attack": 55,
                                "Defense": 40,
                                "Special Attack": 50,
                                "Special Defense": 50,
                                "Speed": 90
                            ],
                            image: Image("Zekrom"),
                            image_shiny: Image("Pikachu_shiny"),
                            evolution_chain_id: 1
                        )
        )
    }
}
