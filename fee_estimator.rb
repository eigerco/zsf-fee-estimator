#!/usr/bin/ruby

require 'json'

ZcashCLIPath='######'

StartBlock=2321725
Blocks=1000
MarginalFee=5000
GraceActions=2
P2pkhStandardInputSize=150
P2pkhStandardOutputSize=34

def serialize_size(t, type, version)
  150*t.size
end

def logical_action_count(tx)
  #tx_in_total_size = serialize_size(tx["vin"], 2, 170100);
  #tx_out_total_size = serialize_size(tx["vout"], 2, 170100);

    #[(tx_in_total_size.to_f / P2pkhStandardInputSize).ceil,
    #                (tx_out_total_size.to_f / P2pkhStandardOutputSize).ceil].max +
  [tx["vin"].size, tx["vout"].size].max +
    2 * tx["vjoinsplit"].size +
    [tx["vShieldedSpend"].size, tx["vShieldedOutput"].size].max +
    (tx.dig("orchard", "actions")&.size || 0)
end

def calculate_fee(action_count)
  MarginalFee * [GraceActions, action_count].max
end

tx_count = 0
fees = 0
action_count = 0

Blocks.times do |n|
  block = `#{ZcashCLIPath} getblock #{StartBlock - n} 2`
  block = JSON.parse(block)

  block["tx"].each do |tx|
    actions = logical_action_count(tx)
    fee = calculate_fee(actions)
    tx_count += 1
    action_count += actions
    fees += fee
  end
end

puts "Statistics from block #{StartBlock - Blocks + 1} to block #{StartBlock}"
puts "Number of blocks: #{Blocks}"
puts "Number of transactions: #{tx_count}"
puts "Estimated average logical action count: #{"%.2f" % (action_count / tx_count.to_f)}"
puts "Total estimated fees: #{fees} (#{"%.2f" % (fees.to_f / 100_000_000)} ZEC)"
puts "Estimated average fees per transaction: #{"%.2f" % (fees / tx_count.to_f)} (#{"%.2f" % (fees / tx_count.to_f / 100_000_000)} ZEC)"
