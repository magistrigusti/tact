message(0x2c366a1c) NftTransfer {
  query_id: Int as uint64;
  new_owner: Address;
  response_destination: Address;
  custom_payload: Cell?;
  forward_amount: Int as coins;
  forward_payload: Cell;
}

message(0x1155558e) NftOwnershipAssigned {
  query_id: Int as uint64;
  prev_owner: Address;
  forward_payload: Cell;
}

message NftExcesses {
  query_id: Int as uint64;
}

message(0xefc4910d) NftGetStaticData {
  query_id: Int as uint64;
}

message(0x567f713c) NftReportStaticData {
  query_id: Int as uint64;
  index: Int as uint256;
  collection: Address;
}

