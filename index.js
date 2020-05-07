var bleno = require("bleno");

var name = "name";
var serviceUuids = ["fffffffffffffffffffffffffffffff0"];

bleno.on("stateChange", (state) => {
  bleno.startAdvertising(name, serviceUuids, (err) => {
    console.log(err);
  });

  console.log(state);
});
