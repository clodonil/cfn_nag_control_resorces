# Auditando CloudFormation com CFN

# Criando Rules Customizadas


# Criando com Políticas de Resources

Criando o arquivo de `Resource Policy`

```
---
# Policy: Os recursos sao negados por padrao
Policy: Deny

#Lista de recursos permitidos
Resources:
   - AWS::ECS::TaskDefinition
   - AWS::ECS::Service
   - AWS::ElasticLoadBalancingV2::TargetGroup
   - AWS::ElasticLoadBalancingV2::Listener
   - AWS::IAM::Role
   - AWS::ApplicationAutoScaling::ScalableTarget
   - AWS::EC2::EIP
   - AWS::EC2::EIPAssociation
   - AWS::ApplicationAutoScaling::ScalingPolicy
```
```
---
# Policy: Os recursos sao permitidos por padrao
Policy: Allow

#Lista de recursos negados
Resources:
   - AWS::IAM::Role
```   

```
$ cfn_nag_scan -r ./resource_Policy/ -i ./cf/
```

# Conclusão