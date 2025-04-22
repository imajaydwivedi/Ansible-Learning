# Preparing a Windows Hosts

- Ensure there is a windows user with Administrative privileges.
- Login in as the User with Administrative privileges.
- Create an ansible user with Administrative privileges
- Open powershell: "winrm quickconfig"
- Change the Windows settings to make connection easy (and without using TLS certificates)

```
winrm quickconfig

winrm get winrm/config/Service

Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value "true"

Set-Item WSMan:\localhost\Service\Auth\Basic -Value "true"

Set-Item WSMan:\localhost\Service\Auth\CredSSP -Value "true"

Set-Item WSMan:\localhost\Client\Auth\CredSSP -Value "true"

Enable-WSManCredSSP -Role Server

Enable-PSRemoting -Force

winrm enumerate winrm/config/listener

<#
Listener
    Address = *
    Transport = HTTP
    Port = 5985
    Hostname
    Enabled = true
    URLPrefix = wsman
    CertificateThumbprint
    ListeningOn = 127.0.0.1, 169.254.121.28, 192.168.1.10, 192.168.100.10, 192.168.200.10, ::1, fe80::4e63:d064:98b9:85a9%10, fe80::aa6c:d409:2521:217f%11
#>
```

> [!NOTE]
> To set ansible user password skipping password policy check, use following powershell code -

```
$defaultPolicy = Get-ADDefaultDomainPasswordPolicy -Current LoggedOnUser

$defaultPolicy | Set-ADDefaultDomainPasswordPolicy -ComplexityEnabled $false -MinPasswordLength 6
Set-ADAccountPassword -Identity ansible -Reset -NewPassword (ConvertTo-SecureString "ansible" -AsPlainText -Force)
$defaultPolicy | Set-ADDefaultDomainPasswordPolicy -ComplexityEnabled $True -MinPasswordLength 7
```

# Managing Windows

- On Ansible control host, create the windows project directory with an ansible.cfg and an inventory
- Setup /etc/hosts for hostname resolution to the Windows box - notice that Windows firewall disallows ping incoming
- Use "ansible-galary collection install ansible.windows --force --upgrade"
- On Ansible control, install python modules. If windows virtual environment, then remove sudo:
  - `sudo pip install pywinrm`
  - `sudo pip install requests-credssp`
  - Validate collection `ansible-galaxy collection list | grep -i windows`
  - `ansible win -i inventory -m ansible.windows.win_ping`
  - Make sure the passwords match!
- Check inventory: `ansible win -i inventory -m ansible.windows.setup`

# Configuring Authentication

- Windows supports different authentication protocols.
- If authentication has been configured to a strict protocol on Windows, you may have to set up Ansible accordingly,
  - Basic: only supports local accounts - do not use
  - Certificate: only supports local accounts - do not use
  - Kerberos: only works for AD accounts
  - NTLM: works for local and AD accounts
  - CredSSP: offers best support for local and AD accounts
- Use `ansible_winrm_transport: credssp` if you have authentication issues.

