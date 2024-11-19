import Foundation

// Función para obtener el sprite frontal (de showdown)
func fetchPokemonFrontGif(pokemonID: Int, completion: @escaping (Result<String?, Error>) -> Void) {
    // Crear la URL de la API de PokeAPI v2 con el ID del Pokémon
    let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonID)"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
        return
    }

    // Realizar la solicitud HTTP para obtener los datos del Pokémon
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // Si hubo un error en la solicitud
        if let error = error {
            completion(.failure(error))
            return
        }

        // Si no hubo datos, devolver error
        guard let data = data else {
            completion(.failure(NSError(domain: "NoData", code: 404, userInfo: nil)))
            return
        }

        // Intentar convertir los datos en un diccionario JSON
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Acceder a la URL del sprite frontal desde Showdown
                if let sprites = json["sprites"] as? [String: Any],
                   let other = sprites["other"] as? [String: Any],
                   let showdown = other["showdown"] as? [String: Any],
                   let frontGifURL = showdown["front_default"] as? String {
                    completion(.success(frontGifURL))
                } else {
                    completion(.failure(NSError(domain: "MissingData", code: 404, userInfo: nil)))
                }
            } else {
                completion(.failure(NSError(domain: "InvalidJSON", code: 500, userInfo: nil)))
            }
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}

// Función para obtener el sprite trasero (de showdown)
func fetchPokemonBackGif(pokemonID: Int, completion: @escaping (Result<String?, Error>) -> Void) {
    // Crear la URL de la API de PokeAPI v2 con el ID del Pokémon
    let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonID)"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
        return
    }

    // Realizar la solicitud HTTP para obtener los datos del Pokémon
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // Si hubo un error en la solicitud
        if let error = error {
            completion(.failure(error))
            return
        }

        // Si no hubo datos, devolver error
        guard let data = data else {
            completion(.failure(NSError(domain: "NoData", code: 404, userInfo: nil)))
            return
        }

        // Intentar convertir los datos en un diccionario JSON
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // Acceder a la URL del sprite trasero desde Showdown
                if let sprites = json["sprites"] as? [String: Any],
                   let other = sprites["other"] as? [String: Any],
                   let showdown = other["showdown"] as? [String: Any],
                   let backGifURL = showdown["back_default"] as? String {
                    print(backGifURL)
                    completion(.success(backGifURL))
                } else {
                    completion(.failure(NSError(domain: "MissingData", code: 404, userInfo: nil)))
                }
            } else {
                completion(.failure(NSError(domain: "InvalidJSON", code: 500, userInfo: nil)))
            }
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}
