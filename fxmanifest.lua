fx_version  'adamant'
use_experimental_fxv2_oal 'yes'
lua54       'yes'
game        'gta5'

name        'SY_CARRY'
author      'SYNO'
version     'QB 1.0'
license     'GNU General Public License v3.0'
repository  'https://github.com/SYNO-SY/SY_Carry QBCore'
description 'A Carry Script With Request System for Fivem RP Server'

ui_page 'ui/ui.html'

files {
	'ui/ui.html',
	'ui/styles.css',
	'ui/scripts.js',
	'ui/img/*.png'
}

shared_scripts {
    'config.lua',
}

server_scripts {
	'server/*.lua'
}

client_scripts {
	'client/*.lua'
}



