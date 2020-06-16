require 'spec_helper'

describe Sbpayment::DecodeParameters do
  let(:key)  { SecureRandom.hex 12 }
  let(:iv)   { SecureRandom.hex  4 }

  class Example
    include Sbpayment::DecodeParameters
    DECRYPT_PARAMETERS = %i(foo bar)
    DECODE_PARAMETERS  = %i(foo     baz)
  end

  class ExampleWithNoConst
    include Sbpayment::DecodeParameters
  end

  context 'when cipher_code and cipher_iv are defined' do
    before do
      Sbpayment.configure do |x|
        x.cipher_code = key
        x.cipher_iv   = iv
      end
    end

    it 'returns hash w/o decode' do
      params = {
        foo: 'foo',
        bar: 'bar',
        baz: 'baz',
      }
      expect(ExampleWithNoConst.new.decode(params)).to eq(foo: 'foo', bar: 'bar', baz: 'baz')
    end

    it 'returns decoded hash' do
      params = {
        foo: b(e('ふー'.encode('Shift_JIS'))),
        bar: b(e('bar')),
        baz: b('baz'),
      }
      expect(Example.new.decode(params, true)).to eq(foo: 'ふー', bar: 'bar', baz: 'baz')
    end

    it 'returns decoded hash' do
      params = {
        foo: b('ふー'.encode('Shift_JIS')),
        bar: b('bar'),
        baz: b('baz'),
      }
      expect(Example.new.decode(params, false)).to eq(foo: 'ふー', bar: b('bar'), baz: 'baz')
    end
  end

  context 'when cipher_code and cipher_iv are defined by arguments' do
    before do
      Sbpayment.configure do |x|
        x.cipher_code = nil
        x.cipher_iv   = nil
      end
    end

    it 'returns hash w/o decode' do
      params = {
        foo: 'foo',
        bar: 'bar',
        baz: 'baz',
      }
      expect(ExampleWithNoConst.new.decode(params)).to eq(foo: 'foo', bar: 'bar', baz: 'baz')
    end

    it 'returns decoded hash' do
      params = {
        foo: b(e('ふー'.encode('Shift_JIS'))),
        bar: b(e('bar')),
        baz: b('baz'),
      }
      expect(Example.new.decode(params, true, cipher_code: key, cipher_iv: iv)).to eq(foo: 'ふー', bar: 'bar', baz: 'baz')
    end

    it 'returns decoded hash' do
      params = {
        foo: b('ふー'.encode('Shift_JIS')),
        bar: b('bar'),
        baz: b('baz'),
      }
      expect(Example.new.decode(params, false)).to eq(foo: 'ふー', bar: b('bar'), baz: 'baz')
    end
  end

  def e(str)
    Sbpayment::Crypto.encrypt str, cipher_code: key, cipher_iv: iv
  end

  def b(str)
    Base64.strict_encode64 str
  end
end
