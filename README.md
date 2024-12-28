# Bitcoin Wealth Trust

## Overview
The **Bitcoin Wealth Trust** smart contract is designed to facilitate the creation of a secure, structured, and incentivized wealth management system. This contract ensures wealth distribution across generations while promoting accountability, education, and personal development through milestone-based rewards.

## Features
- **Heir Management**: Add heirs with predefined allocations and optional guardian oversight.
- **Milestone Rewards**: Assign milestones with specific age requirements, rewards, and optional guardian approvals.
- **Education Bonuses**: Include bonuses for educational achievements.
- **Contract Controls**: Pause/resume the contract and update vesting periods as needed.
- **Emergency Contact**: Set an emergency contact to manage the contract during critical situations.
- **Comprehensive Validation**: Ensures all data inputs and actions adhere to predefined rules, minimizing errors and misuse.

## Core Concepts

### Heirs
Heirs are individuals designated to receive allocations from the trust. Each heir has the following properties:
- `birth-height`: The block height at which the heir was born.
- `total-allocation`: The total STX allocated to the heir.
- `claimed-amount`: The amount of STX already claimed by the heir.
- `status`: Current status (e.g., "active", "paused", or "completed").
- `guardian`: Optional guardian assigned to oversee milestones.
- `vesting-start`: The block height when vesting begins.
- `education-bonus`: Accumulated education-related bonus rewards.
- `last-activity`: Last activity block height.

### Milestones
Milestones are achievements or conditions an heir must meet to claim rewards. Milestones include:
- `description`: A description of the milestone.
- `reward-amount`: The base reward amount for achieving the milestone.
- `age-requirement`: The minimum age to claim the reward.
- `completed`: Status of milestone completion.
- `deadline`: Optional deadline for completing the milestone.
- `bonus-multiplier`: Percentage multiplier for additional rewards.
- `requires-guardian`: Indicates if a guardian's approval is necessary.

### Guardian Approvals
Guardians can approve milestones for heirs, ensuring proper oversight when required. Approvals are recorded with a timestamp.

### Validation
Data validation ensures that all parameters are within acceptable ranges and conditions. For example:
- `birth-height` must be between 0 and the current block height.
- `allocation` must be at least 1 STX.
- `bonus-multiplier` must not exceed 5x.
- `status` values must be one of the predefined valid states.

## Public Functions

### Heir Management
#### `add-heir`
Adds a new heir to the trust.
- **Parameters**:
  - `heir`: The heir's principal address.
  - `birth-height`: The heir's birth block height.
  - `allocation`: The total STX allocated to the heir.
  - `guardian`: Optional guardian principal.
- **Errors**:
  - `ERR-NOT-AUTHORIZED`: Only the contract owner can add heirs.
  - `ERR-ALREADY-INITIALIZED`: Heir already exists.
  - `ERR-INVALID-BIRTH-HEIGHT`: Birth height is invalid.
  - `ERR-ZERO-ALLOCATION`: Allocation must be greater than 0.
  - `ERR-SELF-GUARDIAN`: Heir cannot be their own guardian.

#### `update-guardian`
Updates an heir's guardian.
- **Parameters**:
  - `heir`: The heir's principal address.
  - `new-guardian`: The new guardian principal.
- **Errors**:
  - `ERR-NOT-AUTHORIZED`: Only the contract owner or current guardian can update.
  - `ERR-SELF-GUARDIAN`: Heir cannot be their own guardian.

### Milestone Management
#### `add-milestone`
Creates a new milestone.
- **Parameters**:
  - `milestone-id`: Unique identifier for the milestone.
  - `description`: Description of the milestone.
  - `reward-amount`: Base reward for completing the milestone.
  - `age-requirement`: Minimum age to claim the reward.
  - `deadline`: Optional block height deadline.
  - `bonus-multiplier`: Additional reward multiplier (1x = 100).
  - `requires-guardian`: Boolean indicating if guardian approval is required.
