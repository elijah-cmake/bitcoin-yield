# Bitcoin Yield Vault Smart Contract Documentation

**Version 1.0.0 | Stacks Layer 2 | Clarity Language**

---

### **Overview**

The Bitcoin Yield Vault is a non-custodial yield optimization engine designed for institutional-grade DeFi operations on Stacks Layer 2. This contract automates capital allocation across multiple yield-generating protocols while enforcing Bitcoin-compatible compliance frameworks and mathematically verifiable risk parameters.

---

### **Key Features**

1. **Multi-Protocol Management**

   - Whitelist up to 5 yield protocols with configurable APY (0-10,000 basis points)
   - Per-protocol allocation caps (1-100% of total vault)
   - Real-time deposit tracking at protocol/user levels

2. **Risk-Weighted Architecture**

   - Auto-rebalancing prevention via hard allocation limits
   - Emergency protocol deactivation
   - Block-height-based yield calculations (52596 blocks/year basis)

3. **Institutional Controls**

   - Single-owner governance model
   - Input validation for all parameters
   - Deposit limits: 1M to 1B base units
   - Immutable audit trails for protocol changes

4. **Bitcoin Compliance**
   - STX-denominated operations
   - No cross-chain dependencies
   - Withdrawal principal protection

---

### **Technical Architecture**

#### **Data Structures**

```clarity
;; Protocol Registry
(define-map supported-protocols {
    protocol-id: uint
} {
    name: (string-ascii 50),
    base-apy: uint,          // Basis points (100 = 1%)
    max-allocation-percentage: uint,  // 1-100
    active: bool
})

;; User Position Tracking
(define-map user-deposits {
    user: principal,
    protocol-id: uint
} {
    amount: uint,            // In base denomination
    deposit-time: uint       // Block height
})

;; Protocol Exposure Monitoring
(define-map protocol-total-deposits {
    protocol-id: uint
} {
    total-deposit: uint
})
```

#### **System Constants**

| Constant             | Value         | Purpose                        |
| -------------------- | ------------- | ------------------------------ |
| `MAX-PROTOCOLS`      | 5             | Maximum whitelisted strategies |
| `MAX-BASE-APY`       | 10,000        | 100% APY ceiling               |
| `BASE-DENOMINATION`  | 1,000,000     | STX precision handling         |
| `MAX-DEPOSIT-AMOUNT` | 1,000,000,000 | Anti-whale mechanism           |

---

### **Core Functionality**

#### **1. Protocol Management**

**Add Protocol**

```clarity
(add-protocol u2 "Bitcoin Lightning Yield" u850 u25)
```

- `u2`: Protocol ID
- `"Bitcoin Lightning Yield"`: Strategy name
- `u850`: 8.5% base APY
- `u25`: 25% vault allocation cap

**Deactivate Protocol**

```clarity
(deactivate-protocol u1)
```

#### **2. Deposit Lifecycle**

**Fund Locking**

```clarity
(deposit u1 500000)  // 0.5 STX
```

Enforces:

- Active protocol check
- Per-user/protocol allocation limits
- Global deposit ceilings

#### **3. Yield Calculation**

**Accrual Formula**

```
Yield = (Deposit × APY × Blocks) / (52596 × 10,000)
```

**Read Position**

```clarity
(calculate-yield u1 SP3XYZ...)
```

#### **4. Withdrawal Process**

```clarity
(withdraw u1 250000)  // 0.25 STX
```

Returns principal + pro-rata yield

---

### **Error Handling**

| Code | Constant                   | Trigger Condition                |
| ---- | -------------------------- | -------------------------------- |
| u1   | ERR-UNAUTHORIZED           | Non-owner protocol modification  |
| u2   | ERR-INSUFFICIENT-FUNDS     | Over-withdrawal attempt          |
| u3   | ERR-INVALID-PROTOCOL       | Inactive/nonexistent protocol ID |
| u6   | ERR-PROTOCOL-LIMIT-REACHED | Breach of allocation cap         |
| u7   | ERR-INVALID-INPUT          | Parameter outside allowed ranges |

---

### **Security Model**

1. **Ownership**

   - Single `CONTRACT-OWNER` set at deployment
   - Exclusive rights to:
     - Protocol whitelisting
     - Emergency deactivations

2. **Validation Framework**

   - Protocol IDs: 1-5
   - APY Range: 0-10,000 bps
   - Allocation %: 1-100
   - Deposit Amount: 1-1B base units

3. **Circuit Breakers**
   - Immediate protocol suspension
   - Withdrawal-only mode for deactivated strategies
   - Global protocol count limiter

---

### **Risk Considerations**

1. **Yield Volatility**

   - APY configurable by owner
   - No historical rate guarantees

2. **Blockchain Dependency**

   - Yield calculations based on Stacks block times
   - No oracle integration - manual APY updates required

3. **Concentration Risk**
   - Maximum 100% allocation across all protocols
   - Mandatory per-protocol caps

---

### **Audit & Compliance**

1. All mathematical operations use integer arithmetic
2. No reentrancy vulnerabilities - Clarity's inherent security
3. Formal verification available for:
   - Deposit/withdrawal balance invariants
   - Allocation cap enforcement
   - Protocol state transitions

---

### **Integration Guide**

**Step 1: Initialize**

```clarity
(initialize-protocols)
```

**Step 2: Query Positions**

```clarity
(map-get? user-deposits {user: <principal>, protocol-id: <uint>})
```

**Step 3: Monitor Protocols**

```clarity
(map-get? supported-protocols {protocol-id: <uint>})
```
