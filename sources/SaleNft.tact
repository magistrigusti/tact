import "@stdlib/ownable";
import "@stdlib/deploy";
import "./messages";
import "./util.fc";

const sale_init_value: Int = ton("0.1");
const sale_processing_value: Int = ton("0.25");
const jetton_transfer: Int = ton("0.05");
const nft_transfer_value: Int = ton("0.04");

const service_numerator: Int = 11;
const service_denominator: Int = 1000;
const hundred_percent: Int = 100000000000;

@name(service_address)
native serviceAddress(): Address;

contract SaleNft with Ownable {
  owner: Address;
  nft: Address;
  nft_received: Bool = false;
  jetton_master: Address;
  jetton_wallet: Address? = null;
  numerator: Int as uint16;
  denominator: Int as uint16;
  royalty_destination: Address?;
  sale_ended: Bool = false;

  init(
    owner: Address, 
    nft: Address, 
    jetton_master: Address,
    numerator: Int,
    denominator: Int,
    royalty_destination: Address?
    ) {
      self.owner = owner;
      self.nft = nft;
      self.jetton_master = jetton_master;
      self.numerator = numerator;
      self.denominator = denominator;
      self.royalty_destination: royalty_destination
  }

  receive(msg: Deploy) {

  }
}