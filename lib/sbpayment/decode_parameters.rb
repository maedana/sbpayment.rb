require 'base64'
require_relative 'crypto'

module Sbpayment
  module DecodeParameters
    def decode(parameters, need_decrypt=false, cipher_code: Sbpayment.config.cipher_code, cipher_iv: Sbpayment.config.cipher_iv)
      encrypted = need_decrypt ? fetch_const('DECRYPT_PARAMETERS') : []
      encoded   = fetch_const 'DECODE_PARAMETERS'

      # decrypt
      (encrypted & parameters.keys).each do |key|
        parameters[key] = Sbpayment::Crypto.decrypt Base64.strict_decode64(parameters[key]), cipher_code: cipher_code, cipher_iv: cipher_iv
      end

      # change encoding encrypted multibyte string
      (encrypted & parameters.keys & encoded).each do |key|
        parameters[key] = Sbpayment::Encoding.sjis2utf8 parameters[key]
      end

      # change encoding non-encrypted multibyte string
      ((encoded - encrypted) & parameters.keys).each do |key|
        parameters[key] = Sbpayment::Encoding.sjis2utf8 Base64.strict_decode64 parameters[key]
      end

      parameters
    end

    private

    def fetch_const(name, default=[])
      self.class.const_defined?(name) ? self.class.const_get(name) : default
    end
  end
end
