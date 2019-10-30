require 'cfn-model'
require './rules/IamManagedPolicyNotActionRule'

#describe ControlPolicyRule do
#  context 'resource com backlist' do
#    it 'returns offending logical resource ids' do
      cfn_model = CfnParser.new.parse IO.read('./cf/template.yml')

      resources = IamManagedPolicyNotActionRule.new.audit_impl cfn_model

    #  puts resources

#      expected_logical_resource_ids = %w[eip EipAssoc]

#      expect(actual_logical_resource_ids).to eq expected_logical_resource_ids
#    end
#  end
#end