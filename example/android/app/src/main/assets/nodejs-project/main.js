const bridge = require('flutter-bridge');

console.log("Node.js started");
bridge.send("_NODE_", "STARTED");

function executeAndCapture(code) {
  let output = "";

  const sandboxConsole = {
      log: (...args) => {
          output += args.join(" ") + "\n";
      }
  };

  const wrappedCode = `
      (function(console) {
          ${code}
      })(sandboxConsole);
  `;

  try {
      eval(wrappedCode);
  } catch (e) {
      output += "Error: " + e.message + "\n";
  }

  return output.trim();
}

bridge.on("eval", (code) => {
  console.log(`Received eval code: ${code}`);
  try {
    const result = executeAndCapture(code);
    console.log(result);
    bridge.send("eval", result);
  } catch (error) {
    console.error(`Eval error: ${error}`);
    bridge.send("eval", `<ERROR: ${error.message}>`);
  }
});

bridge.on('ping', (message) => {
  console.log(`GOT PING: ${message}`);
  bridge.send("pong", "Hello Flutter!")
});

bridge.on('msg', (message) => {
  console.log(`Received message: ${message}`);
  bridge.send("reply", "Hello " + message)
});

bridge.on('_EVENTS_', (data) => {
  if (typeof data === 'object' && data !== null) {
    data = JSON.stringify(data);
  }
  console.log(`EVENT: ${data}`);
});