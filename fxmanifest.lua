fx_version 'cerulean'
game 'gta5'
author 'fatality#7777'
description 'Admin system'
version '1.1.0'

shared_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'locales/es.lua',
    'locales/fa.lua',
    'config.lua'
}
client_script 'client.lua'
server_script "server.lua"


dependency "es_extended"
