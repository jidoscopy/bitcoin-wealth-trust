;; Intergenerational Wealth Trust
;; Enhanced version with comprehensive data validation

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-INITIALIZED (err u101))
(define-constant ERR-NOT-ACTIVE (err u102))
(define-constant ERR-INVALID-AGE (err u103))
(define-constant ERR-MILESTONE-NOT-FOUND (err u104))
(define-constant ERR-MILESTONE-ALREADY-COMPLETED (err u105))
(define-constant ERR-INSUFFICIENT-BALANCE (err u106))
(define-constant ERR-INVALID-MILESTONE (err u107))
(define-constant ERR-INVALID-TIME (err u108))
(define-constant ERR-GUARDIAN-ALREADY-SET (err u109))
(define-constant ERR-NO-GUARDIAN (err u110))
(define-constant ERR-INVALID-AMOUNT (err u111))
(define-constant ERR-INVALID-BIRTH-HEIGHT (err u112))
(define-constant ERR-ZERO-ALLOCATION (err u113))
(define-constant ERR-INVALID-BONUS (err u114))
(define-constant ERR-INVALID-DEADLINE (err u115))
(define-constant ERR-INVALID-STATUS (err u116))
(define-constant ERR-SELF-GUARDIAN (err u117))
(define-constant ERR-TRANSFER-FAILED (err u118))

;; Constants for validation
(define-constant MINIMUM-AGE-REQUIREMENT u16)
(define-constant MAXIMUM-AGE-REQUIREMENT u100)
(define-constant MAXIMUM-BONUS_MULTIPLIER u500) ;; 5x maximum bonus
(define-constant MINIMUM_ALLOCATION u1000000) ;; 1 STX minimum allocation
(define-constant BLOCKS_PER_DAY u144)
(define-constant VALID-STATUS-VALUES (list "active" "paused" "completed"))

;; Data Variables
(define-data-var contract-owner principal tx-sender)
(define-data-var active bool true)
(define-data-var emergency-contact principal tx-sender)
(define-data-var minimum-vesting-period uint u52560) ;; ~1 year in blocks

;; Data Maps
(define-map heirs 
    principal 
    {
        birth-height: uint,
        total-allocation: uint,
        claimed-amount: uint,
        status: (string-ascii 9),
        guardian: (optional principal),
        vesting-start: uint,
        education-bonus: uint,
        last-activity: uint
    }
)

(define-map milestones
    uint
    {
        description: (string-ascii 100),
        reward-amount: uint,
        age-requirement: uint,
        completed: bool,
        deadline: (optional uint),
        bonus-multiplier: uint,
        requires-guardian: bool
    }
)

(define-map guardian-approvals
    { heir: principal, milestone-id: uint }
    { approved: bool, timestamp: uint }
)