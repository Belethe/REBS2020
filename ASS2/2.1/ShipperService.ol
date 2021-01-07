include "InterfaceModules.iol"

include "console.iol"

service ShipperService {

    execution{ single }

    outputPort ShipperBuyer {
         location: "socket://localhost:8001"
         protocol: http { format = "json" }
         interfaces: ShipperBuyerInterface
    }
    inputPort SellerShipper {
         location: "socket://localhost:8003"
         protocol: http { format = "json" }
         interfaces: SellerShipperInterface
    }
    main {
      [order(price)]{
        details@ShipperBuyer("This is the invoice")
      }
    }
}
