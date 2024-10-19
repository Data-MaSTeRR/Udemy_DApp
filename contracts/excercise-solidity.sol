// pragma -> solidity의 버전을 표시함
pragma solidity >=0.7.0 <0.9.0;

// 스마트 계약 요구사항
// 1. 정보를 받음, 2. 정보를 저장, 3. 정보를 반환
// 스마트 계약이란? 이더리움 블록체인의 특정주소에 모여 있는 코드(함수)와 데이터(상태)의 집합 -> 배포를 통해 실현

// 계약 생성 -> {} 중괄호는 객체 생성을 의미
contract simpleStorage {
    
    // 함수와 상태를 작성
    // 변수 생성 -> 값을 저장하기 위한 메모리공간
    uint storeData;
    
    // set & get
    // public -> contract 외부에서도 호출가능
    // private -> 반대개념 
    function set(uint x) public {
        storeData = x;
    }

    // view -> 상태 수정이 불가능 하다는 것을 알리는 전역(Global) 제어자
    // retruns -> return 값에 대한 변수형 정보
    function get() public view returns (uint) {
        return storeData;
    }

 
}

