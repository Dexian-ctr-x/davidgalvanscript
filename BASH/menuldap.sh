#!/bin/bash
path="cn=admin,dc=david2026,dc=ldap"
dominio="dc=david2026,dc=ldap"

PS3="Seleccione una opcion [1-4]: "
optionsec=("Eliminar correo de un usuario"
            "Modificar correo de un usuario"
            "Busqueda (Consultar o Listar)"
            "Salir")

echo "=================== MENU LDAP - DAVID GALVÁN ZERPA ================="
select optionmenu in "${optionsec[@]}"
do
    case $optionmenu in
        "Eliminar correo de un usuario")
            echo ""
            read -p "Ingrese el UID del usuario: " usuario
            read -p "Ingrese la OU del usuario (Alumnado o Profesorado): " ou

            # Crear archivo ldif para borrar el correo
            echo "dn: uid=$usuario,ou=$ou,$dominio" > /tmp/eliminar_correo.ldif
            echo "changetype: modify" >> /tmp/eliminar_correo.ldif
            echo "delete: mail" >> /tmp/eliminar_correo.ldif

            ldapmodify -x -D "$path" -W -f /tmp/eliminar_correo.ldif
            rm -f /tmp/eliminar_correo.ldif
            echo "¡PROCESO DE ELIMINACIÓN COMPLETADO!"
            ;;

        "Modificar correo de un usuario")
            echo ""
            read -p "Ingrese el UID del usuario: " usuario
            read -p "Ingrese la OU del usuario (Alumnado o Profesorado): " ou
            read -p "Ingrese el nuevo correo del usuario: " correo

            # Crear archivo ldif para modificar el correo
            echo "dn: uid=$usuario,ou=$ou,$dominio" > /tmp/modificar_correo.ldif
            echo "changetype: modify" >> /tmp/modificar_correo.ldif
            echo "replace: mail" >> /tmp/modificar_correo.ldif
            echo "mail: $correo" >> /tmp/modificar_correo.ldif

            ldapmodify -x -D "$path" -W -f /tmp/modificar_correo.ldif
            rm -f /tmp/modificar_correo.ldif
            echo "¡PROCESO DE MODIFICACIÓN COMPLETADO!"
            ;;

        "Busqueda (Consultar o Listar)")
            echo ""
            echo "a. Consultar un usuario concreto"
            echo "b. Listar TODOS los usuarios (Nombre y Correo)"
            read -p "Elija opción [a/b]: " election

            if [[ "$election" == "a" ]]; then
                read -p "Ingrese el UID a consultar: " busq
                ldapsearch -x -b "$dominio" "(uid=$busq)" cn mail uid
            elif [[ "$election" == "b" ]]; then
                echo ""
                echo "Listado de todos los usuarios"
                ldapsearch -x -b "$dominio" "(objectClass=inetOrgPerson)" cn mail
            else
                echo "Opción incorrecta"
            fi

            echo " ================================== "
            ;;

        "Salir")
            echo "Saliendo del menú LDAP..."
            break
            ;;

        *)
            echo "Opción no válida. Intente de nuevo."
            ;;
    esac
done
