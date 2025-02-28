# Ansible Role: ubuntu_mate_desktop_customization

This role allows for customization of a MATE surface.

## Role Variables

| Variable name   | Type   | Default                    | Description                                              |
|-----------------|--------|----------------------------|----------------------------------------------------------|
| customize_user    | string | NA   | Username for whom to customize the desktop |
| customize_theme_name* | string | NA | Themename |
| customize_theme_package* | string | NA | Name of theme-package |
| desktop_bg_src | string | files/wallpaper.jpg | Local image to be set as the backgroud image |
| launcher_objects | dict | NA | Holds all launcher objects to be created and set |
| &nbsp;&nbsp;&nbsp;&nbsp;∟ object-name | string | NA | Name of the launcher object |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;∟ launcher-location | string | (normally: /usr/share/applications/\<object-name\>.desktop) | Location of the respective .desktop file |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;∟ position* | string | NA | Nummeric indicator for ordering (ASC) |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;∟ object-type* | string | launcher | should remain unchanged |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;∟ toplevel-id* | string | top | 'top' or 'bottom' |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;∟ menu-path* | string | applications:/ | Menu path |
| mate_autostart_absent_list | list | [...] | List of files to remove from `/etc/xdg/autostart` mate autostart |

## Example Playbook

```yml
- hosts:
    - <ip-address>
  roles:
    - ubuntu_mate_desktop_customization
```

## License

GPL-3.0

## Author Information

Lenhard Reuter
Benjamin Akhras
