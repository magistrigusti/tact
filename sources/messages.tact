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

message(0xe5e502a3) NftDeploy {
  index: Int;
  owner: Address;
  content: Cell;
  royalty_destination: Address;
  numerator: Int as uint16;
  denominator: Int as uint16;
}

message(0x5412742a) RequestNftDeploy {
  index: Int as uint256;
  amount: Int as coins;
  owner: Address;
  content: Cell;
  
}

message(0x502bcd76) ProvideWalletAddress {
  query_id: Int as uint64;
  owner_adress: Address;
  include_adress: Bool;
}

message(0x5b4d481c) TakeWalletAddress {
  query_id: Int as uint64;
  wallet_address: Address;
  owner_address: Address?;
}

message Transfer {
  query_id: Int as uint64;
  amount: Int as coins;
  destination: Address;
  response_destination: Address;
  custom_payload: Cell?;
  forward_ton_amount: Int as coins;
  forward_payload: Slice as remaining;
}

message TransferNotification {
  query_id: Int as uint64;
  amount: Int as coins;
  sender: Address;
  forward_payload: Slice as remaining;
}

