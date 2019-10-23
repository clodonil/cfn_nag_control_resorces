# frozen_string_literal: true
require 'cfn-nag/violation'
require 'cfn-nag/custom_rules/base'
require 'yaml'
#require_relative 'base'

class ControlPolicyRule < BaseRule
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
      cnf = YAML::load(File.open('../rules/resource_policy_deny.yml'))
  end
  ##
  # This will behave slightly different than the legacy jq based rule which was
  # targeted against inline ingress only
  def audit_impl(cfn_model)
    control = load()
    resources = []
    lista_control = {}
    rule = ""

    query = cfn_model.resources()

    for resource in query.keys do
        resources << query[resource].resource_type
    end

    
    control['Resources'].each { |resource|

      if resources.include?(resource) then
         lista_control[resource] = true
      else
         lista_control[resource] = false    
      end
    }

    if control['Policy'].upcase == 'ALLOW' then
        if lista_control.select {|k,v| v == true}.length > 0 then
           rule = lista_control.select {|k,v| v == true}
        end
    elsif control['Policy'].upcase == 'DENY' then
        puts "entrou no deny"
        if lista_control.select {|k,v| v == false}.length > 0 then
           rule = lista_control.select {|k,v| v == false}
        end

    end
    
    puts rule
    #lista_control.map { |policy| policy.logical_resource_id }
  end
end