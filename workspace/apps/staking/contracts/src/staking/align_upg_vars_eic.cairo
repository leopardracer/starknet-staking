// An External Initializer Contract
// Migrating ERC20_dipatcher to token_dispatcher & replacing pool contract parameters.
#[starknet::contract]
pub(crate) mod AlignUpgVars {
    use starknet::ContractAddress;
    use starknet::class_hash::ClassHash;
    use contracts_commons::components::replaceability::interface::IEICInitializable;
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        erc20_dispatcher: ContractAddress,
        token_dispatcher: ContractAddress,
        pool_contract_class_hash: ClassHash,
        pool_contract_admin: ContractAddress,
    }

    #[abi(embed_v0)]
    impl EICInitializable of IEICInitializable<ContractState> {
        fn eic_initialize(ref self: ContractState, eic_init_data: Span<felt252>) {
            assert(eic_init_data.len() == 2, 'EXPECTED_DATA_LENGTH_2');
            let new_pool_clash: felt252 = (*eic_init_data[0]).try_into().unwrap();
            let new_pool_admin: felt252 = (*eic_init_data[1]).try_into().unwrap();

            // 1. Replace pool contract class hash (if supplied).
            if new_pool_clash != Zero::zero() {
                self
                    .pool_contract_class_hash
                    .write(new_pool_clash.try_into().expect('BAD_POOL_CLASS_HASH'));
            }
            // 2. Replace pool contract governance_admin (if supplied).
            if new_pool_admin != Zero::zero() {
                self.pool_contract_admin.write(new_pool_admin.try_into().expect('BAD_POOL_ADMIN'));
            }

            // 3. If applicable, copy erc20_dispatcher to token_dispatcher.
            let current_dispatcher_address = self.erc20_dispatcher.read();
            // If token_dispatcher is not empty we assume it's already set correctly.
            // in this case, we must not replace it.
            if self.token_dispatcher.read() == Zero::zero() {
                self.token_dispatcher.write(current_dispatcher_address);
            }
        }
    }
}