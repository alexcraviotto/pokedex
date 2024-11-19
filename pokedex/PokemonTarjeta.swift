//
//  PokemonTarjeta.swift
//  pokedex
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct PokemonTarjeta: View {
    var nombre:String = "Charizard"
    var tipo:String = "fire"
    var tipoS:String = "flying"
    var numero:String = "0006"
    var imagen:String = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"
    var body: some View {
        let color:Color = colorPicker(tipo: tipo)
        ZStack(){
            VStack(spacing: 0){
                ParteArriba(tipo: tipo, color: color, numero: numero).frame(height: 500)
                ParteAbajo(nombre: nombre, tipo: tipo, tipoS: tipoS, color: color)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 20,
                            topTrailingRadius: 20
                        )
                    )
                    .offset(CGSize(width: 0, height: -160))
            }.frame(width: .infinity, height: .infinity, alignment: .top)
            AsyncImage(url: URL(string: imagen)){ image in
                image
                    .image?.resizable()
                    .scaledToFit()
            }
            .frame(width: 300, height: 300)
            .offset(CGSize(width: 0, height: -100))
        }
    }
}

#Preview {
    PokemonTarjeta()
}

struct ParteArriba: View {
    var tipo:String
    var color:Color
    var numero:String
    var body: some View {
        ZStack{
            color
            VStack(){
                HStack(){
                    Text("#"+numero).padding(.leading)
                        .font(.custom("Press Start 2P Regular", size: 32))
                        .foregroundColor(.white)
                        .offset(CGSize(width: 0, height: 50))
                    Spacer()
                }
                HStack(){
                    Spacer()
                    ZStack{
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                            .frame(width: 190, height: 190)
                        Image(tipo)
                            .resizable()
                            .frame(width: 170, height: 170)
                    }
                }.padding(.trailing)
                    .offset(CGSize(width: 0, height: -20))
                Spacer()
            }.frame(height: .infinity, alignment: .top)
        }
    }
}

struct ParteAbajo: View {
    var nombre:String
    var tipo:String
    var tipoS:String
    var color:Color
    var body: some View {
        ZStack{
            Color.white
            VStack(spacing: 0){
                Text(nombre)
                    .font(.custom("Press Start 2P Regular", size: 32))
                HStack(){
                    Spacer()
                    VStack(){
                        ZStack(){
                            Circle()
                                .fill(color)
                                .frame(width: 70, height: 70)
                            Image(tipo)
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        Text(espanolizador(tipo: tipo))
                            .font(.custom("Press Start 2P Regular", size: 16))
                    }
                    Spacer()
                    VStack(){
                        ZStack(){
                            Circle()
                                .fill(colorPicker(tipo: tipoS))
                                .frame(width: 70, height: 70)
                            Image(tipoS)
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        Text(espanolizador(tipo: tipoS))
                            .font(.custom("Press Start 2P Regular", size: 16))
                    }
                    Spacer()
                }.offset(CGSize(width: 0, height: 80))
            }.frame(width: .infinity, alignment: .top)
        }
    }
}
