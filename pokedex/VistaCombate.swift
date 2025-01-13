import SwiftUI

struct VistaCombate: View {
    @State private var contrincante: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // Título alineado a la izquierda
                HStack {
                    Text("Combate")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black)
                        .padding(.leading)
                        .padding(.bottom, 30)

                    Spacer()
                }
                .padding(.top)

                // Contenedor principal con centering y spacing reducido
                VStack(spacing: 20) {
                    NavigationLink(
                        destination: eleccionPokemon(
                            contrincante: false,
                            pokemonActual: Pokemon2(
                                id: 0,
                                name: "Mewtwo",
                                description: "Un Pokémon legendario.",
                                types: ["Psíquico"],
                                weakTypes: ["Bicho", "Fantasma"],
                                weight: 122.0,
                                height: 2.0,
                                stats: ["Ataque": 110, "Defensa": 90],
                                image: Image("Mewtwo"),
                                image_shiny: Image("MewtwoShiny"),
                                evolution_chain_id: 1
                            )
                        )
                    ) {
                        VStack(spacing: 20) {
                            Image("Mewtwo")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                            Text("Contra la IA")
                                .font(.custom("Press Start 2P Regular", size: 16))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .shadow(radius: 5)
                    }

                    NavigationLink(
                        destination: eleccionPokemon(
                            contrincante: true,
                            pokemonActual: Pokemon2(
                                id: -1,
                                name: "Pikachu",
                                description: "Un Pokémon eléctrico.",
                                types: ["Eléctrico"],
                                weakTypes: ["Tierra"],
                                weight: 6.0,
                                height: 0.4,
                                stats: ["Ataque": 55, "Defensa": 40],
                                image: Image("Pikachu"),
                                image_shiny: Image("PikachuShiny"),
                                evolution_chain_id: 2
                            )
                        )
                    ) {
                        VStack {
                            HStack(spacing: 10) {
                                Image("Zekrom")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                                Image("Reshiram")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                            }
                            Text("Multijugador")
                                .font(.custom("Press Start 2P Regular", size: 16))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .toolbar {
                // ToolbarItem(placement: .navigationBarLeading) {
                //     Button(action: {
                //         if let window = UIApplication.shared.windows.first {
                //             let rootView = vistaMenu()
                //             window.rootViewController = UIHostingController(rootView: rootView)
                //             window.makeKeyAndVisible()
                //         }
                //     }) {
                //         HStack {
                //             Image(systemName: "chevron.left")
                //             Text("Atrás")
                //         }
                //         .foregroundColor(.blue)
                //     }
                // }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: VistaHistorialBatalla(userId: obtenerUserIdDesdeLocalStorage())
                    ) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 15))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
