import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()  // Instancia del ViewModel

    var body: some View {
        NavigationView {
            VStack {
                // Mostrar usuarios
                List(viewModel.usersArray, id: \.id) { user in
                    Text(user.username ?? "No Username")
                }
                
                // Agregar un nuevo usuario
                Button(action: {
                    // Llamar a la función de agregar usuario
                    viewModel.agregarUsuario(username: "NuevoUsuario", email: "email@dominio.com", password: "1234")
                }) {
                    Text("Agregar Usuario")
                }
                
                // Mostrar BattleLogs
                List(viewModel.battleLogsArray, id: \.id) { battleLog in
                    Text("Batalla \(battleLog.battleDate ?? Date()) - Resultado: \(battleLog.result ?? "Desconocido")")
                }
                
                // Agregar un BattleLog
                Button(action: {
                    // Agregar BattleLog con datos de ejemplo
                    if let userId = viewModel.usersArray.first?.id {
                        viewModel.agregarBattleLog(userId: userId, pokemonIds: [1, 2, 3], opponentPokemonIds: [4, 5, 6], result: "Victoria")
                    }
                }) {
                    Text("Agregar BattleLog")
                }
                
                // Mostrar Pokémon Favoritos
                List(viewModel.favoritePokemonsArray, id: \.id) { favorite in
                    Text("Pokémon Favorito: \(favorite.pokemonId)")
                }
                
                // Agregar un Pokémon favorito
                Button(action: {
                    // Agregar un Pokémon favorito con un ID de ejemplo
                    if let userId = viewModel.usersArray.first?.id {
                        viewModel.agregarFavoritePokemon(userId: userId, pokemonId: 25)
                    }
                }) {
                    Text("Agregar Pokémon Favorito")
                }
            }
            .navigationTitle("Pokedex")
        }
        .onAppear {
            viewModel.cargarDatos()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
