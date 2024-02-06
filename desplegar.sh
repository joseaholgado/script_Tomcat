#!/bin/bash

# Nombre de la pila que se va a desplegar
stack_name="StackPrueba"

# Nombre del archivo YAML de la plantilla
template_file="ubuntu.yml"

# Comando para desplegar la pila
aws cloudformation deploy \
  --stack-name $stack_name \
  --template-file $template_file \
  --capabilities CAPABILITY_IAM
   --no-fail-on-empty-changeset > errores_log.txt 2>&1

# Verificar el estado de salida del comando
if [ $? -eq 0 ]; then
  echo "La pila $stack_name ha sido desplegada correctamente."
else
  echo "Error: No se pudo desplegar la pila $stack_name. Consulta el archivo de registro para obtener más detalles."
fi

#Verificar el ip

if [ $? -eq 0 ]; then
    aws cloudformation list-exports \
        --query "Exports[?Name=='NOMBRE PARAMETRO DE SALIDA'].Value"
fi