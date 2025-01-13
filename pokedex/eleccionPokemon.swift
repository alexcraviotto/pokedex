import SwiftUI

struct PokebolaGiratoriaView: View {
    @State private var isRotating = false
    @State private var isScaling = false

    var body: some View {
        ZStack {
            // Fondo blanco circular
            Circle()
                .fill(Color.white)
                .frame(width: 50, height: 50)

            // Parte superior roja
            Circle()
                .trim(from: 0, to: 0.5)
                .fill(Color.red)
                .frame(width: 50, height: 50)

            // Línea central
            Rectangle()
                .fill(Color.black)
                .frame(width: 50, height: 4)

            // Círculo central
            Circle()
                .fill(Color.white)
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 3)
                )
        }
        .frame(width: 50, height: 50)
        .rotationEffect(.degrees(isRotating ? 360 : 0))
        .scaleEffect(isScaling ? 1.1 : 0.9)
        .animation(
            Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)
                .repeatForever(autoreverses: true),
            value: isScaling
        )
        .animation(
            Animation.linear(duration: 1.0)
                .repeatForever(autoreverses: false),
            value: isRotating
        )
        .onAppear {
            isRotating = true
            isScaling = true
        }
    }
}

struct eleccionPokemon: View {
    @Environment(\.presentationMode) var presentationMode
    @State var contrincante: Bool
    @State private var apiCalls = ApiCalls()

    @State private var pokemonsUsuario: [Pokemon2?] = Array(repeating: nil, count: 6)
    var pokemonActual: Pokemon2

    @State private var showAlert = false
    @State private var loadingEnemyPokemons = false
    @State private var loadingOpacity = 0.0

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        // Acción para volver atrás
                        if let window = UIApplication.shared.windows.first {
                            let rootView = vistaMenu()
                            window.rootViewController = UIHostingController(rootView: rootView)
                            window.makeKeyAndVisible()
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                            Text("Atrás")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, 20)

                VStack {
                    Text("Elección")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black)
                    Text("de equipos")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black)
                }
                .padding(.top, 20)
                .padding(.bottom, 80)

                HStack {
                    pokemonRow(startIndex: 0, endIndex: 3)
                }
                .padding()

                Text("VS")
                    .font(.custom("Press Start 2P Regular", size: 24))
                    .foregroundColor(.black)
                    .padding()

                HStack {
                    pokemonRow(startIndex: 3, endIndex: 6)
                }
                .padding()

                Spacer()

                if !contrincante {
                    Button(action: elegirAleatorios) {
                        Text("Elegir aleatorios")
                            .font(.custom("Press Start 2P Regular", size: 12))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }

                HStack {
                    Button(action: resetPokemons) {
                        Text("Reset")
                            .font(.custom("Press Start 2P Regular", size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.leading, 20)

                    Spacer()

                    Button(action: {
                        var empty = 0
                        for i in 0..<3 {
                            if pokemonsUsuario[i]?.name == nil {
                                empty += 1
                            }
                        }
                        if empty >= 3 {
                            showAlert = true
                        } else {
                            if let window = UIApplication.shared.windows.first {
                                let rootView = eleccionCampo(pokemonsUsuario: $pokemonsUsuario)
                                window.rootViewController = UIHostingController(
                                    rootView: rootView)
                                window.makeKeyAndVisible()
                            }
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Debes elegir al menos 3 Pokémon"),
                dismissButton: .default(Text("OK")))
        }
        .onAppear {
            handleOnAppear()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private func pokemonRow(startIndex: Int, endIndex: Int) -> some View {
        ForEach(startIndex..<endIndex, id: \.self) { hueco in
            if let pokemon = pokemonsUsuario[hueco] {
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
                if loadingEnemyPokemons && hueco >= 3 && !contrincante {
                    Color.gray.opacity(0.2)
                        .frame(width: 90, height: 90)
                        .cornerRadius(10)
                        .overlay(
                            PokebolaGiratoriaView()
                                .scaleEffect(0.8)
                        )
                } else {
                    NavigationLink(
                        destination: VistaBusquedaElegir(onPokemonSelected: { selectedPokemon in
                            pokemonsUsuario[hueco] = selectedPokemon
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
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private func handleOnAppear() {
        if pokemonActual.id != -1 && pokemonActual.id != 0 {
            if let index = pokemonsUsuario.firstIndex(where: { $0 == nil }) {
                pokemonsUsuario[index] = pokemonActual
            }
        }

        if !contrincante && pokemonsUsuario[3..<6].allSatisfy({ $0 == nil }) {
            elegirAleatorios()
        }
    }

    private func resetPokemons() {
        for index in 0..<(contrincante ? 6 : 3) {
            pokemonsUsuario[index] = nil
        }
    }

    private func elegirAleatorios() {
        let pokemonIds = (1...1025).shuffled().prefix(3)
        let group = DispatchGroup()
        var randomPokemons: [Pokemon2?] = []

        loadingEnemyPokemons = true

        for id in pokemonIds {
            group.enter()
            Task {
                do {
                    let pokemon = await apiCalls.pokemonPorId(id: id)
                    randomPokemons.append(pokemon)
                } catch {
                    print("Error al obtener Pokémon aleatorio: \(error)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            for (index, pokemon) in randomPokemons.enumerated() {
                if 3 + index < pokemonsUsuario.count {
                    pokemonsUsuario[3 + index] = pokemon
                }
            }
            loadingEnemyPokemons = false
        }
    }
}
