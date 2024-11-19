import Foundation
import CoreData
import SwiftUI

class ViewModel: ObservableObject {
    let gestorCoreData = CoreDataManager.instance
    @Published var usersArray: [UserEntity] = []
    @Published var battleLogsArray: [BattleLogEntity] = []
    @Published var favoritePokemonsArray: [FavoritePokemonEntity] = []
    @Published var recentPokemonSearchArray: [RecentPokemonSearchEntity] = []

    init() {
        cargarDatos()
    }

    // Cargar todos los datos
    func cargarDatos() {
        usersArray.removeAll()
        battleLogsArray.removeAll()
        favoritePokemonsArray.removeAll()
        recentPokemonSearchArray.removeAll()

        let fetchUsers = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        let fetchBattleLogs = NSFetchRequest<BattleLogEntity>(entityName: "BattleLogEntity")
        let fetchFavoritePokemons = NSFetchRequest<FavoritePokemonEntity>(entityName: "FavoritePokemonEntity")
        let fetchRecentPokemonSearches = NSFetchRequest<RecentPokemonSearchEntity>(entityName: "RecentPokemonSearchEntity")

        do {
            self.usersArray = try gestorCoreData.contexto.fetch(fetchUsers)
            self.battleLogsArray = try gestorCoreData.contexto.fetch(fetchBattleLogs)
            self.favoritePokemonsArray = try gestorCoreData.contexto.fetch(fetchFavoritePokemons)
            self.recentPokemonSearchArray = try gestorCoreData.contexto.fetch(fetchRecentPokemonSearches)
        } catch let error {
            print("Error al cargar los datos: \(error)")
        }
    }

    func guardarDatos() {
        gestorCoreData.save()
        cargarDatos()
    }

    // Agregar un nuevo Usuario
    func agregarUsuario(username: String, email: String, password: String) {
        let user = UserEntity(context: gestorCoreData.contexto)
        print(user)
        user.id = UUID()
        user.username = username
        user.email = email
        user.password = password
        user.createdAt = Date()
        print(user)
        guardarDatos()
    }

    // Agregar un BattleLog
    func agregarBattleLog(userId: UUID, pokemonIds: [Int64], opponentPokemonIds: [Int64], result: String) {
        guard pokemonIds.count == 3, opponentPokemonIds.count == 3 else {
            print("Debe proporcionar exactamente 3 Pokémon y 3 Pokémon oponentes.")
            return
        }

        let battleLog = BattleLogEntity(context: gestorCoreData.contexto)
        battleLog.id = UUID()
        battleLog.userId = userId
        battleLog.pokemonId1 = pokemonIds[0]
        battleLog.pokemonId2 = pokemonIds[1]
        battleLog.pokemonId3 = pokemonIds[2]
        battleLog.opponentPokemonId1 = opponentPokemonIds[0]
        battleLog.opponentPokemonId2 = opponentPokemonIds[1]
        battleLog.opponentPokemonId3 = opponentPokemonIds[2]
        battleLog.result = result
        battleLog.battleDate = Date()
        guardarDatos()
    }

    // Agregar un Pokémon favorito
    func agregarFavoritePokemon(userId: UUID, pokemonId: Int64) {
        let favoritePokemon = FavoritePokemonEntity(context: gestorCoreData.contexto)
        favoritePokemon.id = UUID()
        favoritePokemon.userId = userId
        favoritePokemon.pokemonId = pokemonId
        guardarDatos()
    }

    // Agregar un Pokémon a las búsquedas recientes
    func agregarRecentPokemonSearch(userId: UUID, pokemonId: Int64) {
        let recentSearch = RecentPokemonSearchEntity(context: gestorCoreData.contexto)
        recentSearch.id = UUID()
        recentSearch.userId = userId
        recentSearch.pokemonId = pokemonId
        recentSearch.searchDate = Date()
        guardarDatos()
    }

    // Eliminar un BattleLog
    func eliminarBattleLog(battleLog: BattleLogEntity) {
        gestorCoreData.contexto.delete(battleLog)
        guardarDatos()
    }

    // Eliminar un Usuario
    func eliminarUsuario(user: UserEntity) {
        gestorCoreData.contexto.delete(user)
        guardarDatos()
    }

    // Actualizar un Usuario
    func actualizarUsuario(userId: UUID, newUsername: String, newEmail: String, newPassword: String) {
        if let user = usersArray.first(where: { $0.id == userId }) {
            user.username = newUsername
            user.email = newEmail
            user.password = newPassword
            guardarDatos()
        }
    }

    // Obtener Batallas por Usuario
    func obtenerBatallasPorUsuario(userId: UUID) -> [BattleLogEntity] {
        return battleLogsArray.filter { $0.userId == userId }
    }

    // Eliminar un Pokémon Favorito
    func eliminarFavoritePokemon(favoritePokemon: FavoritePokemonEntity) {
        gestorCoreData.contexto.delete(favoritePokemon)
        guardarDatos()
    }

    // Obtener Pokémon Favoritos por Usuario
    func obtenerFavoritePokemonsPorUsuario(userId: UUID) -> [FavoritePokemonEntity] {
        return favoritePokemonsArray.filter { $0.userId == userId }
    }

    func eliminarRecentPokemonSearch(recentSearch: RecentPokemonSearchEntity) {
        gestorCoreData.contexto.delete(recentSearch)
        guardarDatos()
    }

    func obtenerRecentPokemonSearchesPorUsuario(userId: UUID) -> [RecentPokemonSearchEntity] {
        return recentPokemonSearchArray.filter { $0.userId == userId }
    }

    func eliminarTodasLasBatallasDeUsuario(userId: UUID) {
        let batallasUsuario = obtenerBatallasPorUsuario(userId: userId)
        for battleLog in batallasUsuario {
            eliminarBattleLog(battleLog: battleLog)
        }
    }

    func actualizarBattleLog(battleLogId: UUID, pokemonIds: [Int64], opponentPokemonIds: [Int64], result: String) {
        if let battleLog = battleLogsArray.first(where: { $0.id == battleLogId }) {
            battleLog.pokemonId1 = pokemonIds[0]
            battleLog.pokemonId2 = pokemonIds[1]
            battleLog.pokemonId3 = pokemonIds[2]
            battleLog.opponentPokemonId1 = opponentPokemonIds[0]
            battleLog.opponentPokemonId2 = opponentPokemonIds[1]
            battleLog.opponentPokemonId3 = opponentPokemonIds[2]
            battleLog.result = result
            battleLog.battleDate = Date()
            guardarDatos()
        }
    }

    func estaEnBúsquedasRecientes(userId: UUID, pokemonId: Int64) -> Bool {
        return recentPokemonSearchArray.contains { $0.userId == userId && $0.pokemonId == pokemonId }
    }

    func eliminarTodasLasBúsquedasRecientesDeUsuario(userId: UUID) {
        let búsquedasRecientesUsuario = obtenerRecentPokemonSearchesPorUsuario(userId: userId)
        for recentSearch in búsquedasRecientesUsuario {
            eliminarRecentPokemonSearch(recentSearch: recentSearch)
        }
    }
}
