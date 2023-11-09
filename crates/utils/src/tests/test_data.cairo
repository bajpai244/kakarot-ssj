fn legacy_rlp_encoded_tx() -> Span<u8> {
    // tx_format (EIP-155, unsigned): [nonce, gasPrice, gasLimit, to, value, data, chainId, 0, 0]
    // expected rlp decoding:  [ '0x', '0x3b9aca00', '0x1e8480', '0x1f9840a85d5af5bf1d1762f925bdaddc4201f984', '0x016345785d8a0000', '0xabcdef', '0x01', '0x', '0x' ]
    // message_hash: 0x89d3071d2bcc98141b16317ec8d912a76271ec052c2884674ddcd752b5ea91fe
    // chain id used: 0x1
    array![
        239,
        128,
        132,
        59,
        154,
        202,
        0,
        131,
        30,
        132,
        128,
        148,
        31,
        152,
        64,
        168,
        93,
        90,
        245,
        191,
        29,
        23,
        98,
        249,
        37,
        189,
        173,
        220,
        66,
        1,
        249,
        132,
        136,
        1,
        99,
        69,
        120,
        93,
        138,
        0,
        0,
        131,
        171,
        205,
        239,
        1,
        128,
        128
    ]
        .span()
}


fn eip_2930_encoded_tx() -> Span<u8> {
    // tx_format (EIP-2930, unsiged): 0x01  || rlp([chainId, nonce, gasPrice, gasLimit, to, value, data, accessList])
    // expected rlp decoding:  [ '0x01', '0x', '0x3b9aca00', '0x1e8480', '0x1f9840a85d5af5bf1d1762f925bdaddc4201f984', '0x016345785d8a0000', '0xabcdef', [], '0x', '0x14a38ea5e92fe6831b2137226418d03db2ab8cefd6f62bdfc0078787afa63f83', '0x6c89b2928b518445bef8d479167bb9aef73bab1871d1275fd8dcba3c1628a619']
    // message_hash: 0xacc506973edb7b4024d1698a4e7b066728f9ebcee1af4d8ec93d4382e79a62f0
    // chain id used: 0x1
    array![
        1,
        238,
        1,
        128,
        132,
        59,
        154,
        202,
        0,
        131,
        30,
        132,
        128,
        148,
        31,
        152,
        64,
        168,
        93,
        90,
        245,
        191,
        29,
        23,
        98,
        249,
        37,
        189,
        173,
        220,
        66,
        1,
        249,
        132,
        136,
        1,
        99,
        69,
        120,
        93,
        138,
        0,
        0,
        131,
        171,
        205,
        239,
        192
    ]
        .span()
}

fn eip_1559_encoded_tx() -> Span<u8> {
    // tx_format (EIP-1559, unsiged):  0x02 || rlp([chain_id, nonce, max_priority_fee_per_gas, max_fee_per_gas, gas_limit, destination, amount, data, access_list)
    // expected rlp decoding:   [ '0x01', '0x', '0x', '0x3b9aca00', '0x1e8480', '0x1f9840a85d5af5bf1d1762f925bdaddc4201f984', '0x016345785d8a0000', '0xabcdef', []]
    // message_hash: 0x598035333ab961ee2ff00db3f21703926c911a42f53222a1fc1757bd1e3c15f5
    // chain id used: 0x1
    array![
        2,
        239,
        1,
        128,
        128,
        132,
        59,
        154,
        202,
        0,
        131,
        30,
        132,
        128,
        148,
        31,
        152,
        64,
        168,
        93,
        90,
        245,
        191,
        29,
        23,
        98,
        249,
        37,
        189,
        173,
        220,
        66,
        1,
        249,
        132,
        136,
        1,
        99,
        69,
        120,
        93,
        138,
        0,
        0,
        131,
        171,
        205,
        239,
        192
    ]
        .span()
}
