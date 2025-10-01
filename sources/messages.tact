message(0x2c366a1c) NftTransfer {
  query_id: Int as uint64;
  new_owner: Address;
  response_destination: Address;
  custom_payload: Cell?;
  forward_amount: Int as coins;
  forward_payload: Slice as remaining;
}

message(0x1155558e) NftOwnershipAssigned {
  query_id: Int as uint64;
  prev_owner: Address;
  forward_payload: Slice as remaining;
}

message(0xeb03d2f8) NftExcesses {
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

message(0xfea554d6) NftGetRoyaltyParams {
  query_id: Int as uint64;
}

message(0x4341e4b0) NftReportRoyaltyParams {
  query_id: Int as uint64;
  numerator: Int as uint16;
  denominator: Int as uint16;
  destination: Address;
}

message(0xacf1d041) NftDestroy {
  query_id: Int as uint64;
}

message NftDeploy {
  index: Int;
  owner: Address;
  content: Cell;
  royalty_destination: Address;
  numerator: Int as uint16;
  denominator: Int as uint16;
}