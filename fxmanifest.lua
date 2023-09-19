fx_version "adamant"
game "gta5"
use_fxv2_oal "yes"
lua54 "yes"

name "ay-playtime"
author "Array's Development | Array"
version "1.1.0"
description "Playtime script made for FiveM server which uses playtime based interactions"

shared_scripts { '@es_extended/imports.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'src/server/*.lua' }