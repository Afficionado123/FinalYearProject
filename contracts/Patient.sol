// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Patient {
    uint256 value;
    uint256 c;
    struct patient {
        string name;
        uint8 age;
        string record_id;
        address add;
        uint8 height;
        uint8 weight;
    }

    mapping(address => patient) patients;
    mapping(address => string) CollectionId;
    mapping(address=>mapping(address =>bool)) hasAccessToCollectionId;

    function getCollectionId()
        public
        view
        checkPatient(msg.sender)
        returns (
            string memory
        )
    {
        return (CollectionId[msg.sender]);
    }
    event givePatientHistory(string collectionOfPatientHistory);
    function giveCollectionIdAccess(address hos_id) public checkPatient(msg.sender)
    {
        hasAccessToCollectionId[msg.sender][hos_id]=true;
        emit  givePatientHistory(CollectionId[msg.sender]);
    }
    function giveCollectionIdAccessForUpdate(address pat_id) public{
        require(hasAccessToCollectionId[pat_id][msg.sender]==true);
        emit  givePatientHistory(CollectionId[msg.sender]);
    }
    function hasAccess(address pat_id)public view returns (bool){
           if(hasAccessToCollectionId[pat_id][msg.sender]==true)
           {
            return true;
           }
           else 
           {
            return false;
           }
    }
    modifier checkPatient(address id) {
        patient memory p = patients[id];
        require(p.add > address(0x0)); //check if patient exist
        _;
    }

    function signupPatient(
        string memory _name,
        uint8 _age,
        uint8 height,
        uint8 weight,
        string memory uKey
        
    ) public {
        patient memory p = patients[msg.sender];
        require(keccak256(abi.encodePacked(_name)) != keccak256(""));
        require((_age > 0) && (_age < 170));
        require(!(p.add > address(0x0)));

       CollectionId[msg.sender] = uKey;

        patients[msg.sender] = patient({
            height: height,
            weight: weight,
            name: _name,
            age: _age,
            add: msg.sender,
            record_id: uKey
        });
    }

   

    function getPatientInfo()
        public
        view
        checkPatient(msg.sender)
        returns (
            string memory,
            address,
            uint256,
             string memory,
            uint256,
            uint256
        )
    {
        patient memory p = patients[msg.sender];
        return (p.name, p.add, p.age, p.record_id, p.height, p.weight);
    }


    function read() public view returns (uint256) {
        return value;
    }

    function write(uint256 newValue) public {
        value = newValue;
    }
}

