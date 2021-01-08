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
         location: "socket://localhost:8005"
         protocol: http { format = "json" }
         interfaces: SellerBuyerInterface
    }
    outputPort BuyerSeller0 {
         location: "socket://localhost:8004"
         protocol: http { format = "json" }
         interfaces: BuyerSellerInterface
    }
    inputPort SellerBuyer0 {
         location: "socket://localhost:8002"
         protocol: http { format = "json" }
         interfaces: SellerBuyerInterface
    }
    inputPort ShipperBuyer {
         location: "socket://localhost:8001"
         protocol: http { format = "json" }
         interfaces: ShipperBuyerInterface
    }
    main {
    ask@BuyerSeller0("chips"){
      [quote(price0)]{
        ask@BuyerSeller("chips")
    		{[quote(price)]{
          maxprice = 20
          if price <= price0 && price < maxprice{
            accept@BuyerSeller("Ok to buy chips for " + price);
            reject@BuyerSeller0("Not ok to buy chips for " + price0);
            println@Console( "accepted "+price+" from Seller, rejected "+ price0+ " from Seller0")()
          }else if(price0<maxprice){
            accept@BuyerSeller0("Ok to buy chips for " + price0);
            reject@BuyerSeller("Not ok to buy chips for " + price);
            println@Console( "accepted "+price0+" from Seller0, rejected "+ price+ " from Seller1")()
          }else{
            reject@BuyerSeller("Not ok to buy chips for " + price);
            reject@BuyerSeller0("Not ok to buy chips for " + price);
            println@Console( "Rejected both "+price+" and "+price0+"from Seller and Seller0, respectively.")()
          }
          [details(invoice)]{println@Console( "Received "+invoice+" from Shipper!")()}
    		 }
        }
      }
    }

	}
}
