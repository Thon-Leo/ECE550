module zero_check (
    input [4:0] num,  // 5-bit input number
    output isZero     // Output: 1 if number is 0, 0 otherwise
);

    wire stage1;
    or (stage1, num[0], num[1]);

    wire stage2;
    or (stage2, num[2], num[3]);

    nor (isZero, stage1, stage2, num[4]);

endmodule
