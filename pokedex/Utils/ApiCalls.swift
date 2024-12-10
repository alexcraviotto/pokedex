import Foundation
import SwiftUI
    // Conseguir un array con cualquier endpoint de la API
    func pokeApi(endpoint: String) async -> [String: Any] {
        guard let url = URL(string: "https://pokeapi.co/api/v2/\(endpoint)") else { return [:] }
        let (data, _) = try! await URLSession.shared.data(from: url)
        return (try? JSONSerialization.jsonObject(with: data) as? [String: Any]) ?? [:]
    }
// Función para obtener un Pokémon por ID
func pokemonPorId(id: Int) async -> Pokemon2 {
    let poke = await pokeApi(endpoint: "pokemon/\(id)")
    let poke_species = await pokeApi(endpoint: "pokemon-species/\(id)")
    let id_pokemon = id
    let name = poke["name"] as! String
    let weight = poke["weight"] as! Float
    let height = poke["height"] as! Float
    var description = ""
    
    // Buscamos la descripción en inglés dentro del campo flavor_text_entries
    if let flavorTextEntries = poke_species["flavor_text_entries"] as? [[String: Any]] {
        for entry in flavorTextEntries {
            if let language = entry["language"] as? [String: Any],
               let languageName = language["name"] as? String, languageName == "en", // Verificamos si el idioma es inglés
               let flavorText = entry["flavor_text"] as? String {
                description = flavorText.replacingOccurrences(of: "\n", with: " ") // Limpiamos saltos de línea
                break
            }
        }
    }
    var statsDictionary: [String: Int] = [:]
    // Recorremos el array "stats" y extraemos los valores
    if let statsArray = poke["stats"] as? [[String: Any]] {
        for stat in statsArray {
            if let baseStat = stat["base_stat"] as? Int,
               let statDetail = stat["stat"] as? [String: Any],
               let statName = statDetail["name"] as? String {
                // Añadir el stat al diccionario
                statsDictionary[statName] = baseStat
            }
        }
    }
    // Extraemos los tipos del Pokémon
       var types: [String] = []
       var weakTypes: [String] = []
       if let typesArray = poke["types"] as? [[String: Any]] {
           for typeEntry in typesArray {
               if let typeDetail = typeEntry["type"] as? [String: Any],
                  let typeName = typeDetail["name"] as? String {
                   types.append(typeName)
                   // Llamada para obtener las debilidades de este tipo
                   let typeData = await pokeApi(endpoint: "type/\(typeName)")
                   if let damageRelations = typeData["damage_relations"] as? [String: Any],
                      let doubleDamageFrom = damageRelations["double_damage_from"] as? [[String: Any]] {
                       // Agregar los tipos débiles al array weakTypes
                       for weakType in doubleDamageFrom {
                           if let weakTypeName = weakType["name"] as? String {
                               if !weakTypes.contains(weakTypeName) {
                                   weakTypes.append(weakTypeName)
                               }
                           }
                       }
                   }
               }
           }
       }
    
    
    var officialArtworkImage: String = ""
    var shinyOfficialArtworkImage: String = ""
    if let sprites = poke["sprites"] as? [String: Any],
       let other = sprites["other"] as? [String: Any],
       let officialArtwork = other["official-artwork"] as? [String: Any] {
        officialArtworkImage = officialArtwork["front_default"] as? String ?? ""
        shinyOfficialArtworkImage = officialArtwork["front_shiny"] as? String ?? ""
    }
    // Convertimos las URLs en imágenes
    let image = Image(uiImage: UIImage(data: try! Data(contentsOf: URL(string: officialArtworkImage)!)) ?? UIImage())
    let image_shiny = Image(uiImage: UIImage(data: try! Data(contentsOf: URL(string: shinyOfficialArtworkImage)!)) ?? UIImage())
    var evolutionChainID: Int = 0
    if let evolutionChainData = poke_species["evolution_chain"] as? [String: Any],
       let chainURL = evolutionChainData["url"] as? String {
        // Extraer el ID desde la URL
        if let idString = chainURL.split(separator: "/").last,
           let id = Int(idString) {
            evolutionChainID = id
        }
    }
    return Pokemon2(
        id: id_pokemon,
        name: name,
        description: description,
        types: types,
        weakTypes: weakTypes,
        weight: weight,
        height: height,
        stats: statsDictionary,
        image: image,
        image_shiny: image_shiny,
        evolution_chain_id: evolutionChainID
    )
}
// Función para obtener todos los Pokémon
func obtenerTodosLosPokemons() async -> [(Int, String)] {
    let poke = await pokeApi(endpoint: "pokemon?limit=6")
    
    var pokemonArray: [(Int, String)] = []
    // Acceder correctamente al array "results"
    if let results = poke["results"] as? [[String: Any]] {
        for pokemon in results {
            // Extraer "name" y "url" correctamente
            if let name = pokemon["name"] as? String,
               let urlString = pokemon["url"] as? String,
               let id = Int(urlString.dropFirst(34).dropLast(1)) {
                pokemonArray.append((id, name)) // Agregar a la lista final
            }
        }
    }
    return pokemonArray
}
func getPokemonMoves(id: Int, offset: Int, limit: Int) async -> [(String, String, Int, Int)] {
    // Llamar a la API para obtener los detalles del Pokémon
    let poke = await pokeApi(endpoint: "pokemon/\(id)")
    
    // Extraer los movimientos del Pokémon desde la respuesta
    guard let moves = poke["moves"] as? [[String: Any]] else {
        return []  // Si no se encuentran movimientos, retornar un arreglo vacío
    }
    
    // Aplicar el rango de paginación
    let paginatedMoves = moves[offset..<min(offset + limit, moves.count)]
    
    var moveDetails: [(String, String, Int, Int)] = []
    
    // Iterar sobre los movimientos paginados
    for move in paginatedMoves {
        // Obtener el diccionario "move" que contiene la URL del movimiento
        let moveDict = move["move"] as! [String: Any]
        let moveUrl = moveDict["url"] as! String
        let transformedEndpoint = String(moveUrl.dropFirst(26).dropLast(1)) // Transformar la URL del movimiento
        
        // Llamar a la API para obtener los detalles del movimiento
        let moveDetailsResponse = await pokeApi(endpoint: transformedEndpoint)
        
        // Extraer los valores del movimiento
        let name = (moveDetailsResponse["name"] as? String) ?? "Unknown"
        let accuracy = (moveDetailsResponse["accuracy"] as? Int) ?? 0
        let power = (moveDetailsResponse["power"] as? Int) ?? 0
        let effectEntries = (moveDetailsResponse["effect_entries"] as? [[String: Any]]) ?? []
        let description = (effectEntries.first(where: {
            ($0["language"] as? [String: Any])?["name"] as? String == "en"
        })?["effect"] as? String) ?? "Unknown"
        
        // Añadir los detalles del movimiento a la lista
        moveDetails.append((name, description, accuracy, power))
    }
    
    return moveDetails
}
func obtenerEvoluciones(evolutionChainId: Int) async -> [(Pokemon2, String, Pokemon2)] {
    // Llamar al endpoint de evolución
    let evolutionData = await pokeApi(endpoint: "evolution-chain/\(evolutionChainId)")
    
    // Validar si la cadena de evolución está disponible
    guard let chain = evolutionData["chain"] as? [String: Any] else {
        return [] // Retornar vacío si no hay cadena
    }
    
    var evolutions: [(Pokemon2, String, Pokemon2)] = []
    var seenPokemonIds = Set<Int>() // Conjunto para evitar duplicados
    
    // Método recursivo para recorrer las evoluciones
    func recorrerEvoluciones(chain: [String: Any], pokemonBase: Pokemon2?) async {
        // Obtener la especie actual
        guard let species = chain["species"] as? [String: Any],
              let name = species["name"] as? String,
              let url = species["url"] as? String,
              let idString = url.split(separator: "/").last,
              let id = Int(idString) else {
            return
        }
        
        // Verificar si el Pokémon ya ha sido procesado
        if seenPokemonIds.contains(id) {
            return // Si ya se ha procesado, salimos de la función
        }
        
        // Marcar este Pokémon como procesado
        seenPokemonIds.insert(id)
        
        // Obtener el Pokémon base (utilizando la función pokemonPorId)
        var currentPokemon: Pokemon2
        if let base = pokemonBase {
            currentPokemon = base
        } else {
            currentPokemon = await pokemonPorId(id: id) // Usamos la función proporcionada
        }
        
        // Procesar las evoluciones
        if let evolvesToArray = chain["evolves_to"] as? [[String: Any]] {
            for evolution in evolvesToArray {
                // Extraer detalles de evolución
                let evolutionDetails = (evolution["evolution_details"] as? [[String: Any]]) ?? []
                var evolutionMethod = "Unknown"
                
                if let firstDetail = evolutionDetails.first {
                    if let trigger = (firstDetail["trigger"] as? [String: Any])?["name"] as? String {
                        switch trigger {
                        case "level-up":
                            if let minLevel = firstDetail["min_level"] as? Int {
                                evolutionMethod = "Level \(minLevel)"
                            } else {
                                evolutionMethod = "Level up"
                            }
                        case "use-item":
                            if let item = firstDetail["item"] as? [String: Any], let itemName = item["name"] as? String {
                                evolutionMethod = "Item: \(itemName)"
                            }
                        default:
                            evolutionMethod = trigger
                        }
                    }
                }
                
                // Obtener el Pokémon evolucionado
                guard let evolvedSpecies = evolution["species"] as? [String: Any],
                      let evolvedName = evolvedSpecies["name"] as? String,
                      let evolvedUrl = evolvedSpecies["url"] as? String,
                      let evolvedIdString = evolvedUrl.split(separator: "/").last,
                      let evolvedId = Int(evolvedIdString) else {
                    continue
                }
                
                // Verificar si el Pokémon evolucionado ya ha sido procesado
                if seenPokemonIds.contains(evolvedId) {
                    continue // Si ya se ha procesado, pasamos al siguiente
                }
                
                // Marcar el Pokémon evolucionado como procesado
                seenPokemonIds.insert(evolvedId)
                
                // Obtener el Pokémon evolucionado (utilizando la función pokemonPorId)
                let evolvedPokemon = await pokemonPorId(id: evolvedId)
                
                // Añadir la terna al resultado
                evolutions.append((currentPokemon, evolutionMethod, evolvedPokemon))
                
                // Llamada recursiva para la siguiente evolución
                await recorrerEvoluciones(chain: evolution, pokemonBase: evolvedPokemon)
            }
        }
    }
    
    // Iniciar la recursión con la cadena de evolución
    await recorrerEvoluciones(chain: chain, pokemonBase: nil)
    print(evolutions)
    return evolutions
}
