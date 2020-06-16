require 'xmlsimple'
require_relative 'shallow_hash'
require_relative 'decode_parameters'
require_relative 'parameter_definition'

module Sbpayment
  class CallbackRequest
    using ShallowHash

    include DecodeParameters
    include ParameterDefinition

    attr_reader :headers, :body

    def initialize(headers, body, need_decrypt: false, cipher_code: Sbpayment.config.cipher_code, cipher_iv: Sbpayment.config.cipher_iv)
      @headers = headers
      @body    = XmlSimple.xml_in(body, forcearray: false, noattr: true, keytosymbol: true, suppressempty: true).shallow
      @body    = decode @body, need_decrypt, cipher_code: cipher_code, cipher_iv: cipher_iv
    end

    def response_class
      self.class.const_get self.class.name.sub(/Request\z/, 'Response')
    end
  end
end
