#!/bin/bash

# Nombre de la pila que se va a borrar
stack_name="StackPrueba"

# Comando para borrar la pila
aws cloudformation delete-stack \
  --stack-name $stack_name

# Esperar hasta que la eliminación de la pila esté completa
aws cloudformation wait stack-delete-complete \
  --stack-name $stack_name

echo "La pila $stack_name ha sido eliminada correctamente."
