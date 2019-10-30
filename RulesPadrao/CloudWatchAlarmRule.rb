require 'cfn-nag/violation'
require 'cfn-nag/custom_rules/base'
#require_relative 'base'

class CloudWatchAlarmRule < BaseRule
     
     def rule_text
         resource = 'AWS::CloudWatch::Alarm'
         "Audit: Resource #{resource} Not Found."
     end

      def rule_type
         Violation::FAILING_VIOLATION
      end

      def rule_id
         'F5000'
      end

      def audit_impl(cfn_model)
          resource = 'AWS::CloudWatch::Alarm'
          query = cfn_model.resources_by_type(resource).length
          output = []
          output << resource if query == 0
          return output      
      end
end

