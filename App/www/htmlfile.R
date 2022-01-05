txt <- '<!DOCTYPE html>
<html lang="es">

<head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sliders</title>
        <link rel="stylesheet" href="styles.css">
</head>

<body>
        <section class="slider">

                <div class="slider__container container">
                        
                        <img src="larrow.svg" class="slider__arrow" id="before">

                        <section class="slider__body slider__body--show" data-id="1">
                                <div class="slider__texts">
                                        <h2 class="subtitle">¡Hola! Soy Simón</h2>
                                        <p class="slider__review">
                                                Lorem ipsum dolor sit amet consectetur, adipisicing elit. Eveniet
                                                explicabo aut
                                                porro deserunt hic totam.
                                        </p>
                                </div>

                                <figure class="slider_picture">
                                        <img src="https://avatars.githubusercontent.com/u/71856010?v=4" class="slider__img">
                                </figure>
                        </section>

                        <section class="slider__body" data-id="2">
                                <div class="sliderSimón__texts">
                                        <h2 class="subtitle">¡Hola! Soy Sebastián</h2>
                                        <p class="slider__review">
                                                Lorem ipsum dolor sit amet consectetur, adipisicing elit. Eveniet
                                                explicabo aut
                                                porro deserunt hic totam.
                                        </p>
                                </div>

                                <figure class="slider_picture">
                                        <img src="https://avatars.githubusercontent.com/u/82337893?v=4" class="slider__img">
                                </figure>
                        </section>

                        <section class="slider__body" data-id="3">
                                <div class="slider__texts">
                                        <h2 class="subtitle">¡Hola! Soy Verónica</h2>
                                        <p class="slider__review">
                                                Lorem ipsum dolor sit amet consectetur, adipisicing elit. Eveniet
                                                explicabo aut
                                                porro deserunt hic totam.
                                        </p>
                                </div>

                                <figure class="slider_picture">
                                        <img src="https://avatars.githubusercontent.com/u/58831165?v=4" class="slider__img">
                                </figure>
                        </section>

                        <section class="slider__body" data-id="4">
                                <div class="slider__texts">
                                        <h2 class="subtitle">¡Hola! Soy Juan José</h2>
                                        <p class="slider__review">
                                                Lorem ipsum dolor sit amet consectetur, adipisicing elit. Eveniet
                                                explicabo aut
                                                porro deserunt hic totam.
                                        </p>
                                </div>

                                <figure class="slider_picture">
                                        <img src="https://avatars.githubusercontent.com/u/82337913?v=4" class="slider__img">
                                </figure>
                        </section>

                        <img src="rarrow.svg" class="slider__arrow" id="after">
                </div>
        </section>

        <script src="slider.js"></script>
</body>

</html>'