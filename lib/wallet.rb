require 'csv'
require 'json'
require 'pry'
  # all wallets array
  WALLETS = []

class Wallet
  attr_reader :client, :currency, :amount
  attr_writer :amount
  def initialize(client, currency, amount)
    @client = client
    @currency = currency
    @amount = amount
    WALLETS << self
  end

  private

  # Method to load CSV wallets.
  def self.load
    #
    filepath = 'resources/wallets.csv'
    #
    csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
    CSV.foreach(filepath, csv_options) do |row|
    Wallet.new(row['Client'], row['Currency'], row['Amount'])
    end
  end

  def self.json_output
    # create a json filepath
    filepath = 'resources/wallets_output.json'
    # wallets that will be written in json format
    output_wallets = []

    WALLETS.each_with_index do |wallet, index|
     # separate the wallets with the same client as the one in the current loop
      same_name = WALLETS.select { |x| wallet.client == x.client }
      # save the client name in the output and create a hash wallets
      output_wallets << {
                            name: "#{wallet.client}",
                            "wallets": {}
                          }
      # grab the wallets that has the same client and store their wallets in the empty hash
      same_name.each do |x|
        output_wallets[index][:wallets].store("#{x.currency}", "#{x.amount}")
      end
    end
    # remove duplicates in the output
    output_wallets.uniq!
    # generate json
    File.open(filepath, 'wb') do |file|
      file.write(JSON.generate(output_wallets))
    end
  end

  # Method to save new csv
  def self.save
    filepath    = 'resources/wallets.csv'
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << ['Client', 'Currency', 'Amount']
      WALLETS.each do |wallet|
        csv << [wallet.client, wallet.currency, wallet.amount]
      end
    end
  end
end

