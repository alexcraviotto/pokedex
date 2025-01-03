import SwiftUI

struct VistaCombate: View {
    @State private var contrincante: Bool = false // Si es false, combate contra la IA. Si es true, combate multijugador.
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 20) {
                    // Opción: Combate contra la IA
                    NavigationLink(destination: eleccionPokemon(contrincante: false, pokemonActual: Pokemon2(
                        id: 0,
                        name: "",
                        description: "",
                        types: [],
                        weakTypes: [],
                        weight: 0.0,
                        height: 0.0,
                        stats: [:],
                        image: Image(""),
                        image_shiny: Image(""),
                        evolution_chain_id: 0
                    ))) {
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
                    
                    // Opción: Combate multijugador
                    NavigationLink(destination: eleccionPokemon(contrincante: true, pokemonActual: Pokemon2(
                        id: -1,
                        name: "",
                        description: "",
                        types: [],
                        weakTypes: [],
                        weight: 0.0,
                        height: 0.0,
                        stats: [:],
                        image: Image(""),
                        image_shiny: Image(""),
                        evolution_chain_id: 0
                    ))) {
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

#Preview {
    VistaCombate()
}
