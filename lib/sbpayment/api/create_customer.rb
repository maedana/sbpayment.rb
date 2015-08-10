require_relative '../request'
require_relative '../response'

module Sbpayment
  module API
    class CreateCustomerRequest < Request
      class PayMethodInfo
        include ParameterDefinition

        tag 'pay_method_info'
        key :cc_number,     encrypt: true
        key :cc_expiration, encrypt: true
        key :security_code, encrypt: true
        key :resrv1,        encrypt: true
        key :resrv2,        encrypt: true
        key :resrv3,        encrypt: true
      end
      class PayOptionManage
        include ParameterDefinition

        tag 'pay_option_manage'
        key :cardbrand_return_flg, default: '1'
      end

      tag 'sps-api-request', id: 'MG02-00101-101'
      key :merchant_id, default: -> { Sbpayment.config.merchant_id }
      key :service_id,  default: -> { Sbpayment.config.service_id }
      key :cust_code
      key :sps_cust_info_return_flg, default: '1'
      key :pay_method_info, class: PayMethodInfo
      key :pay_option_manage, class: PayOptionManage
      key :encrypted_flg, default: '1'
      key :request_date, default: -> { Time.now.strftime('%Y%m%d%H%M%S') }
      key :limit_second
      key :sps_hashcode
    end

    class CreateCustomerResponse < Response
      DECRYPT_PARAMETERS = %i(res_pay_method_info.cardbrand_code).freeze
    end
  end
end
