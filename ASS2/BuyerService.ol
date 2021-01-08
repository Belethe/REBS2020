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
          { //This newline is stupidly important! It doesn't work, if this { is on the line above!
               [quote(quote)]{
                    maxprice = 20
                    if (quote.price < maxprice) {
                         println@Console("Accepted price at "+quote.price+"DKK, since it's lower than "+maxprice+"DKK.")();
                         accept@BuyerSeller("Ok to buy chips for " + quote.price);
                         [details(invoice)]{println@Console("Received the invoice from Shipper: "+invoice)()}
                    } else {
                         println@Console("Rejected price at "+quote.price+"DKK, since it's higher than "+maxprice+"DKK.")();
                         reject@BuyerSeller("Not ok to buy chips for " + quote.price)
                    }
               }
          }
     }
}
