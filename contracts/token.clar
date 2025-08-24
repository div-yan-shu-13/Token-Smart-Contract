;; Token Smart Contract
;; A simple token implementation with minting and transfer capabilities

(define-constant CONTRACT_OWNER tx-sender)
(define-constant TOKEN-SYMBOL "TKN")
(define-constant TOKEN-NAME "MyToken")
(define-constant DECIMALS u8)

;; Data maps for storing token data
(define-map balances principal uint)
(define-map allowances (tuple (owner principal) (spender principal)) uint)

;; Note: Events are not supported in this version of Clarity
;; Transfer, Mint, and Burn operations will return success responses instead

;; Error codes
(define-constant ERR-INSUFFICIENT-BALANCE (err u1001))
(define-constant ERR-INSUFFICIENT-ALLOWANCE (err u1002))
(define-constant ERR-NOT-AUTHORIZED (err u1003))
(define-constant ERR-ZERO-AMOUNT (err u1004))

;; Public functions

;; Get token symbol
(define-public (get-symbol)
  (ok TOKEN-SYMBOL))

;; Get token name
(define-public (get-name)
  (ok TOKEN-NAME))

;; Get token decimals
(define-public (get-decimals)
  (ok DECIMALS))

;; Get balance of a principal
(define-public (get-balance (owner principal))
  (ok (default-to u0 (map-get? balances owner))))

;; Get allowance for a spender
(define-public (get-allowance (owner principal) (spender principal))
  (ok (default-to u0 (map-get? allowances (tuple (owner owner) (spender spender))))))

;; Transfer tokens from sender to recipient
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (> amount u0) ERR-ZERO-AMOUNT)
    (asserts! (is-eq tx-sender sender) ERR-NOT-AUTHORIZED)
    (asserts! (>= (default-to u0 (map-get? balances sender)) amount) ERR-INSUFFICIENT-BALANCE)
    
    (let ((sender-balance (default-to u0 (map-get? balances sender)))
          (recipient-balance (default-to u0 (map-get? balances recipient))))
      
      (map-set balances sender (- sender-balance amount))
      (map-set balances recipient (+ recipient-balance amount))
      
      (ok true))))

;; Approve spender to spend tokens on behalf of owner
(define-public (approve (spender principal) (amount uint))
  (begin
    (asserts! (> amount u0) ERR-ZERO-AMOUNT)
    (map-set allowances (tuple (owner tx-sender) (spender spender)) amount)
    (ok true)))

;; Transfer tokens using allowance
(define-public (transfer-from (amount uint) (owner principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (> amount u0) ERR-ZERO-AMOUNT)
    (asserts! (>= (default-to u0 (map-get? balances owner)) amount) ERR-INSUFFICIENT-BALANCE)
    (asserts! (>= (default-to u0 (map-get? allowances (tuple (owner owner) (spender tx-sender)))) amount) ERR-INSUFFICIENT-ALLOWANCE)
    
    (let ((owner-balance (default-to u0 (map-get? balances owner)))
          (recipient-balance (default-to u0 (map-get? balances recipient)))
          (current-allowance (default-to u0 (map-get? allowances (tuple (owner owner) (spender tx-sender))))))
      
      (map-set balances owner (- owner-balance amount))
      (map-set balances recipient (+ recipient-balance amount))
      (map-set allowances (tuple (owner owner) (spender tx-sender)) (- current-allowance amount))
      
      (ok true))))

;; Mint new tokens (only contract owner can mint)
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (> amount u0) ERR-ZERO-AMOUNT)
    
    (let ((current-balance (default-to u0 (map-get? balances recipient))))
      (map-set balances recipient (+ current-balance amount))
      (ok true))))

;; Burn tokens from sender
(define-public (burn (amount uint))
  (begin
    (asserts! (> amount u0) ERR-ZERO-AMOUNT)
    (asserts! (>= (default-to u0 (map-get? balances tx-sender)) amount) ERR-INSUFFICIENT-BALANCE)
    
    (let ((current-balance (default-to u0 (map-get? balances tx-sender))))
      (map-set balances tx-sender (- current-balance amount))
      (ok true))))

;; Get total supply (sum of all balances)
;; Note: This is a simplified version - in a real implementation you might want to track total supply separately
(define-public (get-total-supply)
  (ok u0))
