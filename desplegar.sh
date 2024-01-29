#!/bin/bash

# Nombre de la pila que se va a desplegar
stack_name="StackPrueba"

# Nombre del archivo YAML de la plantilla
template_file="main.yaml"

# Comando para desplegar la pila
aws cloudformation deploy \
  --stack-name $stack_name \
  --template-file $template_file \
  --capabilities CAPABILITY_IAM

echo "La pila $stack_name ha sido desplegada correctamente."