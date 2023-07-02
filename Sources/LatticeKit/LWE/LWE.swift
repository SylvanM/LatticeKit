//
//  LWE.swift
//  
//
//  Created by Sylvan Martin on 7/1/23.
//

import Foundation
import BigNumber
import MatrixKit

/**
 * The Learning With Errors encryption scheme over integer lattices
 */
public struct LWE: PKEScheme {
    
    // MARK: Properties
    
    public let m: Int
    
    public let n: Int
    
    public let q: BigNumber
    
    public let sigma: BigNumber
    
    public typealias SecretKey = Matrix<BN>
    
    public typealias PublicKey = (a: Matrix<BN>, b: Matrix<BN>)
    
    public enum Plaintext {
        case low
        case high
    }
    
    public typealias Ciphertext = (d: Matrix<BN>, c: BN)
    
    // MARK: Initializers
    
    public init(m: Int, n: Int, q: BigNumber, sigma: BigNumber) {
        self.m = m
        self.n = n
        self.q = q
        self.sigma = sigma.mod(q)
    }
    
    // MARK: Methods
    
    public func gen() -> (SecretKey, PublicKey) {
        let a = Matrix<BN>(rows: m, cols: n) { _, _ in
            BN.random(in: 0..<q)
        }
        
        print("Generated a:")
        print(a)
        
        let s = Matrix<BN>(rows: n, cols: 1) { _, _ in
            BN.random(in: 0..<q)
        }
        
        print("Generated s:")
        print(s)
        
        let e = Matrix<BN>(rows: m, cols: 1) { _, _ in
            BN.random(in: -sigma..<sigma).mod(q)
        }
        
        print("Generated e:")
        print(e)
        
        let b = ((a * s) + e).applyingToAll { x in
            x.mod(q)
        }
        
        print("Generated b := a * s + e  mod q")
        print(b)
        
        return (s, (a: a, b: b))
    }
    
    public func enc(_ publicKey: PublicKey, plaintext: Plaintext) -> Ciphertext {
        let mu = plaintext == .low ? 0 : q / 2
        
        print("Encrypting \(mu), which is \(plaintext)")
        
        let t = Matrix<BN>(rows: m, cols: 1) { _, _ in
            BN.random(in: 0...1)
        }
        
        print("Generated t:")
        print(t)
        
        let d = (t.transpose * publicKey.a).applyingToAll { x in
            x.mod(q)
        }.transpose
        
        print("Computed dT = (tT * a)  mod q")
        print(d.transpose)
        
        let c = (publicKey.b.innerProduct(with: t) + mu).mod(q)
        
        print("Computed c = <b, t> + mu  mod q")
        print(c)
        
        return (d, c)
    }
    
    public func dec(_ secretKey: SecretKey, ciphertext: Ciphertext) -> Plaintext {
        print("Decrypting ")
        
        print("Computing c - <s, d>  mod q")
        
        let mu = (ciphertext.c - secretKey.innerProduct(with: ciphertext.d)).mod(q)
        
        print(mu)
        print("So our decryption is: ", terminator: "")
        
        if mu <= q / 4 || mu >= (3 * q) / 4 {
            print("low")
            return .low
        } else {
            print("high")
            return .high
        }
    }

}
