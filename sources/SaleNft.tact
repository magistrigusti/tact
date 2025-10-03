import "@stdlib/ownable";
import "@stdlib/deploy";
import "./messages";
import "./util.fc";

const service_numerator: Int = 11;
const service_denominator: Int = 1000;

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
    royalty_destiantion: Address?
    ) {
      self.owner = owner;
      self.nft = nft;
      self.jetton_master = jetton_master;
      self.numerator = numerator;
      self.denominator = denominator;
      self.royalty_destiantion: Address
  }

  receive(msg: Deploy) {

  }
}