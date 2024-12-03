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
    let description = ""

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
    if let typesArray = poke["types"] as? [[String: Any]] {
        for typeEntry in typesArray {
            if let typeDetail = typeEntry["type"] as? [String: Any],
               let typeName = typeDetail["name"] as? String {
                types.append(typeName)
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

func getPokemonMoves(id: Int) async -> [(String, String, Int, Int)] {
    // Llamar a la API para obtener los detalles del Pokémon
    let poke = await pokeApi(endpoint: "pokemon/\(id)")
    
    // Extraer los movimientos del Pokémon desde la respuesta
    guard let moves = poke["moves"] as? [[String: Any]] else {
        return []  // Si no se encuentran movimientos, retornar un arreglo vacío
    }
    
    var moveDetails: [(String, String, Int, Int)] = []
    
    for move in moves {
        // Obtener el diccionario "move" que contiene la URL del movimiento
        let moveDict = move["move"] as! [String: Any]
        let moveUrl = moveDict["url"] as! String
        let transformedEndpoint = String(moveUrl.dropFirst(26).dropLast(1)) // Transformar la URL del movimiento
        
        // Llamar a la API para obtener los detalles del movimiento
        let moveDetailsResponse = await pokeApi(endpoint: transformedEndpoint)
        
        // Extraer los valores del movimiento utilizando `as!` y valores predeterminados con `??`
        let name = (moveDetailsResponse["name"] as? String) ?? "Unknown"
        let accuracy = (moveDetailsResponse["accuracy"] as? Int) ?? 0
        let power = (moveDetailsResponse["power"] as? Int) ?? 0
        let versionGroupDetails = (moveDetailsResponse["version_group_details"] as? [[String: Any]]) ?? []
        
        // Obtener la descripción del movimiento
        let effectEntries = (moveDetailsResponse["effect_entries"] as? [[String: Any]]) ?? []
        let description = (effectEntries.first(where: {
            ($0["language"] as? [String: Any])?["name"] as? String == "en"
        })?["effect"] as? String) ?? "Unknown"
        
        // Procesar detalles de `version_group_details`
        for versionGroupDetail in versionGroupDetails {
            let versionGroup = (versionGroupDetail["version_group"] as? [String: Any]) ?? [:]
            let versionGroupName = (versionGroup["name"] as? String) ?? "Unknown"
            print("Version Group: \(versionGroupName)")
        }
        
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
    
    // Método recursivo para recorrer las evoluciones
    func recorrerEvoluciones(chain: [String: Any], pokemonBase: Pokemon2?) {
        // Obtener la especie actual
        guard let species = chain["species"] as? [String: Any],
              let name = species["name"] as? String,
              let url = species["url"] as? String,
              let idString = url.split(separator: "/").last,
              let id = Int(idString) else {
            return
        }
        
        // Crear el Pokémon actual si no es el base
        let currentPokemon: Pokemon2
        if let base = pokemonBase {
            currentPokemon = base
        } else {
            currentPokemon = Pokemon2(
                id: id,
                name: name,
                description: "",
                types: [], // Se podría completar si tienes más datos
                weight: 0,
                height: 0,
                stats: [:],
                image: Image("placeholder"), // Imagen por defecto
                image_shiny: Image("placeholder"), // Imagen por defecto
                evolution_chain_id: evolutionChainId
            )
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
                            // Si el trigger es "level-up" y min_level es null, se pone "Level up"
                            if let minLevel = firstDetail["min_level"] as? Int {
                                evolutionMethod = "Level \(minLevel)"
                            } else {
                                evolutionMethod = "Level up"
                            }
                            
                        case "use-item":
                            // Si el trigger es "use-item", se pone el nombre del item en evolutionMethod
                            if let item = firstDetail["item"] as? [String: Any], let itemName = item["name"] as? String {
                                evolutionMethod = "Item: \(itemName)"
                            }
                            
                        default:
                            // En cualquier otro caso, simplemente poner el nombre del trigger tal cual
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
                
                let evolvedPokemon = Pokemon2(
                    id: evolvedId,
                    name: evolvedName,
                    description: "",
                    types: [], // Se podría completar si tienes más datos
                    weight: 0,
                    height: 0,
                    stats: [:],
                    image: Image("placeholder"), // Imagen por defecto
                    image_shiny: Image("placeholder"), // Imagen por defecto
                    evolution_chain_id: evolutionChainId
                )
                
                // Añadir la terna al resultado
                evolutions.append((currentPokemon, evolutionMethod, evolvedPokemon))
                
                // Llamada recursiva para la siguiente evolución
                recorrerEvoluciones(chain: evolution, pokemonBase: evolvedPokemon)
            }
        }
    }
    
    // Iniciar la recursión con la cadena de evolución
    recorrerEvoluciones(chain: chain, pokemonBase: nil)
    
    return evolutions
}


