//
//  reproducirMusica.swift
//  pokedex
//
//  Created by Aula03 on 14/1/25.
//

import SwiftUI
import AVFoundation

class MusicPlayer:  ObservableObject{
    private var audioPlay: AVPlayer?
    
    func reproducirMusica(url: URL) {
        audioPlay = AVPlayer(url: url)
        audioPlay?.play()
    }
    
    func detenerMusica() {
        audioPlay?.pause()
    }
}
