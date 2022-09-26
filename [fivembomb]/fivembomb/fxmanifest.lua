fx_version 'bodacious'
games {'gta5'}

description 'Fivem bomb'
name 'fivembomb'
author 'Fivem Bomb'
version 'v1.0.0'


ui_page('html/index.html')

files({
    'html/index.html',
    'html/*.js',
    'html/style.css',
    'html/*.wav',
    'html/cursor.png'
})

server_scripts {
    'config.lua',
    'server/main.lua'
}

client_scripts {
    'config.lua',
    'client/main.lua'
}

