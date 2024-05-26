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
    var x: Double
    var y: Double
    var z: Double
    var element: String
    var connections: [Int] = []
}

struct Molecule {
    var atoms: [Atom] = []
}

class PDBParser {
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
    
    private func parseAtom(_ atoms: inout [Atom], _ line: String) -> Void {
        guard let indexString = getValue(line, from: 6, to: 10),
                    let name = getValue(line, from: 12, to: 15),
                  let xString = getValue(line, from: 30, to: 37),
                  let yString = getValue(line, from: 38, to: 45),
                  let zString = getValue(line, from: 46, to: 53),
                  let element = getValue(line, from: 76, to: 77),
                  let index = Int(indexString),
                  let x = Double(xString),
                  let y = Double(yString),
                  let z = Double(zString) else {
                print("error")
                return
            }
        
        atoms.append(Atom(index: index, name: name, x: x, y: y, z: z, element: element))
    }
    
    public func parsePDB(content: String) -> Molecule {
        var atoms: [Atom] = []
        var atomConnections: [Int: [Int]] = [:]
        
        let lines = content.components(separatedBy: "\n")
        for line in lines {
            let recordName = getValue(line, from: 0, to: 5)
            if recordName == "ATOM" {
                parseAtom(&atoms, String(line))
            } else if recordName == "CONECT" {
                
            } else if recordName == "END" {
                
            } else {
                
            }
            
        }
        return Molecule()
    }
}
