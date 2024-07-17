import Foundation
import os

class ONNXProcessor {
    public static func decodeImg(inputData: [[[[Double]]]]?) -> [[[[Double]]]] {
        do {
            var ortEnv = try ORTEnv(loggingLevel: ORTLoggingLevel.info)
            var options = try ORTSessionOptions()
            try options.setLogSeverityLevel(ORTLoggingLevel.info)

            var session = try ORTSession.init(
                env: ortEnv, 
                modelPath: Bundle.main.path(
                    forResource: "decoder_quant", 
                    ofType: "ort"
                )!,
                sessionOptions: options
            )

            var inputName = try session.inputNames()[0]
            var inputTensor = try ORTValue.init(
                tensorData: ONNXProcessor.from4DToNSMutableData(
                    inputData: ONNXProcessor.convertToFloatArray(inputData: inputData)
                ), 
                elementType: ORTTensorElementDataType.float, 
                shape: [
                    inputData!.count as NSNumber, 
                    inputData![0].count as NSNumber, 
                    inputData![0][0].count as NSNumber, 
                    inputData![0][0][0].count as NSNumber
                ]
            )

            var output = try session.run(
                withInputs: [inputName: inputTensor], 
                outputNames: Set(session.outputNames()),
                runOptions: nil
            )

            var decodeImg: [[[[Double]]]] = ONNXProcessor.convertToDoubleArray(
                inputData: ONNXProcessor.fromNSMutableDatato4DFloat(
                    data: try output[try session.outputNames()[0]]!.tensorData(), 
                    initDim: try output[try session.outputNames()[0]]!.tensorTypeAndShapeInfo().shape
                )
            )
            return decodeImg
        } catch {
            return [[[[Double]]]]()
        }
    }

    private static func flattenArray(array: [Any]) -> [Float] {
        var flattenedArray: [Float] = []
        array.forEach {
            if let elem = $0 as? Float {
                flattenedArray.append(elem)
            }
            if let elem = $0 as? [Any] {
                let flattened = flattenArray(array: elem)
                flattened.forEach { flattenedArray.append($0) }
            }
        }
        return flattenedArray
    }

    private static func from4DToNSMutableData(inputData: [[[[Float]]]]) -> NSMutableData {
        var flattenedArray: [Float] = flattenArray(array: inputData)
        
        return NSMutableData(bytes: flattenedArray, length: flattenedArray.count * MemoryLayout<Float>.size)
    }

    private static func fromNSMutableDatato4DFloat(data: NSMutableData, initDim: [NSNumber]) -> [[[[Float]]]] {
        let dim = [initDim[0].intValue, initDim[1].intValue, initDim[2].intValue, initDim[3].intValue]

        var result = Array(
            repeating: Array(
                repeating: Array(
                    repeating: Array(
                        repeating: Float(0), 
                        count: dim[3]), 
                    count: dim[2]), 
                count: dim[1]), 
            count: dim[0])

        let pointer = data.mutableBytes.assumingMemoryBound(to: Float.self)
        var converted = Array(UnsafeBufferPointer(start: pointer, count: data.length / MemoryLayout<Float>.size))

        for i in 0..<dim[0] {
            for j in 0..<dim[1] {
                for k in 0..<dim[2] {
                    for l in 0..<dim[3] {
                        let index = i * dim[1] * dim[2] * dim[3] + j * dim[2] * dim[3] + k * dim[3] + l
                        result[i][j][k][l] = converted[index]
                    }
                }
            }
        }
        return result
    }

    private static func convertToFloatArray(inputData: [[[[Double]]]]?) -> [[[[Float]]]] {
        if (inputData == nil) { return [[[[Float]]]]() }
        
        var result: [[[[Float]]]] = Array(repeating: [[[Float]]](), count: inputData!.count)
        for i in 0..<inputData!.count {
            result[i] = Array(repeating: [[Float]](), count: inputData![i].count)
            for j in 0..<inputData![i].count {
                result[i][j] = Array(repeating: [Float](), count: inputData![i][j].count)
                for k in 0..<inputData![i][j].count {
                    result[i][j][k] = Array(repeating: Float(0.0), count: inputData![i][j][k].count)
                    for l in 0..<inputData![i][j][k].count {
                        result[i][j][k][l] = Float(inputData![i][j][k][l])
                    }
                }
            }
        }

        return result
    }

    private static func convertToDoubleArray(inputData: [[[[Float]]]]?) -> [[[[Double]]]] {
        if (inputData == nil) { return [[[[Double]]]]() }
        
        var result: [[[[Double]]]] = Array(repeating: [[[Double]]](), count: inputData!.count)
        for i in 0...(inputData!.count - 1) {
            result[i] = Array(repeating: [[Double]](), count: inputData![i].count)
            for j in 0...(inputData![i].count - 1) {
                result[i][j] = Array(repeating: [Double](), count: inputData![i][j].count)
                for k in 0...(inputData![i][j].count - 1) {
                    result[i][j][k] = Array(repeating: Double(0.0), count: inputData![i][j][k].count)
                    for l in 0...(inputData![i][j][k].count - 1) {
                        result[i][j][k][l] = Double(inputData![i][j][k][l])
                    }
                }
            }
        }

        return result
    }
}
