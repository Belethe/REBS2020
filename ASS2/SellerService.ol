include "InterfaceModules.iol"

include "console.iol"

service SellerService {

    execution{ single }

    outputPort SellerBuyer {
         location: "socket://localhost:8002"
         protocol: http { format = "json" }
         interfaces: SellerBuyerInterface
    }

    outputPort SellerShipper {
         location: "socket://localhost:8003"
         protocol: http { format = "json" }
         interfaces: SellerShipperInterface
    }

    inputPort BuyerSeller {
         location: "socket://localhost:8000"
         protocol: http { format = "json" }
         interfaces: BuyerSellerInterface
    }
    
    main {
      [ask(product)]{
        price = 17;
        quote@SellerBuyer(price);
        println@Console("Quoted buyer " + price + "dkk for " + product + ".")();

        [ accept(sth)]{
            order@SellerShipper("Send the Buyer some "+product+", please.");
            println@Console("Accepted.")()
        }

        [reject(sth)]{
            println@Console("Rejected.")()
        }

      }
	}
}
