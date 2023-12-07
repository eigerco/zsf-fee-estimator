# zsf-fee-estimator
A simple tool to estimate Zcash transaction fees under the ZIP-317 regime

This tool connects to a Zcash node via `zcash-cli`, queries data about a certain range of blocks and prints out estimates of transaction fees that would be paid out to the miner under the ZIP-317 regime. It was created to aid with estimating the impact of https://github.com/zcash/zips/pull/718.
