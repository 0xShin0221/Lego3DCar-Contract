import "./interfaces/IDataChunkCompiler.sol";

contract Lego3DNFTRender {
    /**
     * @dev owner is the owner of the contract
     */
    address public owner;

    /**
     * @dev compiler is the instance of the DataChunkCompiler contract on Goerli by ROSES
     * url:https://goerli.etherscan.io/address/0xEeA6556f135AaEcA7819b369a3CfaEd43B02d169#code
     */
    IDataChunkCompiler private compiler = IDataChunkCompiler(0xEeA6556f135AaEcA7819b369a3CfaEd43B02d169);

    /**
     * @dev threeAddressed is the address list of the Threejs library contract data which is gzip compressed and Base64 encoded data on Goerli by ROSES
     */
    address[9] private threeAddresses = [
        0xA27ce71ce7D92793404B224d3F31043c7F5Fa15b,
        0x740E1b93Bf77686B409Adce96341bC4047dA2464,
        0x248930e364D2B1a0C5b672687080E45e7CaFBB7b,
        0x03728478F23B6CE057217792A53d9be9eD124e97,
        0xd4b8AF84DD5C024eB2c0485b27DD5f5266929065,
        0xa08582200014f3865D61BAF88e12c67CdA023aF9,
        0x1174727f22A9F80Bc158386BE728Bd81154fa0D8,
        0x11958611287b1798696d66456a2b5458988822bc,
        0x6743dBEc9432f098bcB66eAEa7c25Dbece63a2aE
    ];


    constructor( ) {
        owner = msg.sender;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        string memory threejs = compiler.compile9(
            threeAddresses[0],
            threeAddresses[1],
            threeAddresses[2],
            threeAddresses[3],
            threeAddresses[4],
            threeAddresses[5],
            threeAddresses[6],
            threeAddresses[7],
            threeAddresses[8]
        );

        string memory tokenIdStr = uint2str(tokenId);

        return string.concat(
            compiler.BEGIN_JSON(),

            string.concat(
                compiler.BEGIN_METADATA_VAR("animation_url", false),
                    compiler.HTML_HEAD(),

                    string.concat(
                        compiler.BEGIN_SCRIPT_DATA_COMPRESSED(),
                            threejs,
                        compiler.END_SCRIPT_DATA_COMPRESSED(),
                        
                        compiler.BEGIN_SCRIPT(),
                            compiler.SCRIPT_VAR('tokenId', tokenIdStr, true),
                        compiler.END_SCRIPT()
                    ),

                    '%253Cstyle%253E%252A%257Bmargin%253A0%253Bpadding%253A0%253B%257Dcanvas%257Bwidth%253A100%2525%253Bheight%253A100%2525%253B%257D%253C%252Fstyle%253E%253Cscript%253Ewindow.onload%2520%253D%2520%2528%2528%2529%2520%253D%253E%2520%257Bconst%2520scene%2520%253D%2520new%2520THREE.Scene%2528%2529%253Bconst%2520o%2520%253D%2520%2528o%2529%2520%253D%253E%2520%2528void%25200%2520%2521%253D%253D%2520o%2520%2526%2526%2520%2528l%2520%253D%2520o%2520%2525%25202147483647%2529%2520%253C%253D%25200%2520%2526%2526%2520%2528l%2520%252B%253D%25202147483646%2529%252C%2528%2528l%2520%253D%2520%252816807%2520%252A%2520l%2529%2520%2525%25202147483647%2529%2520-%25201%2529%2520%252F%25202147483646%2529%253Bo%2528tokenId%2529%253Bconst%2520color%2520%253D%2520%2522%2523%2522%2520%252B%2520o%2528tokenId%2529.toString%2528%2529.slice%2528-6%2529%253Bconst%2520car%2520%253D%2520createCar%2528color%2529%253Bscene.add%2528car%2529%253Bconst%2520ambientLight%2520%253D%2520new%2520THREE.AmbientLight%25280xffffff%252C%25200.6%2529%253Bscene.add%2528ambientLight%2529%253Bconst%2520dirLight%2520%253D%2520new%2520THREE.DirectionalLight%25280xffffff%252C%25200.8%2529%253BdirLight.position.set%2528200%252C%2520500%252C%2520300%2529%253Bscene.add%2528dirLight%2529%253Bconst%2520aspectRatio%2520%253D%2520window.innerWidth%2520%252F%2520window.innerHeight%253Bconst%2520cameraWidth%2520%253D%2520150%253Bconst%2520cameraHeight%2520%253D%2520cameraWidth%2520%252F%2520aspectRatio%253Bconst%2520camera%2520%253D%2520new%2520THREE.OrthographicCamera%2528cameraWidth%2520%252F%2520-2%252CcameraWidth%2520%252F%25202%252CcameraHeight%2520%252F%25202%252CcameraHeight%2520%252F%2520-2%252C0%252C1000%2529%253Bcamera.position.set%2528200%252C%2520200%252C%2520200%2529%253Bcamera.lookAt%25280%252C%252010%252C%25200%2529%253Bconst%2520renderer%2520%253D%2520new%2520THREE.WebGLRenderer%2528%257B%2520antialias%253A%2520true%2520%257D%2529%253Brenderer.setSize%2528window.innerWidth%252C%2520window.innerHeight%2529%253Brenderer.render%2528scene%252C%2520camera%2529%253Brenderer.setAnimationLoop%2528%2528%2529%2520%253D%253E%2520%257Bcar.rotation.y%2520-%253D%25200.007%253Brenderer.render%2528scene%252C%2520camera%2529%253B%257D%2529%253Bdocument.body.appendChild%2528renderer.domElement%2529%253Bfunction%2520createCar%2528color%2529%2520%257Bconst%2520car%2520%253D%2520new%2520THREE.Group%2528%2529%253Bconst%2520backWheel%2520%253D%2520createWheels%2528%2529%253BbackWheel.position.y%2520%253D%25206%253BbackWheel.position.x%2520%253D%2520-18%253Bcar.add%2528backWheel%2529%253Bconst%2520frontWheel%2520%253D%2520createWheels%2528%2529%253BfrontWheel.position.y%2520%253D%25206%253BfrontWheel.position.x%2520%253D%252018%253Bcar.add%2528frontWheel%2529%253Bconst%2520main%2520%253D%2520new%2520THREE.Mesh%2528new%2520THREE.BoxGeometry%252860%252C%252015%252C%252030%2529%252Cnew%2520THREE.MeshLambertMaterial%2528%257B%2520color%253A%2520color%2520%257D%2529%2529%253Bmain.position.y%2520%253D%252012%253Bcar.add%2528main%2529%253Bconst%2520carFrontTexture%2520%253D%2520getCarFrontTexture%2528%2529%253Bconst%2520carBackTexture%2520%253D%2520getCarFrontTexture%2528%2529%253Bconst%2520carRightSideTexture%2520%253D%2520getCarSideTexture%2528%2529%253Bconst%2520carLeftSideTexture%2520%253D%2520getCarSideTexture%2528%2529%253BcarLeftSideTexture.center%2520%253D%2520new%2520THREE.Vector2%25280.5%252C%25200.5%2529%253BcarLeftSideTexture.rotation%2520%253D%2520Math.PI%253BcarLeftSideTexture.flipY%2520%253D%2520false%253Bconst%2520cabin%2520%253D%2520new%2520THREE.Mesh%2528new%2520THREE.BoxGeometry%252833%252C%252012%252C%252024%2529%252C%2520%255Bnew%2520THREE.MeshLambertMaterial%2528%257B%2520map%253A%2520carFrontTexture%2520%257D%2529%252Cnew%2520THREE.MeshLambertMaterial%2528%257B%2520map%253A%2520carBackTexture%2520%257D%2529%252Cnew%2520THREE.MeshLambertMaterial%2528%257B%2520color%253A%2520color%2520%257D%2529%252Cnew%2520THREE.MeshLambertMaterial%2528%257B%2520color%253A%2520color%2520%257D%2529%252Cnew%2520THREE.MeshLambertMaterial%2528%257B%2520map%253A%2520carRightSideTexture%2520%257D%2529%252Cnew%2520THREE.MeshLambertMaterial%2528%257B%2520map%253A%2520carLeftSideTexture%2520%257D%2529%252C%255D%2529%253Bcabin.position.x%2520%253D%2520-6%253Bcabin.position.y%2520%253D%252025.5%253Bcar.add%2528cabin%2529%253Breturn%2520car%253B%257Dfunction%2520createWheels%2528%2529%2520%257Bconst%2520geometry%2520%253D%2520new%2520THREE.BoxGeometry%252812%252C%252012%252C%252033%2529%253Bconst%2520material%2520%253D%2520new%2520THREE.MeshLambertMaterial%2528%257B%2520color%253A%25200x333333%2520%257D%2529%253Bconst%2520wheel%2520%253D%2520new%2520THREE.Mesh%2528geometry%252C%2520material%2529%253Breturn%2520wheel%253B%257Dfunction%2520getCarFrontTexture%2528%2529%2520%257Bconst%2520canvas%2520%253D%2520document.createElement%2528%2522canvas%2522%2529%253Bcanvas.width%2520%253D%252064%253Bcanvas.height%2520%253D%252032%253Bconst%2520context%2520%253D%2520canvas.getContext%2528%25222d%2522%2529%253Bcontext.fillStyle%2520%253D%2520%2522%2523ffffff%2522%253Bcontext.fillRect%25280%252C%25200%252C%252064%252C%252032%2529%253Bcontext.fillStyle%2520%253D%2520%2522%2523666666%2522%253Bcontext.fillRect%25288%252C%25208%252C%252048%252C%252024%2529%253Breturn%2520new%2520THREE.CanvasTexture%2528canvas%2529%253B%257Dfunction%2520getCarSideTexture%2528%2529%2520%257Bconst%2520canvas%2520%253D%2520document.createElement%2528%2522canvas%2522%2529%253Bcanvas.width%2520%253D%2520128%253Bcanvas.height%2520%253D%252032%253Bconst%2520context%2520%253D%2520canvas.getContext%2528%25222d%2522%2529%253Bcontext.fillStyle%2520%253D%2520%2522%2523ffffff%2522%253Bcontext.fillRect%25280%252C%25200%252C%2520128%252C%252032%2529%253Bcontext.fillStyle%2520%253D%2520%2522%2523666666%2522%253Bcontext.fillRect%252810%252C%25208%252C%252038%252C%252024%2529%253Bcontext.fillRect%252858%252C%25208%252C%252060%252C%252024%2529%253Breturn%2520new%2520THREE.CanvasTexture%2528canvas%2529%253B%257D%257D%2529%253B%253C%252Fscript%253E',
                    
                    compiler.END_METADATA_VAR(false)
            ),

            string.concat(
                compiler.BEGIN_METADATA_VAR("name", false),
                    'Lego3DCar%20', tokenIdStr,
                '%22' // trailing comma breaks things...
            ),
 
            compiler.END_JSON()
        );
    }

    // via https://stackoverflow.com/a/65707309
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}