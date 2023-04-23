import * as http from 'http';
const port = 80

let bootstrap = new Date().getTime()

// Create a server object:
const server = http.createServer(function (req, res) {
	//https://github.com/vitalets/google-translate-api

	let st = new Date().getTime()

	res.setHeader("Content-Type", "application/json; charset=utf-8");

	if (req.url === '/') {
		res.writeHead(200);
		res.write(JSON.stringify({ "msg": " ok ", "at": bootstrap }))
		res.end()
		return
	}

	if (req.url !== '/translate') {
		res.writeHead(404);
		res.write(JSON.stringify({ "msg": req.url + " not found" }))
		res.end()
		return
	}

	if (req.method != 'POST') {
		res.writeHead(422);
		res.write(JSON.stringify({ "msg": "Only POST method is allowed" }))
		res.end()
		return
	}

	res.writeHead(200);
	res.write(JSON.stringify({ "ok": 200 }))
	res.end()

}).listen(port, function (error) {
	// Checking any error occur while listening on port
	if (error) {
		console.log('Something went wrong', error);
	}
	// Else sent message of listening
	else {
		console.log('Server is listening on port: ' + port);
	}
})
