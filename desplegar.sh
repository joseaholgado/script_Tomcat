#!/bin/bash
aws cloudformation deploy --profile default --stack-name PilaTomcat --template-file ubuntu.yml

#Verificar la ip
if [ $? -eq 0 ]; then
    aws cloudformation list-exports --query "Exports[?Name=='IPInstancia'].Value" --output text
fi