<?php

	return [
		'title' => 'Слайдер с заголовком и каруселькой',

		'templates' => [
			'owner' => '
				<div class="section">
					<div class="container">
						<h2>[+title+]</h2>
				
						<div class="cycle">
							<div class="slick" id="cycle" data-slick=\'{ "asNavFor": "#cycle-pager" }\'>
								[+images.main+]
							</div>
						</div>
				
						<div class="cycle">
							<div class="slick" id="cycle-pager" data-slick=\'{ "slidesToShow": 4, "asNavFor": "#cycle", "focusOnClick": true }\'>
								[+images.pager+]
							</div>
						</div>
					</div>
				</div>
			',

			'images' => [
				'main'  => '<img src="[+image+]" class="slide">',
				'pager' => '<img src="[[phpthumb? &input=`[+image+]` &options=`w=100,h=60,zc=1`]]" class="slide">',
			],
		],

		'fields' => [
			'title' => [
				'caption' => 'Заголовок',
				'type'    => 'text',
			],

			'images' => [
				'caption' => 'Изображения в слайдере',
				'type'    => 'group',
				'fields'  => [
					'image' => [
						'caption' => 'Изображение',
						'type'    => 'image',
					],
				],
			],
		],
	];

