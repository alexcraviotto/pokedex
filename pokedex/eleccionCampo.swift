import SwiftUI

struct eleccionCampo: View {
    @Binding var pokemonsUsuario: [Pokemon2?]
    @State private var apiCalls = ApiCalls()

    var body: some View {
        VStack {
            Text("Elección de\ncampo de batalla\n")
                .font(.custom("Press Start 2P Regular", size: 24))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            // Botón de Hierba Alta
            Button(action: {
                print("Hierba alta seleccionada")
                // Cambiar la vista raíz programáticamente
                if let window = UIApplication.shared.windows.first {
                    let rootView = Combate(
                        pokemonsUsuario: pokemonsUsuario, campoBatalla: CamposBatalla.hierbaAlta)
                    window.rootViewController = UIHostingController(rootView: rootView)
                    window.makeKeyAndVisible()
                }
            }) {
                Image("seleccionarHierbaAlta")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Text("Hierba alta")
                            .font(.custom("Press Start 2P Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(),
                        alignment: .center
                    )
            }
            .padding()

            // Botón de Desierto
            Button(action: {
                print("Desierto seleccionado")
                // Cambiar la vista raíz programáticamente
                if let window = UIApplication.shared.windows.first {
                    let rootView = Combate(
                        pokemonsUsuario: pokemonsUsuario, campoBatalla: CamposBatalla.desierto)
                    window.rootViewController = UIHostingController(rootView: rootView)
                    window.makeKeyAndVisible()
                }
            }) {
                Image("seleccionarDesierto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Text("Desierto")
                            .font(.custom("Press Start 2P Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(),
                        alignment: .center
                    )
            }
            .padding()

            // Botón de Alto Mando
            Button(action: {
                print("Alto mando seleccionado")
                // Cambiar la vista raíz programáticamente
                if let window = UIApplication.shared.windows.first {
                    let rootView = Combate(
                        pokemonsUsuario: pokemonsUsuario, campoBatalla: CamposBatalla.altoMando)
                    window.rootViewController = UIHostingController(rootView: rootView)
                    window.makeKeyAndVisible()
                }
            }) {
                Image("seleccionarAltoMando")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Text("Alto mando")
                            .font(.custom("Press Start 2P Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(),
                        alignment: .center
                    )
            }
            .padding()
        }
        .onAppear {
            Task {
                await elegirPokemonsIA()
            }
        }
    }

    func elegirPokemonsIA() async {
        // Verificar si los 3 últimos Pokémon tienen ID = 0
        let ultimosPokemons = pokemonsUsuario.suffix(3)
        if ultimosPokemons.allSatisfy({ $0?.id == 0 }) {
            print("Generando Pokémon para la IA...")

            // Generar 3 IDs aleatorios
            let nuevosIDs = (1...3).map { _ in Int.random(in: 1...1000) }

            // Obtener los Pokémon por sus IDs
            var nuevosPokemons: [Pokemon2?] = []
            for id in nuevosIDs {
                if let nuevoPokemon = try? await apiCalls.pokemonPorId(id: id) {
                    nuevosPokemons.append(nuevoPokemon)
                } else {
                    print("Error al obtener el Pokémon con ID: \(id)")
                }
            }

            // Reemplazar los 3 últimos Pokémon en el array
            if nuevosPokemons.count == 3 {
                for (index, pokemon) in nuevosPokemons.enumerated() {
                    pokemonsUsuario[pokemonsUsuario.count - 3 + index] = pokemon
                }
                print("Pokémon generados y asignados correctamente.")
            } else {
                print("Error: No se pudieron generar todos los Pokémon.")
            }
        } else {
            print("Los Pokémon de la IA ya están asignados.")
        }
    }
}
