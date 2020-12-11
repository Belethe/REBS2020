// Oversæt csv til arrays (Kun ID, Title, Date, ét array pr ID)

// For hver array:
//     Sorter efter dato
//     Fjern "-"
//     for hver element i array:
//         Event.eneable()
//             if false:
//                 false+1
//                 break to next array
//         Event.execute()
//     sucesses+1

//import _ from "lodash"

var graphs = graphs || [] ; //If not already defined, set to empty
var logs = logs || [] ;


$(document).ready(function(e) {
    $('#btn-check').click(function(e) {
        var empty = false;
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
                var successes = 0
                var fails = 0
                var hasFailed = false
                for (j = 0 ; j<logs.length ; j++){ //for each trace
                    var graph = _.cloneDeep(graphs[i]); //XXX: THIS NEEDS TO BE A DEEP COPY!!
                    for (k = 0 ; k<logs[j].length ; k++){ //for each activity in trace
                        console.log(JSON.stringify("We are about to do: "+logs[j][k]))
                        if (!graph.execute(logs[j][k][1])){
                            hasFailed = true
                            console.log(JSON.stringify("failed after: "+k+" activities"))
                            break;
                        }
                    }
                    if (hasFailed){
                        fails += 1;
                    }
                    else {
                        successes += 1;
                    }
                    hasFailed = false;
                }
                results.push([successes,fails])
            }
        }
        console.log(JSON.stringify("Results: "+results))

    });
});
