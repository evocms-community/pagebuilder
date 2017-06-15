<?php

    return [
        'title' => 'All fields',

        'templates' => [
            'owner' => '
                <div>Text:<br> [+text+]</div>
                <div>Dropdown:<br> [+dropdown+]</div>
                <div>Rextarea:<br> [+textarea+]</div>
                <div>Richtext:<br> [+richtext+]</div>
                <div>Image:<br> [+image+]</div>
                <div>File:<br> [+file+]</div>
                <div>Date:<br> [+date+]</div>
                <div>Checkbox:<br> [+checkbox+]</div>
                <div>Radio:<br> [+radio+]</div>
            ',

            'checkbox' => '<span>[+title+] ([+value+])</span> ',
        ],

        'fields' => [
            'text' => [
                'caption' => 'Text',
                'type'    => 'text',
            ],

            'dropdown' => [
                'caption'  => 'Dropdown',
                'type'     => 'dropdown',
                'elements' => '@SELECT pagetitle, id FROM modx_site_content',
            ],

            'textarea' => [
                'caption' => 'Textarea',
                'type'    => 'textarea',
                'default' => 'Default content for textarea',
                'height'  => '80px',
            ],

            'richtext' => [
                'caption' => 'Richtext',
                'type'    => 'richtext',
                'default' => 'Default content for richtext',
                'theme'   => 'mini',
                'options' => [
                    'height' => '80px',
                ],
            ],

            'image' => [
                'caption' => 'Image',
                'type'    => 'image',
            ],

            'file' => [
                'caption' => 'File',
                'type'    => 'file',
            ],

            'date' => [
                'caption' => 'Date',
                'type'    => 'date',
            ],

            'checkbox' => [
                'caption'  => 'Checkbox',
                'type'     => 'checkbox',
                'layout'   => 'horizontal',
                'elements' => [
                    0 => 'No',
                    1 => 'First',
                    2 => 'Second',
                ],
                'default' => [ 1, 2 ],
            ],

            'radio' => [
                'caption'  => 'Radio',
                'type'     => 'radio',
                'layout'   => 'horizontal',
                'elements' => 'No==0||First==1||Second==2',
                'default'  => 1,
            ],
        ],
    ];

