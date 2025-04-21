const bridge = require('flutter-bridge');

// Send message to Flutter when Node.js started
bridge.send("_NODE_", "STARTED");

console.log("Node.js started");

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

bridge.on("eval", (code) => {                         // Listen to tag eval and send execution result back to Flutter
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

bridge.on('ping', (message) => {                      // Listen to messages with tag ping sent from Flutter
  console.log(`GOT PING: ${message}`);
  bridge.send("pong", "Hello Flutter!")
});

bridge.on('msg', (message) => {
  console.log(`Received message: ${message}`);
  bridge.send("reply", "Hello " + message)
});

bridge.on('_EVENTS_', (data) => {                     // This Capture any type of message sent from Flutter
  if (typeof data === 'object' && data !== null) {
    data = JSON.stringify(data);
  }
  console.log(`EVENT: ${data}`);
});