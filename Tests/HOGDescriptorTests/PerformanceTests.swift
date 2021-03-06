import XCTest
import HOGDescriptor
import Accelerate

class PerformanceTests: XCTestCase {
    
    let width = 512
    let height = 512
    let image = try! loadAstronautGray()
    
    let iterations = 100

    func testPerformanceL1() {
        let hogDescriptor = HOGDescriptor(orientations: 9, cellSpan: 8, blockSpan: 3, normalization: .l1)
        
        measure {
            for _ in 0..<iterations {
                _ = hogDescriptor.getDescriptor(data: image, width: width, height: height)
            }
        }
    }
    
    func testPerformanceL1WithBuffers() {
        let hogDescriptor = HOGDescriptor(orientations: 9, cellSpan: 8, blockSpan: 3, normalization: .l1)
        
        var output = [Double](repeating: 0, count: hogDescriptor.getDescriptorSize(width: width, height: height))
        var workspaces = hogDescriptor.createWorkspaces(width: width, height: height)
        
        measure {
            for _ in 0..<iterations {
                _ = hogDescriptor.getDescriptor(data: .init(start: image, count: image.count),
                                                width: width,
                                                height: height,
                                                descriptor: .init(start: &output, count: output.count),
                                                workspaces: &workspaces)
            }
        }
    }
    
    func testPerformanceL1sqrt() {
        let hogDescriptor = HOGDescriptor(orientations: 9, cellSpan: 8, blockSpan: 3, normalization: .l1sqrt)
        
        measure {
            for _ in 0..<iterations {
                _ = hogDescriptor.getDescriptor(data: image, width: width, height: height)
            }
        }
    }
    
    func testPerformanceL2() {
        let hogDescriptor = HOGDescriptor(orientations: 9, cellSpan: 8, blockSpan: 3, normalization: .l2)
        
        measure {
            for _ in 0..<iterations {
                _ = hogDescriptor.getDescriptor(data: image, width: width, height: height)
            }
        }
    }
    
    func testPerformanceL2Hys() {
        let hogDescriptor = HOGDescriptor(orientations: 9, cellSpan: 8, blockSpan: 3, normalization: .l2Hys)
        
        measure {
            for _ in 0..<iterations {
                _ = hogDescriptor.getDescriptor(data: image, width: width, height: height)
            }
        }
    }
}
