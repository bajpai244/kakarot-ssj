use core_contracts::components::ownable::{ownable_component};
use core_contracts::tests::utils::constants::{ZERO, OWNER, OTHER};
use core_contracts::tests::utils;


use ownable_component::{InternalImpl, OwnableImpl};
use starknet::ContractAddress;
use starknet::testing;


#[starknet::contract]
mod MockContract {
    use core_contracts::components::ownable::{ownable_component};

    component!(path: ownable_component, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = ownable_component::Ownable<ContractState>;

    impl OwnableInternalImpl = ownable_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: ownable_component::Storage
    }


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnableEvent: ownable_component::Event
    }
}
type TestingState = ownable_component::ComponentState<MockContract::ContractState>;

impl TestingStateDefault of Default<TestingState> {
    fn default() -> TestingState {
        ownable_component::component_state_for_testing()
    }
}

#[generate_trait]
impl TestingStateImpl of TestingStateTrait {
    fn new_with(owner: ContractAddress) -> TestingState {
        let mut ownable: TestingState = Default::default();
        ownable.initializer(owner);
        utils::drop_event(ZERO());
        ownable
    }
}

#[test]
#[available_gas(200000)]
fn test_ownable_initializer() {
    let mut ownable: TestingState = Default::default();
    assert(ownable.owner().is_zero(), 'owner should be zero');

    ownable.initializer(OWNER());

    assert_event_ownership_transferred(ZERO(), OWNER());
    assert(ownable.owner() == OWNER(), 'Owner should be set');
}

#[test]
#[available_gas(200000)]
fn test_assert_only_owner() {
    let mut ownable: TestingState = TestingStateTrait::new_with(OWNER());
    testing::set_caller_address(OWNER());

    ownable.assert_only_owner();
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Caller is not the owner',))]
fn test_assert_only_owner_not_owner() {
    let mut ownable: TestingState = TestingStateTrait::new_with(OWNER());
    testing::set_caller_address(OTHER());

    let result = ownable.assert_only_owner();
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Caller is the zero address',))]
fn test_assert_only_owner_zero() {
    let mut ownable: TestingState = TestingStateTrait::new_with(OWNER());
    testing::set_caller_address(ZERO());

    let result = ownable.assert_only_owner();
}

#[test]
#[available_gas(2000000)]
fn test__transfer_ownership() {
    let mut ownable: TestingState = TestingStateTrait::new_with(OWNER());

    ownable._transfer_ownership(OTHER());

    assert_event_ownership_transferred(OWNER(), OTHER());
    assert(ownable.owner() == OTHER(), 'Owner should be OTHER');
}


#[test]
#[available_gas(2000000)]
fn test_transfer_ownership() {
    let mut ownable: TestingState = TestingStateTrait::new_with(OWNER());
    testing::set_caller_address(OWNER());

    ownable.transfer_ownership(OTHER());

    assert_event_ownership_transferred(OWNER(), OTHER());
    assert(ownable.owner() == OTHER(), 'Should transfer ownership');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('New owner is the zero address',))]
fn test_transfer_ownership_to_zero() {
    let mut ownable: TestingState = TestingStateTrait::new_with(OWNER());
    testing::set_caller_address(OWNER());

    ownable.transfer_ownership(ZERO());
}


#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Caller is the zero address',))]
fn test_transfer_ownership_from_zero() {
    let mut ownable: TestingState = Default::default();

    ownable.transfer_ownership(OTHER());
}


#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Caller is not the owner',))]
fn test_transfer_ownership_from_nonowner() {
    let mut ownable: TestingState = TestingStateTrait::new_with(OWNER());
    testing::set_caller_address(OTHER());

    ownable.transfer_ownership(OTHER());
}


#[test]
#[available_gas(2000000)]
fn test_renounce_ownership() {
    let mut ownable: TestingState = TestingStateTrait::new_with(OWNER());
    testing::set_caller_address(OWNER());

    ownable.renounce_ownership();

    assert_event_ownership_transferred(OWNER(), ZERO());

    assert(ownable.owner().is_zero(), 'ownership not renounced');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Caller is the zero address',))]
fn test_renounce_ownership_from_zero_address() {
    let mut ownable: TestingState = Default::default();
    ownable.renounce_ownership();
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Caller is not the owner',))]
fn test_renounce_ownership_from_nonowner() {
    let mut ownable: TestingState = TestingStateTrait::new_with(OWNER());
    testing::set_caller_address(OTHER());

    ownable.renounce_ownership();
}


fn assert_event_ownership_transferred(previous_owner: ContractAddress, new_owner: ContractAddress) {
    let event = utils::pop_log::<ownable_component::OwnershipTransferred>(ZERO()).unwrap();
    assert(event.previous_owner == previous_owner, 'Invalid `previous_owner`');
    assert(event.new_owner == new_owner, 'Invalid `new_owner`');
    utils::assert_no_events_left(ZERO());
}
