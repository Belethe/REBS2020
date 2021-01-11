include "mosquitto/interfaces/MosquittoInterface.iol"
include "console.iol"
include "string_utils.iol"

execution {concurrent}

inputPort Server {
    Location: "local"
    Protocol: sodep
    Interfaces: MosquittoReceiverInteface
}

outputPort Mosquitto {
    Interfaces: MosquittoInterface
}

embedded {
    Java:
        "org.jolielang.connector.mosquitto.MosquittoConnectorJavaService" in Mosquitto
}

init {
    request << {
        brokerURL = "tcp://broker.hivemq.com",
        subscribe << {
            topic = "pmcep/Disco Example Log/#"
        }
        // I can set all the options available from the Paho library
    }
    setMosquitto@Mosquitto (request)()
}

main {
    receive (request)
    println@Console("Current event topic: "+request.topic+"\nLog:")()
    s=request.topic
    s.regex = "/"
    split@StringUtils( s )( s )
    activity = s.result[3]
    global.counters.(activity)++
    foreach(c: global.counters){
      println@Console(c+":"+global.counters.(c))()
    }
    println@Console("")()
}
