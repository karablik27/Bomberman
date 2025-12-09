//
//  ServerEventDecoderProtocol.swift
//  Bomberman
//
//  Created by Karabelnikov Stepan on 09.12.2025.
//

protocol ServerEventDecoderProtocol {
    func decode(_ text: String) -> ServerEvent?
}
