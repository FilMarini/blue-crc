import FIFOF :: *;
import Randomizable :: *;
import CRC :: *;
import Vector :: *;
import GetPut :: *;
import Connectable :: *;

import CrcAxiStream :: *;
import TestUtils :: *;

// Configuration of CRC Tester
typedef struct {
    Bit#(cycleCountWidth)  maxCycle;
    Bit#(caseCountWidth)   caseNum;
    CrcConfig#(crcWidth)   crcConfig;
} TestCrcAxiStreamConfig#(
    numeric type cycleCountWidth,
    numeric type caseCountWidth,
    numeric type caseByteNum,
    numeric type crcWidth,
    numeric type axiKeepWidth
);

module mkTestCrcAxiStream#(
    TestCrcAxiStreamConfig#(
        cycleCountWidth, 
        caseCountWidth, 
        caseByteNum, 
        crcWidth, 
        axiKeepWidth
    ) conf
)(Empty) provisos(
    Mul#(crcByteNum, BYTE_WIDTH, crcWidth),
    Mul#(caseByteNum, BYTE_WIDTH, caseWidth),
    Mul#(axiKeepWidth, BYTE_WIDTH, axiDataWidth),
    ReduceBalancedTree#(axiKeepWidth, Bit#(crcWidth)),
    ReduceBalancedTree#(crcByteNum, Bit#(crcWidth)),

    Add#(8, a__, caseWidth),
    Add#(8, e__, crcWidth),
    Mul#(8, b__, TAdd#(axiDataWidth, crcWidth)),
    Add#(caseByteNum, c__, TMul#(axiKeepWidth, TDiv#(caseWidth, axiDataWidth))),
    Add#(caseWidth, d__, TMul#(TDiv#(caseWidth, axiDataWidth), axiDataWidth))
);
    let crcConf = conf.crcConfig;
    Reg#(Bit#(caseCountWidth)) inputCaseCount <- mkReg(0);
    Reg#(Bit#(caseCountWidth)) outputCaseCount <- mkReg(0);
    Reg#(Bit#(TLog#(TAdd#(caseByteNum, 1)))) caseByteCount <- mkReg(0);
    
    CRC#(crcWidth) refCrcModel <- mkCRC(
        crcConf.polynominal, 
        crcConf.initVal, 
        crcConf.finalXor, 
        crcConf.reflectData, 
        crcConf.reflectRemainder
    );
    FIFOF#(CrcResult#(crcWidth)) refOutputBuf <- mkFIFOF;
    
    AxiStreamSender#(
        caseWidth, axiKeepWidth, AXIS_USER_WIDTH, caseCountWidth
    ) axiSender <- mkAxiStreamSender;
    CrcAxiStream#(crcWidth, axiKeepWidth, AXIS_USER_WIDTH) dutCrcModel <- mkCrcAxiStream(crcConf);
    
    mkConnection(dutCrcModel.crcReq, axiSender.axiStreamOut);

    Reg#(Bool) isInit <- mkReg(False);
    Reg#(Bit#(cycleCountWidth)) cycle <- mkReg(0);
    Randomize#(Bit#(caseWidth)) caseDataRand <- mkGenericRandomizer;
    
    rule doRandInit if (!isInit);
        caseDataRand.cntrl.init;
        refCrcModel.clear;
        isInit <= True;
    endrule

    rule doCycleCount if (isInit);
        cycle <= cycle + 1;
        immAssert(
            cycle != conf.maxCycle,
            "Testbench timeout assertion @ mkTestUdpEthRxTx",
            $format("Cycle count can't overflow %d", conf.maxCycle)
        );
        $display("\nCycle %d -----------------------------------", cycle);
    endrule
    
    Reg#(Bit#(caseWidth)) tempCaseData <- mkRegU;
    rule genTestCase if (isInit && inputCaseCount < conf.caseNum);
        if (caseByteCount == 0) begin
            let randData <- caseDataRand.next;
            tempCaseData <= randData;
            refCrcModel.add(truncateLSB(randData));
            caseByteCount <= caseByteCount + 1;
            $display("Gen random test case: %x", randData);
        end
        else if (caseByteCount < fromInteger(valueOf(caseByteNum))) begin
            Vector#(caseByteNum, Byte) caseDataVec = unpack(tempCaseData);
            caseDataVec = reverse(caseDataVec);
            refCrcModel.add(caseDataVec[caseByteCount]);
            caseByteCount <= caseByteCount + 1;
            $display("Add Ref Crc32: %x", caseDataVec[caseByteCount]);
        end
        else begin
            caseByteCount <= 0;
            inputCaseCount <= inputCaseCount + 1;
            axiSender.rawDataIn.put(tempCaseData);
            let refCheckSum <- refCrcModel.complete;
            refOutputBuf.enq(refCheckSum);
            $display("Generate %d input case: %x crc: %x", inputCaseCount, tempCaseData, refCheckSum);
        end
    endrule

    rule checkDutOuput if (isInit && outputCaseCount < conf.caseNum);
        let refOutput = refOutputBuf.first;
        refOutputBuf.deq;
        let dutOutput <- dutCrcModel.crcResp.get;
        $display("Revc case %d output: DUT=%x REF=%x", outputCaseCount,dutOutput, refOutput);
        immAssert(
            dutOutput == refOutput,
            "Check meta data from CrcAxiStream @ mkCrcAxiStream",
            $format("The output of dut and ref are inconsistent")
        );
        outputCaseCount <= outputCaseCount + 1;
    endrule

    rule doFinish if (outputCaseCount == conf.caseNum);
        $display("Pass all %d test cases!", conf.caseNum);
        $display("0");
        $finish;
    endrule
endmodule
