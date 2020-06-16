require 'xmlsimple'
require_relative 'shallow_hash'
require_relative 'decode_parameters'

module Sbpayment
  class Response
    using ShallowHash

    include DecodeParameters

    attr_reader :status, :headers, :body

    def initialize(status, headers, body, need_decrypt: false, cipher_code: Sbpayment.config.cipher_code, cipher_iv: Sbpayment.config.cipher_iv)
      @status  = status
      @headers = headers
      @body    = XmlSimple.xml_in(body, forcearray: false, noattr: true, keytosymbol: true, suppressempty: true).shallow
      @body    = decode @body, need_decrypt, cipher_code: cipher_code, cipher_iv: cipher_iv
    end

    def error
      code = body[:res_err_code]
      code && APIError.parse(code)
    end
  end
end
