include "InterfaceModules.iol"

include "console.iol"

service ShipperService {

    execution{ concurrent }

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
      [order(invoice)]{
        details@ShipperBuyer("You have bought "+invoice.product+" for "+invoice.price+"DKK from "+invoice.location)
        println@Console("Invoice sent to buyer.")()
      }
    }
}
