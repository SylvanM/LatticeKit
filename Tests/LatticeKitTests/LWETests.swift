//
//  LWETests.swift
//  
//
//  Created by Sylvan Martin on 7/1/23.
//

import XCTest
import LatticeKit
import BigNumber
import MatrixKit

final class LWETests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCorrectness() throws {
        let q: BN = 383
        let m = 3
        let n = 2
        let sigma: BN = 2
        
        let lwe = LWE(m: m, n: n, q: q, sigma: sigma)
        
        let (sk, pk) = lwe.gen()
        
        XCTAssertEqual(lwe.dec(sk, ciphertext: lwe.enc(pk, plaintext: .low)), .low)
        XCTAssertEqual(lwe.dec(sk, ciphertext: lwe.enc(pk, plaintext: .high)), .high)
    }
    
    func testExample() throws {
        let q: BN = 7
        let m = 3
        let n = 2
        let sigma: BN = 2
        
        let lwe = LWE(m: m, n: n, q: q, sigma: sigma)
        
        let a: Matrix<BN> = [
            [1, 3],
            [1, 4],
            [4, 5]
        ]
        
        let b: Matrix<BN> = [
            [2],
            [0],
            [2]
        ]
        
        let publicKey = (a, b)
        
        let s: Matrix<BN> = [
            [1],
            [0]
        ]
        
        // let's say we generate this encryption
        let d: Matrix<BN> = [
            [0],
            [0]
        ]
        let c: BN = 0
        
        // this ought to decrypt to .low
        
        XCTAssertEqual(lwe.dec(s, ciphertext: (d, c)), .low)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
