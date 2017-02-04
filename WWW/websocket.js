	var webSocket;
	//var connectBtn = document.getElementById("connectBtn");
	//var sendBtn = document.getElementById("sendBtn");

	function connect() {
	    // oprn the connection if one does not exist
	    if (webSocket !== undefined && webSocket.readyState !== WebSocket.CLOSED) {
	        return;
	    }
	    // Create a websocket - it shall be rather excluded from the dalogin into a separate project, with rabbitMQ
	    webSocket = new WebSocket("wss://milo.crabdance.com:28181/login/jsr356toUpper");

	    webSocket.onopen = function (event) {
            webSocket.send("Message to send");
            console.log("Connected!")
	        updateOutput("Connected!");
	        //connectBtn.disabled = true;
	        //sendBtn.disabled = false;

	    };

	    webSocket.onmessage = function (event) {
            console.log(event.data)
	        updateOutput(event.data);
	    };

	    webSocket.onclose = function (event) {
	       // updateOutput("Connection Closed");
	        connectBtn.disabled = false;
	        sendBtn.disabled = true;
	    };
	}

	function send() {
	    var text = document.getElementById("input").value;
	    webSocket.send(text);
	}

	function closeSocket() {
	    webSocket.close();
	}

	function updateOutput(text) {
        var output = document.getElementById("output");
        output.innerHTML += "<br/>" + text;
    }

	function main() {
	    // Initialization work goes here.
	}

	// Add event listeners once the DOM has fully loaded by listening for the
	// `DOMContentLoaded` event on the document, and adding your listeners to
	// specific elements when it triggers.
	document.addEventListener('DOMContentLoaded', function () {
	    document.querySelector('button').addEventListener('click', connect);
        document.querySelector('button').addEventListener('send', send);
	    main();
	});