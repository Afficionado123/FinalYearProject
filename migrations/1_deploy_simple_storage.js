const Hospital= artifacts.require("Hospital.sol");
const Patient= artifacts.require("Patient.sol")
module.exports = function (deployer) {
  deployer.deploy(Hospital);
  deployer.deploy(Patient);
};
