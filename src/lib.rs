mod utils;

use num_bigint::{BigUint, ToBigInt};
use num_iter::range;
use std::collections::HashMap;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern "C" {
    fn alert(s: &str);
}

#[wasm_bindgen]
pub fn greet() {
    alert("Hello, wasm-prime!");
}

pub enum PrimeStatus {
    Prime,
    Composite,
    CheckedUntil(BigUint),
}

#[wasm_bindgen]
pub struct PrimeChecker {
    results: HashMap<BigUint, PrimeStatus>,
}

#[wasm_bindgen]
impl PrimeChecker {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Self {
        PrimeChecker {
            results: HashMap::new(),
        }
    }

    pub fn call(&mut self, n_str: String) -> String {
        let n = match BigUint::parse_bytes(&n_str.into_bytes(), 10) {
            Some(n) => n,
            None => return "Whoops".to_string(),
        };

        // Check if n is 0 or 1
        if n == BigUint::parse_bytes(b"0", 10).unwrap()
            || n == BigUint::parse_bytes(b"0", 10).unwrap()
        {
            self.results.insert(n, PrimeStatus::Composite);
            return "composite".to_string();
        }

        // Check if we've already computed this or have partial results
        let start = match self.results.get(&n) {
            Some(PrimeStatus::Prime) => return "prime".to_string(),
            Some(PrimeStatus::Composite) => return "composite".to_string(),
            Some(PrimeStatus::CheckedUntil(k)) => k + BigUint::from(1_u32),
            None => BigUint::parse_bytes(b"2", 10).unwrap(),
        };

        let budget = BigUint::parse_bytes(b"10_000_000", 10).unwrap();

        let end = std::cmp::min(&start + budget, n.clone());

        for i in range(start, end.clone()) {
            if &n % i == BigUint::ZERO {
                self.results.insert(n, PrimeStatus::Composite);
                return "composite".to_string();
            }
        }

        // Update status based on how far we checked
        if end == n {
            // We've checked all possible divisors, it's prime
            self.results.insert(n, PrimeStatus::Prime);
            return "prime".to_string();
        } else {
            // We've checked up to 'end', but not all divisors
            self.results.insert(n, PrimeStatus::CheckedUntil(end));
            return "unknown".to_string();
        }
    }
}

#[wasm_bindgen]
pub fn is_prime(n: u64) -> String {
    if n == 0 || n == 1 {
        return "composite".to_string();
    }
    for i in 2..n {
        if n % i == 0 {
            return "composite".to_string();
        }
    }
    "prime".to_string()
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_prime_filter() {
        let primes: Vec<_> = (0..50).filter(|&n| is_prime(n)).collect();

        let expected_primes = vec![2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47];

        assert_eq!(primes, expected_primes);
    }
}