- **Errors**:
  - `ERR-INVALID-AGE`: Age requirement is invalid.
  - `ERR-INVALID-BONUS`: Bonus multiplier exceeds the maximum.
  - `ERR-INVALID-DEADLINE`: Deadline is invalid.
  - `ERR-INVALID-AMOUNT`: Reward amount must be greater than 0.

#### `claim-milestone`
Allows an heir to claim a milestone reward.
- **Parameters**:
  - `heir`: The heir's principal address.
  - `milestone-id`: The milestone identifier.
- **Errors**:
  - `ERR-MILESTONE-NOT-FOUND`: Milestone does not exist.
  - `ERR-MILESTONE-ALREADY-COMPLETED`: Milestone already claimed.
  - `ERR-NOT-AUTHORIZED`: Only the heir can claim their milestone.
  - `ERR-INVALID-AGE`: Heir does not meet the age requirement.
  - `ERR-INSUFFICIENT-BALANCE`: Total allocation or contract balance insufficient.

### Bonuses
#### `add-education-bonus`
Adds an education bonus for an heir.
- **Parameters**:
  - `heir`: The heir's principal address.
  - `bonus-amount`: Amount to add as a bonus.
- **Errors**:
  - `ERR-NOT-AUTHORIZED`: Only the contract owner can add bonuses.
  - `ERR-INVALID-AMOUNT`: Bonus amount must be greater than 0.

### Contract Control
#### `pause-contract`
Pauses the contract, disabling new operations.
- **Errors**:
  - `ERR-NOT-AUTHORIZED`: Only the owner or emergency contact can pause the contract.

#### `resume-contract`
Resumes the contract, enabling operations.
- **Errors**:
  - `ERR-NOT-AUTHORIZED`: Only the owner can resume the contract.

#### `set-emergency-contact`
Sets a new emergency contact.
- **Parameters**:
  - `new-contact`: The principal address of the new emergency contact.
- **Errors**:
  - `ERR-NOT-AUTHORIZED`: Only the owner can update the emergency contact.

#### `update-vesting-period`
Updates the minimum vesting period for heirs.
- **Parameters**:
  - `new-period`: The new vesting period in blocks.
- **Errors**:
  - `ERR-NOT-AUTHORIZED`: Only the owner can update the vesting period.

## Read-Only Functions
- `get-heir-info`: Retrieves information about a specific heir.
- `get-milestone`: Retrieves information about a specific milestone.
- `calculate-age`: Calculates an heir's age based on their birth height.
- `get-guardian-approval`: Retrieves guardian approval for a specific milestone.
- `get-vesting-status`: Checks if an heir's vesting period is complete.

## Error Codes
| Code | Description |
|------|-------------|
| `ERR-NOT-AUTHORIZED` | Unauthorized action. |
| `ERR-ALREADY-INITIALIZED` | Heir or milestone already exists. |
| `ERR-NOT-ACTIVE` | Contract is paused or inactive. |
| `ERR-INVALID-AGE` | Age requirement is not met. |
| `ERR-MILESTONE-NOT-FOUND` | Milestone does not exist. |
| `ERR-MILESTONE-ALREADY-COMPLETED` | Milestone already claimed. |
| `ERR-INSUFFICIENT-BALANCE` | Insufficient funds for operation. |
| `ERR-INVALID-AMOUNT` | Amount specified is invalid. |
| `ERR-SELF-GUARDIAN` | Guardian cannot be the heir. |
| `ERR-INVALID-STATUS` | Invalid status value. |

## Constants
- `MINIMUM-AGE-REQUIREMENT`: Minimum age for milestones (16).
- `MAXIMUM-AGE-REQUIREMENT`: Maximum age for milestones (100).
- `MINIMUM_ALLOCATION`: Minimum STX allocation (1 STX).
- `MAXIMUM-BONUS_MULTIPLIER`: Maximum bonus multiplier (500).
- `BLOCKS_PER_DAY`: Approximate number of blocks per day (144).

## Initialization
Upon deployment:
- The deployer becomes the `contract-owner`.
- The contract is set to active.
- The emergency contact is initialized as the deployer.

