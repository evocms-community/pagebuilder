<?php

	return [
		'title' => 'Слайдер с заголовком и описанием',

		'templates' => [
			'owner' => '
				<div class="section">
					<div class="container">
						<div class="row">
							<div class="col-sm-7">
								<div class="cycle">
									<div class="slick" data-slick=\'{ "slidesToShow": 2 }\'>
										[+images+]
									</div>
								</div>
							</div>

							<div class="col-sm-5">
								<h2>[+title+]</h2>

								<div class="user-content">
									[+content+]
								</div>
							</div>
						</div>
					</div>
				</div>
			',

			'images' => '<img src="[+image+]" alt="[+title+]" class="slide">',
		],

		'fields' => [
			'title' => [
				'caption' => 'Заголовок',
				'type'    => 'text',
			],

			'content' => [
				'caption' => 'Содержимое блока',
				'type'    => 'richtext',
				'options' => [
					'height' => '200px',
				],
			],

			'images' => [
				'caption' => 'Изображения в слайдере',
				'type'    => 'group',
				'fields'  => [
					'image' => [
						'caption' => 'Изображение',
						'type'    => 'image',
					],

					'title' => [
						'caption' => 'Подпись',
						'type'    => 'text',
					],
				],
			],
		],
	];

