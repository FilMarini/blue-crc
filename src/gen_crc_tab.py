import sys
import os

BYTE_WIDTH = 8
BYTE_MAX_VAL = pow(2, BYTE_WIDTH) - 1


def bits_reverse(val: int, width: int):
    result = 0
    for i in range(width):
        result <<= 1
        result |= val & 1
        val >>= 1
    return result


def bits_left_shift(val: int, width: int, amt: int):
    mask = (1 << width) - 1
    return (val << amt) & mask


def bits_msb(val: int, width: int):
    return val >> (width - 1)


class CrcLookUpTable:
    def __init__(
        self,
        polynominal: bytes,
        init_val: bytes,
        final_xor: bytes,
        rev_input: bool,
        rev_output: bool,
    ):
        self.byte_order = "big"
        self.polynominal = polynominal
        self.init_val = init_val
        self.final_xor = final_xor
        self.rev_input = rev_input
        self.rev_output = rev_output
        self.byte_num = len(polynominal)
        self.bit_width = self.byte_num * BYTE_WIDTH
        assert len(init_val) == len(
            polynominal
        ), "The width of initial value doesn't match that of polynomial"
        assert len(final_xor) == len(
            polynominal
        ), "The width of final xor doesn't match that of polynominal"

    def add_byte_to_crc(self, byte_int: int, crc: bytes):
        assert byte_int <= BYTE_MAX_VAL, "The value of byte_int argument is illegal"

        crc_int = int.from_bytes(crc, self.byte_order)
        polynominal = int.from_bytes(self.polynominal, self.byte_order)

        if self.rev_input:
            byte_int = bits_reverse(byte_int, BYTE_WIDTH)

        byte_int = byte_int << (self.bit_width - BYTE_WIDTH)
        crc_int = crc_int ^ byte_int

        for i in range(BYTE_WIDTH):
            if bits_msb(crc_int, self.bit_width):
                crc_int = bits_left_shift(crc_int, self.bit_width, 1)
                crc_int = crc_int ^ polynominal
            else:
                crc_int = bits_left_shift(crc_int, self.bit_width, 1)

        return crc_int.to_bytes(self.byte_num, self.byte_order)

    def crc_output(self, crc: bytes):
        crc_int = int.from_bytes(crc, self.byte_order)
        final_xor_int = int.from_bytes(self.final_xor, self.byte_order)

        if self.rev_output:
            crc_int = bits_reverse(crc_int, self.bit_width)
        crc_int = crc_int ^ final_xor_int

        return crc_int.to_bytes(self.byte_num, self.byte_order)

    def gen_byte_crc_tab(self, offset: int):
        crc_table = []

        for i in range(BYTE_MAX_VAL + 1):
            crc = self.add_byte_to_crc(i, self.init_val)
            for j in range(offset):
                crc = self.add_byte_to_crc(0, crc)

            crc = self.crc_output(crc)
            crc_table.append(crc)

        return crc_table

    def gen_crc_tab_file(self, file_prefix: str, offset_range: range):
        for i in offset_range:
            file_name = file_prefix + f"_{i}.mem"
            file = open(file_name, "w")
            crc_table = self.gen_byte_crc_tab(i)
            for crc in crc_table:
                if self.byte_order == "little":
                    crc = crc[::-1]
                file.write(crc.hex() + "\n")
            file.close()


if __name__ == "__main__":
    crc8_tab = CrcLookUpTable(
        polynominal=b"\x07",
        init_val=b"\x00",
        final_xor=b"\x00",
        rev_input=False,
        rev_output=False,
    )
    crc16_tab = CrcLookUpTable(
        polynominal=b"\x80\x05",
        init_val=b"\x00\x00",
        final_xor=b"\x00\x00",
        rev_input=False,
        rev_output=False,
    )
    crc32_tab = CrcLookUpTable(
        polynominal=b"\x04\xC1\x1D\xB7",
        init_val=b"\x00\x00\x00\x00",
        final_xor=b"\x00\x00\x00\x00",
        rev_input=False,
        rev_output=False,
    )

    crc_width_opt = (8, 16, 32)
    crc_tab_map = {8: crc8_tab, 16: crc16_tab, 32: crc32_tab}
    standard_opt = ()  # TODO:

    assert len(sys.argv) >= 3, "The number of input arguments is incorrect."
    arg = sys.argv
    crc_width = int(arg[1])
    assert (
        crc_width in crc_width_opt
    ), f"Table generation of {crc_width}-bit hasn't been supported."
    input_width = int(arg[2])
    assert input_width % 8 == 0, f"The width of input data must be multiples of 8 bits."
    path = "."
    if len(sys.argv) > 3:
        path = arg[4]

    input_byte_num = int(input_width / 8)
    file_prefix = os.path.join(path, "crc_tab")
    crc_tab_map[crc_width].gen_crc_tab_file(file_prefix, range(input_byte_num))
