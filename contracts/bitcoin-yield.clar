;; Bitcoin Yield Vault: Cross-Protocol Yield Optimization Engine
;; 
;; Summary: Secure, compliant yield aggregation protocol enabling optimized returns through automated
;; capital allocation across Stacks Layer 2 and Bitcoin-aligned DeFi strategies with institutional-grade
;; risk parameters.

;; Description:
;; A next-generation yield management system combining:
;; - Multi-protocol diversification with APY optimization
;; - Bitcoin-centric compliance framework
;; - Dynamic allocation limits per strategy (0-100%)
;; - Real-time yield accrual calculated per block
;; - Protocol risk scoring and emergency deactivation
;; - Stacks-native governance with owner-controlled protocol whitelisting
;; Designed for compatibility with Bitcoin DeFi primitives and Stacks Layer 2 capabilities, implementing
;; rigorous capital preservation measures including:
;; - Protocol-specific deposit caps
;; - Time-locked yield calculations
;; - Principal protection on withdrawals
;; - Anti-overexposure safeguards
;; Built for institutional DeFi participants requiring audit-ready compliance and mathematical yield certainty.

;; Error Constants
(define-constant ERR-UNAUTHORIZED (err u1))
(define-constant ERR-INSUFFICIENT-FUNDS (err u2))
(define-constant ERR-INVALID-PROTOCOL (err u3))
(define-constant ERR-WITHDRAWAL-FAILED (err u4))
(define-constant ERR-DEPOSIT-FAILED (err u5))
(define-constant ERR-PROTOCOL-LIMIT-REACHED (err u6))
(define-constant ERR-INVALID-INPUT (err u7))

;; Protocol Storage
(define-map supported-protocols 
    {protocol-id: uint} 
    {
        name: (string-ascii 50),
        base-apy: uint,
        max-allocation-percentage: uint,
        active: bool
    }
)

;; Protocol Counter
(define-data-var total-protocols uint u0)

;; User Deposit Storage
(define-map user-deposits 
    {user: principal, protocol-id: uint} 
    {
        amount: uint,
        deposit-time: uint
    }
)

;; Protocol Total Deposits
(define-map protocol-total-deposits 
    {protocol-id: uint} 
    {total-deposit: uint}
)

;; Contract Configuration
(define-constant CONTRACT-OWNER tx-sender)

;; Protocol Constants
(define-constant MAX-PROTOCOLS u5)
(define-constant MAX-ALLOCATION-PERCENTAGE u100)
(define-constant BASE-DENOMINATION u1000000)
(define-constant MAX-PROTOCOL-NAME-LENGTH u50)
(define-constant MAX-BASE-APY u10000)  ;; 100%
(define-constant MAX-DEPOSIT-AMOUNT u1000000000)  ;; 1 billion base units

;; Input Validation Functions
(define-private (is-valid-protocol-id (protocol-id uint))
    (and (> protocol-id u0) (<= protocol-id MAX-PROTOCOLS))
)
