;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; KYC Mock Registry Contract
;; 
;; Overview:
;;  - This contract allows an admin (deployer by default) to verify or revoke 
;;    verification status of user addresses.
;;  - Any user can query the verification status.
;;  - Admin role can be transferred to another address.
;;
;; Core Concepts Demonstrated:
;;  - Principal ownership and access control
;;  - Map storage for on-chain records
;;  - Read-only vs public functions
;;  - Error handling via asserts
;;  - Upgradable admin role
;;
;; Use Cases:
;;  - Mock KYC for testing dApps requiring verified users
;;  - Simple access-control pattern in Clarity
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; --------------------------
;; 1. Contract State Variables
;; --------------------------

;; The admin is the principal (address) that can verify or revoke users.
;; Initialized to the deployer (tx-sender at contract deployment)
(define-data-var admin principal tx-sender)

;; Map of verified users:
;; key = tuple with 'user' principal
;; value = tuple with 'status' boolean (true = verified, false = not verified)
(define-map verified-users
  {user: principal}
  {status: bool})


;; --------------------------
;; 2. Public Functions (State-Changing)
;; --------------------------

;; verify-user
;; Admin-only function that marks a given address as verified.
;; Throws an "unauthorized" error if caller is not admin.
(define-public (verify-user (user principal))
  (begin
    ;; Access control check
    (asserts! (is-eq tx-sender (var-get admin)) (err "unauthorized"))
    
    ;; Add/update the map with status=true
    (map-set verified-users
             (tuple (user user))
             (tuple (status true)))
    
    ;; Return ok(true) to indicate success
    (ok true)
  )
)

;; revoke-user
;; Admin-only function that marks a given address as unverified.
;; Throws an "unauthorized" error if caller is not admin.
(define-public (revoke-user (user principal))
  (begin
    ;; Access control check
    (asserts! (is-eq tx-sender (var-get admin)) (err "unauthorized"))
    
    ;; Add/update the map with status=false
    (map-set verified-users
             (tuple (user user))
             (tuple (status false)))
    
    ;; Return ok(true) to indicate success
    (ok true)
  )
)

;; transfer-admin
;; Allows current admin to transfer admin role to another principal.
;; Throws an "unauthorized" error if caller is not current admin.
(define-public (transfer-admin (new-admin principal))
  (begin
    ;; Access control check
    (asserts! (is-eq tx-sender (var-get admin)) (err "unauthorized"))
    
    ;; Update admin
    (var-set admin new-admin)
    
    ;; Return ok(true) to indicate success
    (ok true)
  )
)


;; --------------------------
;; 3. Read-Only Functions
;; --------------------------

;; is-verified
;; Anyone can call this to check if a given user is verified.
;; Returns true if user is verified, false if unverified or unknown.
(define-read-only (is-verified (user principal))
  (match (map-get? verified-users {user: user})
    entry (ok (get status entry))   ;; return stored boolean
    (ok false)                      ;; default to false if user not in map
  )
)

;; get-admin
;; Returns the current admin principal
(define-read-only (get-admin)
  (ok (var-get admin))
)


;; --------------------------
;; 4. Notes / Best Practices
;; --------------------------

;; - All state-changing operations are protected by access control (admin check).
;; - The verified-users map allows O(1) reads for any principal.
;; - Read-only functions do not modify state and are safe to call freely.
;; - This contract can be extended for:
;;    - Timestamping verifications
;;    - Multi-admin support
;;    - Off-chain event logging for UI
;; - All functions return standard `ok` or `err` to be compatible with Clarinet tests.
