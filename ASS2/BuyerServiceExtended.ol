include "InterfaceModules.iol"

include "console.iol"

service BuyerService {

  execution{ single }

  outputPort BuyerSeller {
        location: "socket://localhost:8000"
        protocol: http { format = "json" }
        interfaces: BuyerSellerInterface
  }
  inputPort SellerBuyer {
        location: "socket://localhost:8002"
        protocol: http { format = "json" }
        interfaces: SellerBuyerInterface
  }
  outputPort BuyerSeller0 {
        location: "socket://localhost:8004"
        protocol: http { format = "json" }
        interfaces: BuyerSellerInterface
  }
  inputPort SellerBuyer0 {
        location: "socket://localhost:8005"
        protocol: http { format = "json" }
        interfaces: SellerBuyerInterface
  }
  inputPort ShipperBuyer {
        location: "socket://localhost:8001"
        protocol: http { format = "json" }
        interfaces: ShipperBuyerInterface
  }
  main {
      // We really wanted this bit to be concurrent.
      ask@BuyerSeller("chips")
      {
        [quote(quote)]
      }
      ask@BuyerSeller0("chips")
      {
        [quote(quote0)]
      }
    maxprice = 20;
    accepted = true;
    if(quote.price <= quote0.price && quote.price < maxprice){
      accept@BuyerSeller("Ok to buy chips for " + quote.price);
      reject@BuyerSeller0("Not ok to buy chips for " + quote0.price);
      println@Console("Accepted "+quote.price+" from "+quote.seller+", rejected "+quote0.price+" from "+quote0.seller+".")()
    }else if(quote0.price < maxprice){ // This is where it goes wrong. I think.
      accept@BuyerSeller0("Ok to buy chips for "+quote0.price);
      reject@BuyerSeller("Not ok to buy chips for "+quote.price);
      println@Console("Accepted "+quote0.price+" from "+quote0.seller+", rejected "+quote.price+" from "+quote.seller+".")()
    }else{
      reject@BuyerSeller("Not ok to buy chips for " + quote.price);
      reject@BuyerSeller0("Not ok to buy chips for " + quote0.price);
      println@Console("Rejected both "+quote.price+" and "+quote0.price+" from "+quote.seller+" and "+quote0.seller+", respectively.")()
      accepted = false
    }
    if(accepted){
      [details(invoice)]{
        println@Console("Received the invoice from Shipper: "+invoice)()
      }
    }
  }
}
