require_relative 'wallet'

class WalletCentral

  def initialize
    Wallet.load
  end

  def transfer(wallet1, wallet2, currency, amount_transfered)
  end

end

