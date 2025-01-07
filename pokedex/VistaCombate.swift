import SwiftUI

struct VistaCombate: View {
    @State private var contrincante: Bool = false  // Si es false, combate contra la IA. Si es true, combate multijugador.

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 20) {
                    NavigationLink(
                        destination: eleccionPokemon(
                            esCombateIA: true,
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
                            Text("Contra la IA")
                                .font(.custom("Press Start 2P Regular", size: 16))
                                .foregroundColor(.black)
                        }
                        .frame(width: 330, height: 190)
                    }
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    ).shadow(radius: 10)

                    NavigationLink(
                        destination: eleccionPokemon(
                            esCombateIA: false,
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
                                Image("Reshiram")
                                    .renderingMode(.original)
                            }
                            Text("Multijugador")
                                .font(.custom("Press Start 2P Regular", size: 16))
                                .foregroundColor(.black)
                        }
                        .frame(width: 330, height: 190)
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    }
                    .shadow(radius: 10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Combate")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black)
                }
            }
        }
    }
}
