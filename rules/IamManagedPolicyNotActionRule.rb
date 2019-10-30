# frozen_string_literal: true
require 'cfn-nag/violation'
require 'cfn-nag/custom_rules/base'
require 'yaml'
#require_relative 'base'

class IamManagedPolicyNotActionRule < BaseRule
  def rule_text
    'Security Groups found egress with other port instead of port 443'
  end

  def rule_type
    Violation::FAILING_VIOLATION
  end

  def rule_id
    'F9000'
  end

  def load
      cnf = YAML::load(File.open('./rules/resource_policy_deny.yml'))
      return cnf
  end
  
  
  def audit_impl(cfn_model)
    list_result = {}
    resources = []
    rule = ""

    # Lista de recursos controlados 
    list_control = load()
    
    # Parse do tempalte
    query = cfn_model.resources()

    # Lista os recursos do template
    for resource in query.keys do
        resources << query[resource].resource_type
    end

    # Check entre lista de controle e template
    resources.each{|resource|
      if list_control['Resources'].include?(resource) then
        list_result[resource] = true
      else
        list_result[resource] = false
      end  
    }
    
    if list_control['Policy'].upcase == 'ALLOW' then
        if list_result.select {|k,v| v == true}.length > 0 then
           rule = list_result.select {|k,v| v == true}
        end
    elsif list_control['Policy'].upcase == 'DENY' then
        if list_result.select {|k,v| v == false}.length > 0 then
           rule = list_result.select {|k,v| v == false}
        end

    end
    
    resources = []
    for resource in query.keys do
       for control in rule.keys do
          if control == query[resource].resource_type
             #resources << query[resource].logical_resource_id
             resources << query[resource].resource_type
          end
       end
    end
    
    #resources = []
    #resources << 'AWS::CloudWatch::Alarm'
    return resources
  end
end