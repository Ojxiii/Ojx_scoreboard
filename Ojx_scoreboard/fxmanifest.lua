fx_version 'cerulean'
game 'gta5'
author 'Ojx'
description 'idk its a scoreboard with kinda inspired ui'
version '1.0'

shared_script {
    '@ox_lib/init.lua',
    'shared/config.lua'

}

client_script {
    '@qbx_core/modules/playerdata.lua',
    'client/*.lua'
}
server_script 'server/*.lua'

ui_page 'html/index.html'

files {
    'html/*',
    'html/backend/*.js',
    'html/style/*.css'
}

lua54 'yes'