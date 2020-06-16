require 'spec_helper'

describe Sbpayment::Request do
  describe 'configuration' do
    context 'when fill by configuration' do
      before do
        Sbpayment.configure do |x|
          x.basic_auth_user = 'user'
          x.basic_auth_password = 'password'
          x.hashkey = 'hashkey'
          x.cipher_code = 'cipher_code'
          x.cipher_iv = 'cipher_iv'
        end
      end

      it 'works' do
        request = Sbpayment::Request.new
        expect(request.basic_auth_user).to eq 'user'
        expect(request.basic_auth_password).to eq 'password'
        expect(request.hashkey).to eq 'hashkey'
        expect(request.cipher_code).to eq 'cipher_code'
        expect(request.cipher_iv).to eq 'cipher_iv'
      end
    end

    context 'when fill by accessor' do
      before do
        Sbpayment.configure do |x|
          x.basic_auth_user = nil
          x.basic_auth_password = nil
          x.hashkey = nil
          x.cipher_code = nil
          x.cipher_iv = nil
        end
      end

      it 'works' do
        request = Sbpayment::Request.new
        request.basic_auth_user = 'user'
        request.basic_auth_password = 'password'
        request.hashkey = 'hashkey'
        request.cipher_code = 'cipher_code'
        request.cipher_iv = 'cipher_iv'
        expect(request.basic_auth_user).to eq 'user'
        expect(request.basic_auth_password).to eq 'password'
        expect(request.hashkey).to eq 'hashkey'
        expect(request.cipher_code).to eq 'cipher_code'
        expect(request.cipher_iv).to eq 'cipher_iv'
      end
    end
  end
end
