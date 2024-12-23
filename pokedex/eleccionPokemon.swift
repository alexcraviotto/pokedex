import SwiftUI

struct eleccionPokemon: View {
    @Environment(\.presentationMode) var presentationMode
    @State var contrincante: Bool
    @State private var pokemonsUsuario: [(Int, Pokemon2)] = []
    @State private var pokemonsRival: [(Int, Pokemon2)] = []
    var pokemonActual: Pokemon2
    var huecoARellenar: Int = -1
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                // Primera fila de NavigationLinks (antes de "VS")
                HStack {
                    ForEach(0..<3) { hueco in
                        // Verificamos si el hueco está ocupado en pokemonsUsuario
                        if let pokemon = pokemonsUsuario.first(where: { $0.0 == hueco }) {
                            // Si el hueco está ocupado, mostrar la imagen del Pokémon
                            pokemon.1.image
                                .renderingMode(.original)
                                .scaleEffect(0.5)
                                .frame(width: 90, height: 90)
                                .padding()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 2)
                                ).shadow(radius: 10)
                        } else {
                            // Si el hueco no está ocupado, mostrar el NavigationLink para elegir Pokémon
                            NavigationLink(destination: VistaBusquedaElegir(huecoARellenar: hueco, contrincante: $contrincante)) {
                                VStack(spacing: 20) {
                                    Image("Mewtwo")
                                        .renderingMode(.original)
                                        .scaleEffect(0.5)
                                }
                                .frame(width: 90, height: 90)
                            }
                            .padding()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2)
                            ).shadow(radius: 10)
                        }
                    }
                }
                .padding()

                Text("VS")
                    .font(.custom("Press Start 2P Regular", size: 24))
                    .foregroundColor(.black)
                    .padding()

                // Segunda fila de NavigationLinks con comportamiento diferente según 'contrincante'
                HStack {
                    if contrincante {
                        // Si contrincante es true, verificar los huecos de forma similar
                        ForEach(3..<6) { hueco in
                            // Verificamos si el hueco está ocupado en pokemonsRival
                            if let pokemon = pokemonsRival.first(where: { $0.0 == hueco }) {
                                // Si el hueco está ocupado, mostrar la imagen del Pokémon
                                pokemon.1.image
                                    .renderingMode(.original)
                                    .scaleEffect(0.5)
                                    .frame(width: 90, height: 90)
                                    .padding()
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 2)
                                    )
                                    .shadow(radius: 10)
                            } else {
                                // Si el hueco no está ocupado, navegar a la vista de elección
                                NavigationLink(destination: VistaBusquedaElegir(huecoARellenar: hueco, contrincante: $contrincante)) {
                                    VStack(spacing: 20) {
                                        Image("Mewtwo")
                                            .renderingMode(.original)
                                            .scaleEffect(0.5)
                                    }
                                    .frame(width: 90, height: 90)
                                }
                                .padding()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                                .shadow(radius: 10)
                            }
                        }
                    } else {
                        // Si contrincante es false, mostrar alertas en lugar de navegar
                        ForEach(3..<6) { _ in
                            Button(action: {
                                showAlert = true
                            }) {
                                VStack(spacing: 20) {
                                    Image("Mewtwo")
                                        .renderingMode(.original)
                                        .scaleEffect(0.5)
                                }
                                .frame(width: 90, height: 90)
                            }
                            .padding()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                            .shadow(radius: 10)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("¡Atención!"), message: Text("Los pokemons se eligen de forma aleatoria!"), dismissButton: .default(Text("OK")))
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Elección")
                                .font(.custom("Press Start 2P Regular", size: 24))
                                .foregroundColor(.black)
                            Text("de equipos")
                                .font(.custom("Press Start 2P Regular", size: 24))
                                .foregroundColor(.black)
                        }
                        .padding(.top)
                    }
                }
            }
        }
    }
}

#Preview {
    eleccionPokemon(contrincante: true,
                    pokemonActual: Pokemon2(
                        id: 1,
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
                    ), huecoARellenar: 1
                )
}
