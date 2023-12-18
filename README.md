# zsf-fee-estimator
A simple tool to estimate Zcash transaction fees under the ZIP-317 regime

This tool connects to a Zcash node via `zcash-cli`, queries data about a certain range of blocks and prints out estimates of transaction fees that would be paid out to the miner under the ZIP-317 regime. It was created to aid with estimating the impact of https://github.com/zcash/zips/pull/718.

## Example output

```
Statistics from block 2235515 to block 2335514
Number of blocks: 100000
Number of transactions: 316130
Number of sandblasting transactions: 60608 (19.17%)
Estimated average logical action count: 5.46
Total estimated fees: 8786475000 (87.86 ZEC)
Estimated average fees per transaction: 27793.87 (0.00 ZEC)
```
