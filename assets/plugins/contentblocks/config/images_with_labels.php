<?php

	return [
		'title' => 'Изображения',

		'templates' => [
			'owner' => '
				<div class="section">
					<div class="container">
						<h2>[+title+]</h2>
				
						<div class="images">
							[+images+]
						</div>
					</div>
				</div>
			',

			'images' => '
				<div class="row">
					<div class="col-sm-4">
						<img src="[+image+]" alt="[+title+]" class="slide">
					</div>

					<div class="col-sm-8">
						<div class="user-content">
							[+content+]
						</div>

						<div class="labels">
							[+labels+]
						</div>
					</div>
				</div>
			',

			'labels' => '
				<div class="label">
					<div class="row">
						<div class="col-sm-2">
							<img src="[[phpthumb? &input=`[+image+]` &options=`w=70,h=50,zc=1`]]" alt="[+title+]">
						</div>
						
						<div class="col-sm-8">
							<h6>[+title+]</h6>

							<div class="user-content">
								[+content+]
							</div>
						</div>
					</div>
				</div>
			',
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

					'labels' => [
						'caption' => 'Метки',
						'type'    => 'group',
						'fields'  => [
							'title' => [
								'caption' => 'Название',
								'type'    => 'text',
							],

							'image' => [
								'caption' => 'Изображение',
								'type'    => 'image',
							],

							'content' => [
								'caption' => 'Содержимое',
								'type'    => 'richtext',
								'theme'   => 'mini',
								'options' => [
									'height' => '50px',
								],
							],
						],
					],

					'content' => [
						'caption' => 'Содержимое',
						'type'    => 'richtext',
						'theme'   => 'mini',
						'options' => [
							'height' => '80px',
						],
					],
				],
			],
		],
	];

