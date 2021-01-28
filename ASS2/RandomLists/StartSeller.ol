include "console.iol"
include "runtime.iol"

include "InterfaceModules.iol"

outputPort SellerPR {
     location: "socket://localhost:8038"
     protocol: http { format = "json" }
     interfaces: SellerPRInterface
}

init {
  registerForInput@Console()()
}

//  args[0] specifies the listening location
init {
    if ( #args != 1 ) {
      println@Console( "Usage: jolie StartSeller.ol <location>")();
      throw( Error )
    }
    ;
    /* dynamic embedding of user_service.ol */
    with( emb ) {
        .filepath = "-C LOCATION=\"" + args[ 0 ] + "\" RandomSellerService.ol";
        .type = "Jolie"
    };
    loadEmbeddedService@Runtime( emb )();
    _location = args[0]
}

main {

  // Register location with PR.
    register@SellerPR({str = args[0]})(res);
    println@Console("I registered and got the response: " + res + ".")()

    while( cmd != "exit" ) {
        in( message ); // Not sure what "in" is, but it keeps the service alive.
        println@Console("use command ctrl+C to exit.")()
    }

    /*with( add_req ) {
        .chat_name = args[1];
        .username = args[2];
        .location = args[0]
    };
    addChat@ChatRegistry( add_req )( add_res );
    token = add_res.token;
    while( cmd != "exit" ) {
        in( message );
        sendMessage@ChatRegistry( { .token = token, .message=message } )()
    }
    */
}
