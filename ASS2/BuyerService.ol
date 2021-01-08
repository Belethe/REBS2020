include "InterfaceModules.iol"

include "console.iol"

service BuyerService {

    execution{ single }

    outputPort BuyerSeller {
         location: "socket://localhost:8000"
         protocol: http { format = "json" }
         interfaces: BuyerSellerInterface
    }

    inputPort ShipperBuyer {
         location: "socket://localhost:8001"
         protocol: http { format = "json" }
         interfaces: ShipperBuyerInterface
    }
    inputPort SellerBuyer {
         location: "socket://localhost:8002"
         protocol: http { format = "json" }
         interfaces: SellerBuyerInterface
    }
    main {
        ask@BuyerSeller("chips")
		{[quote(price)]{
      maxprice = 20
			if (price <maxprice) {
				println@Console( "price lower than "+maxprice)();
				accept@BuyerSeller("Ok to buy chips for " + price);
				[details(invoice)]{println@Console( "Received "+invoice+" from Shipper!")()}
			} else {
				println@Console( "price not lower than "+maxprice)();
				reject@BuyerSeller("Not ok to buy chips for " + price)
			}
		 }
    }
	}
}
