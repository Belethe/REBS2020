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
               price = 10;
               name = "Seller"
               quote@SellerBuyer(price);
               println@Console("Quoted buyer " + price + "DKK for " + product + ".")();

               [accept(sth)]{
               //   order@SellerShipper("Send the Buyer some "+product+", please.");
                    invoice.product = product;
                    invoice.price = price;
                    invoice.seller = name;
                    order@SellerShipper(invoice);
                    println@Console("The price was accepted.")()
               }

               [reject(sth)]{
                    println@Console("The price was rejected.")()
               }

          }
     }
}
