#!/usr/bin/ruby

require 'json'

ZcashCLIPath='######'

LastBlock=2335514
Blocks=100_000
MarginalFee=5000
GraceActions=2
P2pkhStandardInputSize=150
P2pkhStandardOutputSize=34

def serialize_size(t, type, version)
  150*t.size
end

# This simplifies the ZIP-317 model by using tx["vin"].size rather than serialized_size(tx["vin"])/150. 
# It'd be a bit of complication to implement and I don't think it'll affect the final estimation that much.
def logical_action_count(tx)
  [tx["vin"].size, tx["vout"].size].max +
    2 * tx["vjoinsplit"].size +
    [tx["vShieldedSpend"].size, tx["vShieldedOutput"].size].max +
    (tx.dig("orchard", "actions")&.size || 0)
end

def calculate_fee(action_count)
  MarginalFee * [GraceActions, action_count].max
end

tx_count = 0
tx_sandblasting = 0
fees = 0
action_count = 0

Blocks.times do |n|
  block = `#{ZcashCLIPath} getblock #{LastBlock - Blocks + n} 2`
  block = JSON.parse(block)

  block["tx"].each do |tx|
    actions = logical_action_count(tx)
    tx_count += 1

    # I think this filters out the vast majority of sandblasting transactions. There are more that look suspicious, but
    # there seems to be a lot less of them and removing them would not affect the estimation much.
    if actions == 50 || (500..502).include?(actions) || (1000..1002).include?(actions)
      tx_sandblasting += 1
      next
    end

    fee = calculate_fee(actions)
    action_count += actions
    fees += fee
  end
end

puts "Statistics from block #{LastBlock - Blocks + 1} to block #{LastBlock}"
puts "Number of blocks: #{Blocks}"
puts "Number of transactions: #{tx_count}"
puts "Number of sandblasting transactions: #{tx_sandblasting} (#{"%.2f" % (tx_sandblasting.to_f * 100 / tx_count)}%)"
puts "Estimated average logical action count: #{"%.2f" % (action_count / tx_count.to_f)}"
puts "Total estimated fees: #{fees} (#{"%.2f" % (fees.to_f / 100_000_000)} ZEC)"
puts "Estimated average fees per transaction: #{"%.2f" % (fees / tx_count.to_f)} (#{"%.2f" % (fees / tx_count.to_f / 100_000_000)} ZEC)"
