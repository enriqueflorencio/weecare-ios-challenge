//
//  weecare_ios_challengeTests.swift
//  weecare-ios-challengeTests
//
//  Created by Enrique Florencio on 9/29/21.
//

import XCTest
@testable import weecare_ios_challenge

class WeeCareNetworkTests: XCTestCase {
    private let network = Network(
        sessionConfig: URLSessionConfiguration.default
    )
    private lazy var iTunesAPI : ITunesAPI = {
        let api = ITunesAPI(network: network)
        return api
    }()
    private var albumLimit = 10
    private let expectationTimeout = 30.0
    private var albums = [Album]()

    override func setUp() {
        continueAfterFailure = false
    }
    
    func testAPIRequests() {
        let getAlbumExpectation = XCTestExpectation(description: "async album get request")
        getTopAlbumsFromApi(expectation: getAlbumExpectation)
        wait(for: [getAlbumExpectation], timeout: expectationTimeout)
        
        let getArtworkExpectation = XCTestExpectation(description: "async artwork get request")
        getAlbumImageFromApi(expectation: getArtworkExpectation)
        wait(for: [getArtworkExpectation], timeout: expectationTimeout)
    }
    
    private func getTopAlbumsFromApi(expectation: XCTestExpectation) {
        iTunesAPI.getTopAlbums(limit: albumLimit) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return XCTFail()}
                let resultCount = data.feed.results.count
                XCTAssertEqual(resultCount, self.albumLimit, "The amount of albums fetched from the API are not equal to the amount we requested.")
                self.albums = data.feed.results
                expectation.fulfill()
            case .failure(let err):
                XCTFail("Get Top Albums Failed: \(err.localizedDescription)")
            }
            
        }
    }
    
    private func getAlbumImageFromApi(expectation: XCTestExpectation) {
        if let albumArtworkURL = albums.first?.artworkUrl100 {
            let apiRequest = APIRequest(url: albumArtworkURL)
            network.requestData(apiRequest) { (result) in
                switch result {
                case .success(let data):
                    XCTAssertNotNil(data, "The artwork fetched from the API is nil.")
                    expectation.fulfill()
                case .failure(let err):
                    XCTFail("Get Album Artwork Failed: \(err.localizedDescription)")
                }
            }
        }
        
    }
    
    
    
    

}
