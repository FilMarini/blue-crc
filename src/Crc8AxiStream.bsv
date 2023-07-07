import CrcAxiStream :: *;
import CrcRawAxiStream :: *;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
///
/// Implementation of the CRC-8-CCITT standard (x^8 + x^2 + x^1 + 1)
///
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

typedef CrcAxiStream#(CRC8_WIDTH, AXIS64_KEEP_WIDTH, AXIS_USER_WIDTH) Crc8AxiStream64;
(* synthesize *)
module mkCrc8AxiStream64(Crc8AxiStream64);
    CrcConfig#(CRC8_WIDTH) conf = CrcConfig {
        polynominal: fromInteger(valueOf(CRC8_CCITT_POLY)),
        initVal    : fromInteger(valueOf(CRC8_CCITT_INIT_VAL)),
        finalXor   : fromInteger(valueOf(CRC8_CCITT_FINAL_XOR)),
        reflectData: False,
        reflectRemainder: False,
        memFilePrefix: "crc_gen_tab"
    };

    Crc8AxiStream64 crc8 <- mkCrcAxiStream(conf);
    return crc8;
endmodule

typedef CrcRawAxiStream#(CRC8_WIDTH, AXIS64_KEEP_WIDTH, AXIS_USER_WIDTH) Crc8RawAxiStream64;
(* synthesize *)
module mkCrc8RawAxiStream64(Crc8RawAxiStream64);
    CrcConfig#(CRC8_WIDTH) conf = CrcConfig {
        polynominal: fromInteger(valueOf(CRC8_CCITT_POLY)),
        initVal    : fromInteger(valueOf(CRC8_CCITT_INIT_VAL)),
        finalXor   : fromInteger(valueOf(CRC8_CCITT_FINAL_XOR)),
        reflectData: False,
        reflectRemainder: False,
        memFilePrefix: "crc_gen_tab"
    };

    Crc8RawAxiStream64 crc8 <- mkCrcRawAxiStream(conf);
    return crc8;
endmodule


typedef CrcAxiStream#(CRC8_WIDTH, AXIS128_KEEP_WIDTH, AXIS_USER_WIDTH) Crc8AxiStream128;
(* synthesize *)
module mkCrc8AxiStream128(Crc8AxiStream128);
    CrcConfig#(CRC8_WIDTH) conf = CrcConfig {
        polynominal: fromInteger(valueOf(CRC8_CCITT_POLY)),
        initVal    : fromInteger(valueOf(CRC8_CCITT_INIT_VAL)),
        finalXor   : fromInteger(valueOf(CRC8_CCITT_FINAL_XOR)),
        reflectData: False,
        reflectRemainder: False,
        memFilePrefix: "crc_gen_tab"
    };

    Crc8AxiStream128 crc8 <- mkCrcAxiStream(conf);
    return crc8;
endmodule

typedef CrcRawAxiStream#(CRC8_WIDTH, AXIS128_KEEP_WIDTH, AXIS_USER_WIDTH) Crc8RawAxiStream128;
(* synthesize *)
module mkCrc8RawAxiStream128(Crc8RawAxiStream128);
    CrcConfig#(CRC8_WIDTH) conf = CrcConfig {
        polynominal: fromInteger(valueOf(CRC8_CCITT_POLY)),
        initVal    : fromInteger(valueOf(CRC8_CCITT_INIT_VAL)),
        finalXor   : fromInteger(valueOf(CRC8_CCITT_FINAL_XOR)),
        reflectData: False,
        reflectRemainder: False,
        memFilePrefix: "crc_gen_tab"
    };

    Crc8RawAxiStream128 crc8 <- mkCrcRawAxiStream(conf);
    return crc8;
endmodule


typedef CrcAxiStream#(CRC8_WIDTH, AXIS256_KEEP_WIDTH, AXIS_USER_WIDTH) Crc8AxiStream256;
(* synthesize *)
module mkCrc8AxiStream256(Crc8AxiStream256);
    CrcConfig#(CRC8_WIDTH) conf = CrcConfig {
        polynominal: fromInteger(valueOf(CRC8_CCITT_POLY)),
        initVal    : fromInteger(valueOf(CRC8_CCITT_INIT_VAL)),
        finalXor   : fromInteger(valueOf(CRC8_CCITT_FINAL_XOR)),
        reflectData: False,
        reflectRemainder: False,
        memFilePrefix: "crc_gen_tab"
    };

    Crc8AxiStream256 crc8 <- mkCrcAxiStream(conf);
    return crc8;
endmodule

typedef CrcRawAxiStream#(CRC8_WIDTH, AXIS256_KEEP_WIDTH, AXIS_USER_WIDTH) Crc8RawAxiStream256;
(* synthesize *)
module mkCrc8RawAxiStream256(Crc8RawAxiStream256);
    CrcConfig#(CRC8_WIDTH) conf = CrcConfig {
        polynominal: fromInteger(valueOf(CRC8_CCITT_POLY)),
        initVal    : fromInteger(valueOf(CRC8_CCITT_INIT_VAL)),
        finalXor   : fromInteger(valueOf(CRC8_CCITT_FINAL_XOR)),
        reflectData: False,
        reflectRemainder: False,
        memFilePrefix: "crc_gen_tab"
    };

    Crc8RawAxiStream256 crc8 <- mkCrcRawAxiStream(conf);
    return crc8;
endmodule


typedef CrcAxiStream#(CRC8_WIDTH, AXIS512_KEEP_WIDTH, AXIS_USER_WIDTH) Crc8AxiStream512;
(* synthesize *)
module mkCrc8AxiStream512(Crc8AxiStream512);
    CrcConfig#(CRC8_WIDTH) conf = CrcConfig {
        polynominal: fromInteger(valueOf(CRC8_CCITT_POLY)),
        initVal    : fromInteger(valueOf(CRC8_CCITT_INIT_VAL)),
        finalXor   : fromInteger(valueOf(CRC8_CCITT_FINAL_XOR)),
        reflectData: False,
        reflectRemainder: False,
        memFilePrefix: "crc_gen_tab"
    };

    Crc8AxiStream512 crc8 <- mkCrcAxiStream(conf);
    return crc8;
endmodule

typedef CrcRawAxiStream#(CRC8_WIDTH, AXIS512_KEEP_WIDTH, AXIS_USER_WIDTH) Crc8RawAxiStream512;
(* synthesize *)
module mkCrc8RawAxiStream512(Crc8RawAxiStream512);
    CrcConfig#(CRC8_WIDTH) conf = CrcConfig {
        polynominal: fromInteger(valueOf(CRC8_CCITT_POLY)),
        initVal    : fromInteger(valueOf(CRC8_CCITT_INIT_VAL)),
        finalXor   : fromInteger(valueOf(CRC8_CCITT_FINAL_XOR)),
        reflectData: False,
        reflectRemainder: False,
        memFilePrefix: "crc_gen_tab"
    };

    Crc8RawAxiStream512 crc8 <- mkCrcRawAxiStream(conf);
    return crc8;
endmodule
