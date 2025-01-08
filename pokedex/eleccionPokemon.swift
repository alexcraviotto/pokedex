import SwiftUI

struct eleccionPokemon: View {
    @Environment(\.presentationMode) var presentationMode
    @State var contrincante: Bool

    // Estado para almacenar los Pokémon del usuario
    @State private var pokemonsUsuario: [Pokemon2?] = Array(repeating: nil, count: 6)  // Inicializa con nil

    // Pokémon actual
    var pokemonActual: Pokemon2

    @State private var showAlert = false

    var body: some View {
        ZStack {
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
                .padding(.top, 20)  // Asegura espacio superior
                .padding(.bottom, 80)  // Asegura espacio inferior

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

                Spacer()
            }

            // Botones "Reset" y navegación a "eleccionCampo"
            VStack {
                Spacer()
                HStack {
                    Button(action: resetPokemons) {
                        Text("Reset")
                            .font(.custom("Press Start 2P Regular", size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.leading, 20)

                    Button(action: {
                        // Comprueba si hay mas de tres pokemons con el nombre empty

                        var empty = 0
                        for i in 0..<3 {
                            print(pokemonsUsuario[i]?.name)
                            if pokemonsUsuario[i]?.name == nil {
                                print("empty")
                                empty += 1
                            }
                        }
                        if empty >= 3 {
                            let alert = UIAlertController(
                                title: "Error", message: "Debes elegir al menos 3 pokemons",
                                preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            UIApplication.shared.windows.first?.rootViewController?.present(
                                alert, animated: true)

                        } else {
                            if let window = UIApplication.shared.windows.first {
                                let rootView = eleccionCampo(pokemonsUsuario: $pokemonsUsuario)
                                window.rootViewController = UIHostingController(rootView: rootView)
                                window.makeKeyAndVisible()
                            }
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .offset(x: 170)

                    Spacer()
                }
                .offset(y: -60)
                .padding(.bottom, 40)  // Asegura espacio en la parte inferior
            }
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
    }

    private func resetPokemons() {
        let defaultPokemon = Pokemon2(
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

        if contrincante {
            // Resetea los 6 Pokémon
            for index in 0..<6 {
                pokemonsUsuario[index] = nil
            }
        } else {
            // Resetea solo los primeros 3 Pokémon
            for index in 0..<3 {
                pokemonsUsuario[index] = nil
            }
        }
    }
}
