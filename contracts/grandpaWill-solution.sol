// ^는 이상 버전 아무거나 포함
pragma solidity ^0.5.7;

// 할아버지의 유언장에 따른 스마트계약 작성 -> 돌아가시면 유산 상속 바로
contract grandpaWill {
    
    address owner; // 상속자의 지갑주소 -> address payable 변수형과 다르게 이더 송금불가
    uint fortune; // 얼마나 상속할건지
    bool deceased; // 정말 돌아가셨는지


    // constructor(생성자) -> 변수가 스마트계약에서 무엇인지에 대해 정의, 접근을 허용하게 함 (기본적으로 생성자는 외부에서 호출될 수 있음), 초기 속성 설정
    constructor() payable public {
        owner = msg.sender; // msg sender represents address being called
        fortune = msg.value; //msg value tells us how much ether is being sent
        deceased = false;  
    }


    // modifier -> if문 같은 느낌
    // create modifier so the only person who can call the contract is the owner
    modifier onlyOwner {
        require(msg.sender == owner); // 제어
        _; // 함수가 계속이어져라
    }

    // only allocate funds if friend's grandparents is deceased
    modifier mustBeDeceased {
        require(deceased == true);
        _;
    }    


    // 상속 받을 가족의 지갑 리스트 생성
    address payable[] familyWallets;

    // map through inheritance ( key => value ) owner -> fortune 이니까 inheritance 유산이 된다.
    mapping(address => uint) inheritance;

    // 총 유산에서 familyWallets에 받게 될 유산의 양을 onlyOwner만 inheritance에 설정
    function setInheritance(address payable wallet, uint amount) public onlyOwner {
        familyWallets.push(wallet);
        inheritance[wallet] = amount;
    }

    // setInheritance에서 설정한 유산의 양을 이용해서, 죽으면 가족의 지갑으로 유산을 배분
    // private으로 외부에서 함수 사용 못하게, mustBeDeceased로 죽어야지만 함수 실행하게 제어
    function payOut() private mustBeDeceased {
        for(uint i=0; i<familyWallets.length; i++) {
            familyWallets[i].transfer((inheritance[familyWallets[i]]));
            // transferring funds from contract address to "reciever" address -> .tranfer는 송금하기 메소드 , 여기서는 familyWallets[i]가 수신자
        }
    }


    // 죽는거에 대한 트리거 -> 실제 스마트계약이면 Oracle과 연동해 사망소식을 듣고, payOut 자동화 'Oracle switch'
    function hasDeceased() public onlyOwner {
        deceased = true;
        payOut();
    }
}