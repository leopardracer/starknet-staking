use core::traits::Into;
use contracts::staking::Staking::REV_SHARE_DENOMINATOR;

#[derive(Drop)]
pub enum Error {
    // Generic errors
    INTEREST_ISNT_U64,
    REWARDS_ISNT_U128,
    COMMISSION_ISNT_U128,
    // Shared errors
    STAKER_EXISTS,
    STAKER_NOT_EXISTS,
    OPERATIONAL_EXISTS,
    CALLER_CANNOT_INCREASE_STAKE,
    INVALID_REWARD_ADDRESS,
    // Staking contract errors
    AMOUNT_LESS_THAN_MIN_STAKE,
    REV_SHARE_OUT_OF_RANGE,
    AMOUNT_LESS_THAN_MIN_INCREASE_STAKE,
    UNSTAKE_IN_PROGRESS,
    POOL_ADDRESS_DOES_NOT_EXIST,
    CLAIM_REWARDS_FROM_UNAUTHORIZED_ADDRESS,
    LEVERAGE_EXCEEDED,
    CALLER_IS_NOT_POOL_CONTRACT,
    // Pooling contract errors
    CLAIM_DELEGATION_POOL_REWARDS_FROM_UNAUTHORIZED_ADDRESS,
    POOL_MEMBER_DOES_NOT_EXIST,
    STAKER_INACTIVE,
    POOL_MEMBER_EXISTS,
    AMOUNT_IS_ZERO,
    // Minting contract errors
    TOTAL_SUPPLY_NOT_U128,
    POOL_CLAIM_REWARDS_FROM_UNAUTHORIZED_ADDRESS,
}


#[inline(always)]
pub fn panic_by_err(error: Error) -> core::never {
    match error {
        Error::INTEREST_ISNT_U64 => panic!("Interest is too large, expected to fit in u64."),
        Error::REWARDS_ISNT_U128 => panic!("Rewards is too large, expected to fit in u128."),
        Error::COMMISSION_ISNT_U128 => panic!("Commission is too large, expected to fit in u128."),
        Error::STAKER_EXISTS => panic!("Staker already exists, use increase_stake instead."),
        Error::STAKER_NOT_EXISTS => panic!("Staker does not exist."),
        Error::CALLER_CANNOT_INCREASE_STAKE => panic!(
            "Caller address should be staker address or reward address."
        ),
        Error::INVALID_REWARD_ADDRESS => panic!("Invalid reward address."),
        Error::OPERATIONAL_EXISTS => panic!("Operational address already exists."),
        Error::AMOUNT_LESS_THAN_MIN_STAKE => panic!(
            "Amount is less than min stake - try again with enough funds."
        ),
        Error::REV_SHARE_OUT_OF_RANGE => panic!(
            "Rev share is out of range, expected to be 0-{}.", REV_SHARE_DENOMINATOR
        ),
        Error::AMOUNT_LESS_THAN_MIN_INCREASE_STAKE => panic!(
            "Amount is less than min increase stake - try again with enough funds."
        ),
        Error::POOL_ADDRESS_DOES_NOT_EXIST => panic!("Pool address does not exist."),
        Error::CLAIM_DELEGATION_POOL_REWARDS_FROM_UNAUTHORIZED_ADDRESS => panic!(
            "Claim delegation pool rewards must be called from delegation pooling contract."
        ),
        Error::UNSTAKE_IN_PROGRESS => panic!(
            "Unstake is in progress, staker is in an exit window."
        ),
        Error::CLAIM_REWARDS_FROM_UNAUTHORIZED_ADDRESS => panic!(
            "Claim rewards must be called from staker address or reward address."
        ),
        Error::POOL_MEMBER_DOES_NOT_EXIST => panic!("Pool member does not exist."),
        Error::STAKER_INACTIVE => panic!("Staker inactive."),
        Error::POOL_MEMBER_EXISTS => panic!(
            "Pool member exists, use add_to_delegation_pool instead."
        ),
        Error::AMOUNT_IS_ZERO => panic!("Amount must be positive."),
        Error::TOTAL_SUPPLY_NOT_U128 => panic!("Total supply does not fit in u128."),
        Error::POOL_CLAIM_REWARDS_FROM_UNAUTHORIZED_ADDRESS => panic!(
            "Claim rewards must be called from pool member address or reward address."
        ),
        Error::LEVERAGE_EXCEEDED => panic!("Cannot exceed max leverage."),
        Error::CALLER_IS_NOT_POOL_CONTRACT => panic!("Caller is not pool contract."),
    }
}

#[inline(always)]
pub fn assert_with_err(condition: bool, error: Error) {
    if !condition {
        panic_by_err(error);
    }
}

#[inline(always)]
pub fn expect_with_err<T>(optional: Option<T>, error: Error) -> T {
    match optional {
        Option::Some(x) => x,
        Option::None => panic_by_err(error),
    }
}
