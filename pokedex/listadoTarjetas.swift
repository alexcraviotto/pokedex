import SwiftUI

struct listadoTarjetas: View {
    @State private var pokemons: [Pokemon] = []
    @State private var isLoading = true
    let columnas = [
          GridItem(.flexible()),
          GridItem(.flexible())
      ]
    @State var count = 0
    @State var countex = 0
    var items = 20
    
    var body: some View {
        NavigationView { // Aseguramos que el NavigationView está presente
            VStack {
                HStack {
                    Image("Pokedex").scaledToFit().frame(height: 50)
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: columnas, spacing: 20) {
                        ForEach(pokemons.sorted(by: { $0.id < $1.id })) { pokemon in
                            NavigationLink(
                                destination: NavegacionVistaDetalle(pokemon: pokemon) // Pasamos el objeto pokemon directamente
                            ) {
                                PokemonTarjeta2(pokemon: pokemon)
                                    .scaleEffect(0.9)
                                    .onAppear {
                                        if pokemon.id == self.pokemons.count && !isLoading {
                                            carga() // Cargar más Pokémon si hemos llegado al final
                                        }
                                        if self.pokemons.count >= 1045 && !isLoading {
                                            carga() // Cargar más Pokémon si hemos llegado al final
                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle()) // Previene el estilo predeterminado del NavigationLink
                        }
                    }
                }
                .onAppear {
                    carga()
                }
            }
        }
    }
    
    func carga() -> Void {
        isLoading = true
        var start = 0
        if pokemons.count >= 1025 {
            start = 10000 + countex * items
            countex += 1
            //print(start)
        } else {
            start = count * items
            count += 1
        }
        start += 1
        let end = start + items
        //print(end)
        for i in start..<end {
            fetchPokemonData(pokemonId: i) { result in
                switch result {
                case .success(let pokemon):
                    DispatchQueue.main.async {
                        pokemons.append(pokemon)
                    }
                case .failure(let error):
                    break
                    //print("Error: \(error)")
                }
            }
            //print(i)
        }
        pokemons = pokemons.sorted(by: { $0.id < $1.id })
        isLoading = false
    }
}

#Preview {
    listadoTarjetas()
}
