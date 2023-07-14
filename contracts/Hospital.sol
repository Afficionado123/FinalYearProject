// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Hospital {
    uint256 value;
    struct hospitalIdentity {
        string name;
        address id;
        string license;
    }

    mapping (address=>hospitalIdentity) mapAddressToHospital;
    mapping (address => mapping(address=>uint))giveAccess;
    mapping(address => string) patientToCollectionId;
      mapping (address=>bool) isLoggedIn;
    mapping (address => string) listOfPatients;
      event loggedInStatus(bool hasLoggedIn);
     event getPatientList(string patListCollectionId);
    modifier checkIsApprovedOfAccess(address id) {
        hospitalIdentity memory d =  mapAddressToHospital[id];
        require(d.id > address(0x0)); //check if hospital exist
        _;
    }
 
    modifier checkIfCollectionExists(string memory id)
    {
        require(bytes(id).length>0);
        _;
    }
    modifier checkIfCollectionDoesntExists(string memory id)
    {
        require(bytes(id).length==0);
        _;
    }
    
    function giveAccessToDoc(address docAdd) public {
           giveAccess[msg.sender][docAdd]=1;
    }
    function getCollectionId(address pat_key)
        public
        view
        checkIsApprovedOfAccess(msg.sender)
        checkIfCollectionExists(patientToCollectionId[pat_key])
        returns (
            string memory
        )
    {
        return (patientToCollectionId[pat_key]);
    }

    function assignCollectionId(address pat_add,string memory key)
        public
        checkIsApprovedOfAccess(msg.sender)
        checkIfCollectionDoesntExists(patientToCollectionId[pat_add])
    {
       patientToCollectionId[pat_add] =key;
       emit getPatientList(listOfPatients[msg.sender]);
    }
   
      function signupHospital(
        string memory _name, string memory _license,string memory _collectionId
    ) public {
        hospitalIdentity memory p =mapAddressToHospital[msg.sender];
        require(keccak256(abi.encodePacked(_name)) != keccak256(""));
        require(keccak256(abi.encodePacked(_license)) != keccak256(""));
        mapAddressToHospital[msg.sender] = hospitalIdentity({
            name: _name,
            license:_license,
            id: msg.sender
        });
      listOfPatients[msg.sender]=_collectionId;
    }
    function LoginLogoutHos() public  checkIsApprovedOfAccess(msg.sender) {
               
         isLoggedIn[msg.sender]=!isLoggedIn[msg.sender];
         if( isLoggedIn[msg.sender] == true)
         {
               emit getPatientList(listOfPatients[msg.sender]);
         }
         emit loggedInStatus(isLoggedIn[msg.sender]);    
    }
    function read() public view returns (uint256) {
        return value;
    }

    function write(uint256 newValue) public {
        value = newValue;
    }
}

