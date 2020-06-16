require 'openssl'
require_relative 'configuration'

module Sbpayment
  module Crypto
    module_function

    def encrypt(data, cipher_code: Sbpayment.config.cipher_code, cipher_iv: Sbpayment.config.cipher_iv)
      self.check_cipher_keys!(cipher_code, cipher_iv)

      cipher = OpenSSL::Cipher.new 'DES3'
      cipher.encrypt
      cipher.key = cipher_code
      cipher.iv  = cipher_iv
      cipher.padding = 0

      q, r = data.bytesize.divmod 8
      data += ' ' * ((8 * (q + 1)) - data.bytesize) if r > 0

      cipher.update(data) + cipher.final
    end

    def decrypt(data, cipher_code: Sbpayment.config.cipher_code, cipher_iv: Sbpayment.config.cipher_iv)
      self.check_cipher_keys!(cipher_code, cipher_iv)

      cipher = OpenSSL::Cipher.new 'DES3'
      cipher.decrypt
      cipher.key = cipher_code
      cipher.iv  = cipher_iv
      cipher.padding = 0

      (cipher.update(data) + cipher.final).sub(/ +\z/, '') # or use String#rstrip
    end

    def check_cipher_keys!(cipher_code, cipher_iv)
      if cipher_code.nil? || cipher_iv.nil?
        raise ArgumentError.new 'Either cipher_code or cipher_iv are not defined.'
      end
    end
  end
end
