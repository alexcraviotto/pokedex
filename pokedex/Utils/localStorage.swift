//
//  localStorage.swift
//  pokedex
//
//  Created by Alex Craviotto on 10/12/24.
//

import Foundation
// Obtener el userId desde UserDefaults directamente
func obtenerUserIdDesdeLocalStorage() -> UUID {
    if let userIdString = UserDefaults.standard.string(forKey: "userId"),
       let userId = UUID(uuidString: userIdString) {
        return userId
    }
    return UUID() // Retorna un UUID vacío si no se encuentra en UserDefaults
}
