//
//  PDBParser.swift
//  SwiftyProteins
//
//  Created by Julien Caucheteux on 26/05/2024.
//

import Foundation

struct Atom {
    var index: Int
    var name: String
    var x: Float
    var y: Float
    var z: Float
    var element: String
    var connections: [Int] = []
}

struct Molecule {
    var atoms: [Atom] = []
}

class PDBParser {
    enum PDBParserError: Error {
        case InvalidRecordName
        case InvalidAtomLine
        case InvalidConectLine
        case InvalidAtomNumber
    }
    
    private func substring(_ input: String, from start: Int, to end: Int) -> String? {
        guard start >= 0, end < input.count, start <= end else {
            return nil
        }
        
        let startIndex = input.index(input.startIndex, offsetBy: start)
        let endIndex = input.index(input.startIndex, offsetBy: end)
        
        return String(input[startIndex...endIndex])
    }
    
    private func getValue(_ line: String, from start: Int, to end: Int) -> String? {
        let value = substring(line, from: start, to: end)
        guard let value = value else {
            return nil
        }
        return value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func parseAtom(_ atoms: inout [Atom], _ line: String) throws -> Void {
        guard let indexString = getValue(line, from: 6, to: 10),
              let name = getValue(line, from: 12, to: 15),
              let xString = getValue(line, from: 30, to: 37),
              let yString = getValue(line, from: 38, to: 45),
              let zString = getValue(line, from: 46, to: 53),
              let element = getValue(line, from: 76, to: 77),
              let index = Int(indexString),
              let x = Float(xString),
              let y = Float(yString),
              let z = Float(zString) else {
            throw PDBParserError.InvalidAtomLine
        }
        
        atoms.append(Atom(index: index, name: name, x: x, y: y, z: z, element: element))
    }
    
    private func parseConect(_ atomConnections: inout [Int: [Int]], _ line: String) throws -> Void {
        guard let mainIndexString = getValue(line, from: 6, to: 10),
              let mainIndex = Int(mainIndexString) else {
            throw PDBParserError.InvalidConectLine
        }
        
        for i in stride(from: 11, to: line.count, by: 5) {
            guard let connectedIndexString = getValue(line, from: i, to: i + 4),
                  let connectedIndex = Int(connectedIndexString) else {
                throw PDBParserError.InvalidConectLine
            }
            atomConnections[mainIndex, default: []].append(connectedIndex)
        }
    }
    
    public func parsePDB(content: String) throws -> Molecule {
        var atoms: [Atom] = []
        var atomConnections: [Int: [Int]] = [:]
        
        let lines = content.components(separatedBy: "\n")
        for line in lines {
            let recordName = getValue(line, from: 0, to: 5)
            if recordName == "ATOM" {
                try parseAtom(&atoms, line)
            } else if recordName == "CONECT" {
                try parseConect(&atomConnections, line)
            } else if recordName != "END" {
                throw PDBParserError.InvalidRecordName
            } else {
                break
            }
        }
        
        for (index, connections) in atomConnections {
            if index - 1 < atoms.count {
                atoms[index - 1].connections = connections
            }
        }
        
        let molecule: Molecule = Molecule(atoms: atoms)
        
        if molecule.atoms.isEmpty {
            throw PDBParserError.InvalidAtomNumber
        }
        
        return molecule
    }
}
