include "InterfaceModules.iol"

include "console.iol"

service SellerService {

    execution{ single }

    outputPort SellerBuyer {
         location: "socket://localhost:8005"
         protocol: http { format = "json" }
         interfaces: SellerBuyerInterface
    }

    outputPort SellerShipper { // FIXME Should this be on channel 6?
         location: "socket://localhost:8003"
         protocol: http { format = "json" }
         interfaces: SellerShipperInterface
    }

    inputPort BuyerSeller {
         location: "socket://localhost:8004"
         protocol: http { format = "json" }
         interfaces: BuyerSellerInterface
    }
    main {
      [ask(product)]{
        price = 23;
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
