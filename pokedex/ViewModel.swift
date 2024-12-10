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
        user.avatar = 1;
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
    // Función para verificar las credenciales del usuario
    func verificarUsuario(email: String, password: String) -> UserEntity? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let resultados = try gestorCoreData.contexto.fetch(fetchRequest)
            return resultados.first // Retorna el primer usuario que coincida con las credenciales
        } catch {
            print("Error al verificar usuario: \(error)")
            return nil
        }
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
    func actualizarUsuario(userId: UUID, newUsername: String?, newEmail: String?, newPassword: String?, avatar: Int64?) {
        if let user = usersArray.first(where: { $0.id == userId }) {
            if let username = newUsername {
                user.username = username
            }
            if let email = newEmail {
                user.email = email
            }
            if let password = newPassword {
                user.password = password
            }
            if let avatar = avatar {
                user.avatar = avatar;
            }
            
            guardarDatos()
        }
    }


    // Obtener Batallas por Usuario
    func obtenerBatallasPorUsuario(userId: UUID) -> [BattleLogEntity] {
        return battleLogsArray.filter { $0.userId == userId }
    }

    // Eliminar un Pokémon Favorito dado el userId y pokemonId
    // Eliminar un Pokémon Favorito dado el userId y pokemonId
    func eliminarFavoritePokemon(userId: UUID, pokemonId: Int64) {
    
        
        // Verificar que pokemonId sea válido
        if pokemonId == 0 {
            print("pokemonId no es válido")
            return
        }
        
        // Buscar el Pokémon favorito en Core Data utilizando el userId y pokemonId
        let fetchRequest: NSFetchRequest<FavoritePokemonEntity> = FavoritePokemonEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@ AND pokemonId == %@", userId as CVarArg, pokemonId as CVarArg)
        
        do {
            // Ejecutar la consulta
            let result = try gestorCoreData.contexto.fetch(fetchRequest)
            
            // Si encontramos el Pokémon favorito, lo eliminamos
            if let favoritePokemon = result.first {
                gestorCoreData.contexto.delete(favoritePokemon)
                guardarDatos()
                print("Pokémon eliminado de favoritos")
            } else {
                print("No se encontró el Pokémon en favoritos")
            }
        } catch {
            print("Error al eliminar el Pokémon de favoritos: \(error)")
        }
    }


    // Obtener Pokémon Favoritos por Usuario
    func obtenerFavoritePokemonsPorUsuario(userId: UUID) -> [FavoritePokemonEntity] {
        return favoritePokemonsArray.filter { $0.userId == userId }
    }

    func eliminarRecentPokemonSearch(recentSearch: RecentPokemonSearchEntity) {
        gestorCoreData.contexto.delete(recentSearch)
        guardarDatos()
    }
    // Función para verificar si un Pokémon es favorito para un usuario dado
    func esPokemonFavorito(userId: UUID, pokemonId: Int64) -> Bool {
        // Filtra los Pokémon favoritos del usuario por el ID del Pokémon
        let favoritosDelUsuario = obtenerFavoritePokemonsPorUsuario(userId: userId)
        
        // Devuelve true si el Pokémon está en los favoritos del usuario, de lo contrario false
        return favoritosDelUsuario.contains { $0.pokemonId == pokemonId }
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
