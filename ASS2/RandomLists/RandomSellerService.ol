include "InterfaceModules.iol"

include "console.iol"
include "math.iol"

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
         location: LOCATION
         protocol: http { format = "json" }
         interfaces: BuyerSellerInterface
    }

    init {
      random@Math()( r );
      round@Math ( r*6 )( r );
      global.price = int(22-r);
      println@Console("The price of chips is: " + global.price)()
    }

    main {
          [ask(product)]{
               invoice.product = product;
               invoice.price = global.price;
               invoice.location = LOCATION;

               quote@SellerBuyer(invoice);
               println@Console("Quoted buyer " + invoice.price + "DKK for " + invoice.product + ".")();

               [accept(sth)]{
                 println@Console("The price was accepted.")();
                 order@SellerShipper(invoice)
                 exit
               }

               [reject(sth)]{
                    println@Console("The price was rejected.")()
                    exit
               }
          }
     }
}
