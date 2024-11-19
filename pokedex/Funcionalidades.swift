//
//  Funcionalidades.swift
//  pokedex
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI

func colorPicker(tipo: String) -> Color{
    switch tipo {
    case "fire":
        return Color(CGColor(red: 230/250, green: 109/250, blue: 62/250, alpha: 1))
    case "grass":
        return Color(CGColor(red: 102/255, green: 168/255, blue: 69/255, alpha: 1))
    case "water":
        return Color(CGColor(red: 81/255, green: 133/255, blue: 196/255, alpha: 1))
    case "ice":
        return Color(CGColor(red: 108/255, green: 199/255, blue: 235/255, alpha: 1))
    case "ground":
        return Color(CGColor(red: 156/255, green: 119/255, blue: 67/255, alpha: 1))
    case "electric":
        return Color(CGColor(red: 245/255, green: 215/255, blue: 81/255, alpha: 1))
    case "fighting":
        return Color(CGColor(red: 224/255, green: 158/255, blue: 65/255, alpha: 1))
    case "poison":
        return Color(CGColor(red: 116/255, green: 81/255, blue: 153/255, alpha: 1))
    case "flying":
        return Color(CGColor(red: 162/255, green: 196/255, blue: 232/255, alpha: 1))
    case "psychic":
        return Color(CGColor(red: 222/255, green: 106/255, blue: 122/255, alpha: 1))
    case "bug":
        return Color(CGColor(red: 160/255, green: 163/255, blue: 69/255, alpha: 1))
    case "rock":
        return Color(CGColor(red: 191/255, green: 184/255, blue: 138/255, alpha: 1))
    case "ghost":
        return Color(CGColor(red: 104/255, green: 72/255, blue: 112/255, alpha: 1))
    case "dragon":
        return Color(CGColor(red: 82/255, green: 91/255, blue: 168/255, alpha: 1))
    case "dark":
        return Color(CGColor(red: 77/255, green: 74/255, blue: 73/255, alpha: 1))
    case "steel":
        return Color(CGColor(red: 105/255, green: 169/255, blue: 199/255, alpha: 1))
    case "fairy":
        return Color(CGColor(red: 116/255, green: 81/255, blue: 153/255, alpha: 1))
    default:
        return Color(CGColor(red: 217/255, green: 180/255, blue: 211/255, alpha: 1))
    }
}

func espanolizador(tipo:String) -> String {
    switch tipo{
    case "bug":
        return "bicho"
    case "dark":
        return "siniestro"
    case "dragon":
        return "dragon"
    case "electric":
        return "electrico"
    case "fairy":
        return "hada"
    case "fighting":
        return "lucha"
    case "fire":
        return "fuego"
    case "flying":
        return "volador"
    case "ghost":
        return "fantasma"
    case "grass":
        return "planta"
    case "ground":
        return "tierra"
    case "ice":
        return "hielo"
    case "poison":
        return "veneno"
    case "psychic":
        return "psiquico"
    case "rock":
        return "roca"
    case "steel":
        return "metal"
    case "water":
        return "agua"
    default:
        return "normal"
    }
}
