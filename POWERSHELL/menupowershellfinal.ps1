#Importamos los comandos necesarios
Import-Module ActiveDirectory

#Dominio
$dominio = (Get-ADDomain).DistinguishedName
$dnsDom  = (Get-ADDomain).DNSRoot

#1. Vistazo del menu
do {
        Clear-Host
        #1)Mostrar menu
        Write-Host "=== Menu Active Directory ==="
        Write-Host "1.Información del dominio"
        Write-Host "2. Crear OU"
        Write-Host "3. Crear grupo"
        Write-Host "4. Crear usuario"
        Write-Host "5. Salir"

        #2. Elegir una opción
        $option = Read-Host "Elige una opción"

        #3 Según la opción, rellenar

        switch ($option) {

        #Opción 1: Información del dominio

        "1" {
                Write-Host "Nombre del equipo : $env:COMPUTERNAME"
                Write-Host "Nombre del dominio : $dnsDom"
                Write-Host "Número de OUs : $((Get-ADOrganizationalUnit -Filter *).Count)"
                Write-Host "Número de grupos : $((Get-ADGroup -Filter *).Count)"
                Write-Host "Número de usuarios : $((Get-ADUser -Filter *).Count)"
                Read-Host "Pulsa ENTER para continuar"
            }

        #Opción 2: Crear OU

        "2" {
                $ou = Read-Host "Nombre de la Unidad Organizativa"

                # Comprobamos que no exista ya una OU con ese nombre
                if (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'") {
                    Write-Host "Ya existe una OU llamada '$ou'." -ForegroundColor Red
                } else {
                    New-ADOrganizationalUnit -Name $ou
                    Write-Host "La OU '$ou' ha sido creada correctamente"
                }
                Read-Host "Pulsa ENTER para continuar"
            }

        #Opción 3: Crear grupo

        "3" {
                $grupo = Read-Host "Nombre del grupo"
                $ou    = Read-Host "Nombre de la Unidad Organizativa donde se creará"
                $ruta  = "OU=$ou,$dominio"

                # Comprobamos que la OU exista antes de intentar crear el grupo en ella
                if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'")) {
                    Write-Host "La OU '$ou' no existe. Créala primero con la opción 2." -ForegroundColor Red
                }
                elseif (Get-ADGroup -Filter "Name -eq '$grupo'") {
                    Write-Host "Ya existe un grupo llamado '$grupo'." -ForegroundColor Red
                }
                else {
                    New-ADGroup -Name $grupo -GroupScope Global -Path $ruta
                    Write-Host "El grupo '$grupo' ha sido creado correctamente en la OU '$ou'"
                }
                Read-Host "Pulsa ENTER para continuar"
            }

        #Opción 4: Crear usuario

        "4" {
                $nombre   = Read-Host "Introduzca el nombre"
                $apellido = Read-Host "Introduzca el apellido"
                $login    = Read-Host "Nombre de inicio de sesión (ej. alopez)"
                $ou       = Read-Host "Nombre de la Unidad Organizativa donde se creará"
                $grupo    = Read-Host "Nombre del grupo al que pertenecerá"
                $clave    = Read-Host "Contraseña inicial" -AsSecureString

                # La ruta del USUARIO se construye con la OU, no con el grupo
                $ruta = "OU=$ou,$dominio"

                # Comprobamos que la OU y el grupo existan antes de crear nada
                if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'")) {
                    Write-Host "La OU '$ou' no existe. Créala primero con la opción 2." -ForegroundColor Red
                }
                elseif (-not (Get-ADGroup -Filter "Name -eq '$grupo'")) {
                    Write-Host "El grupo '$grupo' no existe. Créalo primero con la opción 3." -ForegroundColor Red
                }
                else {
                    New-ADUser -Name "$nombre $apellido" `
                               -GivenName $nombre `
                               -Surname $apellido `
                               -SamAccountName $login `
                               -UserPrincipalName "$login@$dnsDom" `
                               -Path $ruta `
                               -AccountPassword $clave `
                               -Enabled $true `
                               -ChangePasswordAtLogon $true

                    # Add-ADGroupMember NO lleva -Path, solo -Identity y -Members
                    Add-ADGroupMember -Identity $grupo -Members $login

                    Write-Host "Usuario '$login' creado y añadido al grupo '$grupo'"
                }
                Read-Host "Pulsa ENTER para continuar"
            }

        #Opción 5: Salir

        "5" {
                Write-Host "Adiós"
                Start-Sleep -Seconds 2
                exit
            }

        # Cualquier otra cosa

        default {
                Write-Host "Opción no válida"
                Read-Host "Pulsa ENTER para continuar"
            }

        }
}
# Repetir mientras no sea la opción 5
while ($option -ne "5")