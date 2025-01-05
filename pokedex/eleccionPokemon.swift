import SwiftUI

struct eleccionPokemon: View {
    @Environment(\.presentationMode) var presentationMode
    @State var contrincante: Bool
    @State private var pokemonsUsuario: [Pokemon2?] = Array(repeating: nil, count: 6)  // Inicializa con nil

    // Asegúrate de que pokemonActual tenga un ID inválido por defecto
    var pokemonActual: Pokemon2 = Pokemon2(
        id: -1,  // ID inválido por defecto
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
            .offset(y: -170)

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

    @ViewBuilder
    private func pokemonRow(startIndex: Int, endIndex: Int) -> some View {
        ForEach(startIndex..<endIndex, id: \.self) { hueco in
            if let pokemon = pokemonsUsuario[hueco] {
                // Si hay un Pokémon en este hueco, mostrarlo
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
            } else {
                // Si el hueco está vacío, mostrar un botón para seleccionar un Pokémon
                NavigationLink(
                    destination: VistaBusquedaElegir(onPokemonSelected: { selectedPokemon in
                        print("Pokemon seleccionado: \(selectedPokemon.name)")
                        print("Hueco: \(hueco)")
                        pokemonsUsuario[hueco] = selectedPokemon  // Asigna el Pokémon al hueco correspondiente
                    })
                ) {
                    Image("PulsaParaElegir")
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
                .buttonStyle(PlainButtonStyle())  // Evita estilos no deseados
            }
        }
    }

    private func handleOnAppear() {
   
        // Solo asigna el Pokémon actual si tiene un ID válido
        print("ID del Pokémon actual: \(pokemonActual.id)")
        if pokemonActual.id != -1 && pokemonActual.id != 0 {  // Evita asignar si el ID es 0
            if let index = pokemonsUsuario.firstIndex(where: { $0 == nil }) {
                pokemonsUsuario[index] = pokemonActual

            }
        }

        // Si no es el contrincante, asigna Pokémon de reemplazo
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

        // Depuración: Imprime el estado de los Pokémon
        for pokemon in pokemonsUsuario {
            print(pokemon?.name ?? "nil")
        }
    }
}
