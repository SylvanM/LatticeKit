//
//  Primitives.swift
//
//  A collection of protocols describing cryptographic primitives
//
//  Created by Sylvan Martin on 7/1/23.
//

import Foundation

/**
 * A public key encryption scheme
 */
public protocol PKEScheme {
    
    // MARK: Types
    
    /**
     * The secret key type of this scheme
     */
    associatedtype SecretKey
    
    /**
     * The public key type of this scheme
     */
    associatedtype PublicKey
    
    /**
     * The plaintext type of this scheme
     */
    associatedtype Plaintext
    
    /**
     * The ciphertext type of this scheme
     */
    associatedtype Ciphertext
    
    // MARK: Methods
    
    /**
     * Generates a public and secret key pair
     */
    func gen() -> (SecretKey, PublicKey)
    
    /**
     * Encrypts a `Plaintext` given a `PublicKey`
     */
    func enc(_: PublicKey, plaintext: Plaintext) -> Ciphertext
    
    /**
     * Decrypts a `Ciphertext` from a given `SecretKey`
     */
    func dec(_: SecretKey, ciphertext: Ciphertext) -> Plaintext
    
}
