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
		],

		'fields' => [
			'dropdown1' => [
				'caption'  => 'dropdown1',
				'type'     => 'dropdown',
				'elements' => '0==Не выбрано||1==Первый',
			],
			
			'checkbox' => [
				'caption'  => 'checkbox',
				'type'     => 'checkbox',
				'elements' => [
					0 => 'Не выбрано',
					1 => 'Первый',
					2 => 'Второй',
				],
				'default' => [ 1, 2 ],
			],

			'radio' => [
				'caption'  => 'radio',
				'type'     => 'radio',
				'layout'   => 'horizontal',
				'elements' => [
					0 => 'Не выбрано',
					1 => 'Первый',
					2 => 'Второй',
				],
				'default' => 1,
			],

			'textarea' => [
				'caption' => 'textarea',
				'type'    => 'textarea',
				'default' => 'asd',
				'height'  => '40px',
			],

			'image' => [
				'caption' => 'image',
				'type'    => 'image',
			],

			'file' => [
				'caption' => 'file',
				'type'    => 'file',
			],

			'date' => [
				'caption' => 'date',
				'type'    => 'date',
			],

			'dropdown' => [
				'caption'  => 'dropdown',
				'type'     => 'dropdown',
				'elements' => [
					0 => 'Не выбрано',
					1 => 'Первый',
					2 => 'Второй',
				],
			],
		],
	];

