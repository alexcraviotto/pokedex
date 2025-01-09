//
//  Api.swift
//  pokedex
//
//  Created by Aula03 on 19/11/24.
//
import SwiftUI

func fetchPokemonData(pokemonId: Int, completion: @escaping (Result<Pokemon, Error>) -> Void) {
    // URL de la API de PokeAPI para obtener los detalles del Pokémon
    let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonId)"

    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    // Crear la solicitud HTTP
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // Verificar si hay error
        if let error = error {
            completion(.failure(error))
            return
        }

        // Verificar que los datos existan
        guard let data = data else {
            completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
            return
        }

        do {
            // Intentar decodificar los datos
            let decoder = JSONDecoder()
            let pokemon = try decoder.decode(Pokemon.self, from: data)
            completion(.success(pokemon))
        } catch {
            completion(.failure(error))
        }
    }

    // Iniciar la tarea
    task.resume()
}

func fetchPokemonData(pokemonId: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
    // URL de la API de PokeAPI para obtener los detalles del Pokémon
    let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonId)"

    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    // Crear la solicitud HTTP
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // Verificar si hay error
        if let error = error {
            completion(.failure(error))
            return
        }

        // Verificar que los datos existan
        guard let data = data else {
            completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
            return
        }

        do {
            // Intentar decodificar los datos
            let decoder = JSONDecoder()
            let pokemon = try decoder.decode(Pokemon.self, from: data)
            completion(.success(pokemon))
        } catch {
            completion(.failure(error))
        }
    }

    // Iniciar la tarea
    task.resume()
}

func fetchPokemonNames(completion: @escaping (Result<[PokemonPair], Error>) -> Void) {
    // URL de la API de PokeAPI para obtener los detalles del Pokémon
    let urlString = "https://pokeapi.co/api/v2/pokemon?limit=100000"

    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    // Crear la solicitud HTTP
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // Verificar si hay error
        if let error = error {
            completion(.failure(error))
            return
        }

        // Verificar que los datos existan
        guard let data = data else {
            completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
            return
        }

        do {
            // Intentar decodificar los datos
            //let decoder = JSONDecoder()
            let decodedResponse = try JSONDecoder().decode(PokemonTypeResponse.self, from: data)
            //let pokemon = try decoder.decode(PokemonPair.self, from: data)
            var pokemonList: [PokemonPair] = []

            for entry in decodedResponse.results {
                if let pokemonID = extractPokemonID(from: entry.url) {
                    pokemonList.append(PokemonPair(name: entry.name, id: pokemonID))
                }
            }

            completion(.success(pokemonList))
        } catch {
            completion(.failure(error))
        }
    }

    // Iniciar la tarea
    task.resume()
}

func fetchPokemonsType(pokemontype: String, completion: @escaping (Result<Pokemon, Error>) -> Void)
{
    // URL de la API de PokeAPI para obtener los detalles del Pokémon
    let urlString = "https://pokeapi.co/api/v2/type/\(pokemontype)"

    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    // Crear la solicitud HTTP
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // Verificar si hay error
        if let error = error {
            completion(.failure(error))
            return
        }

        // Verificar que los datos existan
        guard let data = data else {
            completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
            return
        }

        do {
            // Intentar decodificar los datos
            let decoder = JSONDecoder()
            let pokemon = try decoder.decode(Pokemon.self, from: data)
            completion(.success(pokemon))
        } catch {
            completion(.failure(error))
        }
    }

    // Iniciar la tarea
    task.resume()
}

func extractPokemonID(from url: String) -> Int? {
    // La URL tiene el formato https://pokeapi.co/api/v2/pokemon/{id}/
    let components = url.split(separator: "/")
    if let idString = components.last, let id = Int(idString) {
        return id
    }
    return nil
}

func getMovesWithPP(
    id pokemonId: Int, completion: @escaping (Result<[(String, Int, Int)], Error>) -> Void
) {
    // Obtener los datos del Pokémon
    let pokemonURLString = "https://pokeapi.co/api/v2/pokemon/\(pokemonId)"

    guard let pokemonURL = URL(string: pokemonURLString) else {
        completion(.failure(NSError(domain: "Invalid Pokémon URL", code: 0, userInfo: nil)))
        return
    }

    URLSession.shared.dataTask(with: pokemonURL) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
            return
        }

        do {
            guard let pokemonJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let movesArray = pokemonJSON["moves"] as? [[String: Any]] else {
                throw NSError(domain: "Invalid Pokémon data", code: 0, userInfo: nil)
            }

            let dispatchGroup = DispatchGroup()
            var movesWithDetails: [(String, Int, Int)] = []
            var fetchError: Error?

            for moveEntry in movesArray {
                guard let moveDetails = moveEntry["move"] as? [String: Any],
                      let moveURLString = moveDetails["url"] as? String,
                      let moveURL = URL(string: moveURLString) else {
                    continue
                }

                dispatchGroup.enter()

                URLSession.shared.dataTask(with: moveURL) { moveData, moveResponse, moveError in
                    if let moveError = moveError {
                        fetchError = moveError
                        dispatchGroup.leave()
                        return
                    }

                    guard let moveData = moveData else {
                        fetchError = NSError(domain: "No move data", code: 0, userInfo: nil)
                        dispatchGroup.leave()
                        return
                    }

                    do {
                        guard let moveJSON = try JSONSerialization.jsonObject(with: moveData, options: []) as? [String: Any],
                              let moveName = moveJSON["name"] as? String,
                              let movePP = moveJSON["pp"] as? Int else {
                            throw NSError(domain: "Invalid move data", code: 0, userInfo: nil)
                        }

                        // Manejar la ausencia de "accuracy"
                        let moveAccuracy = moveJSON["accuracy"] as? Int ?? 100
                        movesWithDetails.append((moveName, movePP, moveAccuracy))
                    } catch {
                        fetchError = error
                    }

                    dispatchGroup.leave()
                }.resume()
            }

            dispatchGroup.notify(queue: .main) {
                if let error = fetchError {
                    completion(.failure(error))
                } else {
                    completion(.success(movesWithDetails))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
