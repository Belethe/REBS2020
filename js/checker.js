var graphs = graphs || [] ; //If not already defined, set to empty
var logs = logs || [] ;


$(document).ready(function(e) {
    $('#btn-check').click(function(e) {
        var empty = false;
        var table = ""
        document.getElementById("check-error").innerHTML = "";
        console.log(JSON.stringify("checker"));
        if (graphs.length == 0) {
            document.getElementById("check-error").innerHTML += "Please define a graph<br />";
            empty = true;
        }
        else {
            document.getElementById("check-error").innerHTML += "There are "+graphs.length+" graphs<br />";
            console.log(graphs)
        }
        if (logs.length == 0) {
            document.getElementById("check-error").innerHTML += "Please write the log";
            empty = true
        }
        else {
            document.getElementById("check-error").innerHTML += "There are "+logs.length+" traces";
            console.log(logs)
        }
        results = []
        if(!empty){
            for (i = 0 ; i<graphs.length ; i++){ //for each graph
                console.log(JSON.stringify("GRAPH "+(i+1)))
                var successes = 0
                var fails = 0
                var hasFailed = false
                for (j = 0 ; j<logs.length ; j++){ //for each trace
                    var graph = _.cloneDeep(graphs[i]);
                    for (k = 0 ; k<logs[j].length ; k++){ //for each activity in trace
                        if (!graph.execute(logs[j][k][1])){
                            hasFailed = true
                            console.log(JSON.stringify(logs[j][0][0]+" did an unavailable event"))
                            break;
                        }
                    }
                    if (hasFailed){
                        fails += 1;
                    }
                    else {
                        if (graph.isAccepting()){
                            successes += 1;
                        }
                        else {
                            fails += 1;
                            console.log(JSON.stringify(logs[j][0][0]+" ended in a not accepting state"))
                        }
                    }
                    hasFailed = false;
                }
                results.push([successes,fails])
            }

            console.log(JSON.stringify("Results: "+results))
            table ="<table><tr><th>Graphs</th><th>Successes</th><th>Fails</th></tr>";
            for (i = 0 ; i < results.length ; i++){
                table += "<tr><td>Graph "+(i+1)+"</td><td>"+results[i][0]+"</td><td>"+results[i][1]+"</td></tr>"
            }
            table += "</table>"
            document.getElementById("check-results").innerHTML = table
        }

    });
});