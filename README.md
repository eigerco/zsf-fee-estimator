# zsf-fee-estimator
A simple tool to estimate Zcash transaction fees under the ZIP-317 regime

This tool connects to a Zcash node via `zcash-cli`, queries data about a certain range of blocks and prints out estimates of transaction fees that would be paid out to the miner under the ZIP-317 regime. It was created to aid with estimating the impact of https://github.com/zcash/zips/pull/718.

## Example output

```
Statistics from block 2216606 to block 2321725
Number of blocks: 105120
Number of transactions: 344647
Estimated average logical action count: 19.43
Total estimated fees: 33649575000 (336.50 ZEC)
Estimated average fees per transaction: 97634.90 (0.00 ZEC)
```
