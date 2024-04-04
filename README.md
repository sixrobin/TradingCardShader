# Trading card effect
![cards-ezgif com-optimize](https://github.com/sixrobin/TradingCardShader/assets/55784799/5462dcdf-d1c9-4e3e-af37-0917496dca60)

Stylized 3D trading card, made with Unity. The effect is a simple combination of stencil buffer, parallax effect, and some additional visual effects to polish the overall aspect of the cards.
The characters used for the cards are [Alfons Mucha](https://fr.wikipedia.org/wiki/Alfons_Mucha)'s "The Moon and the Stars".

## Breakdown
Although the effect is far from complex, here's an explanation of how it works.

### Stencil buffer
![breakdown_stencil](https://github.com/sixrobin/TradingCardShader/assets/55784799/e48e27ec-6ba1-4298-8e2c-c5bdc26251c8)

First, each card uses a stencil buffer, allowing anything to be masked outside of the card.
The use of a stencil is also great, because moving the character's gameObject along the Z axis is enough to get a nice looking parallax effect.

### Character body parts
![breakdown_bodyparts-ezgif com-optimize](https://github.com/sixrobin/TradingCardShader/assets/55784799/eb35097a-419e-4c19-8df9-c9bca4d5337c)

Characters textures are split, using a tool such as Photoshop, into multiple body parts. The parts that are split depend on the character's position.
In the example above, the arms are perfect to get an even more interesting parallax effect, without losing the initial aspect of the painting.
This could be used to add an idle animation, although it would probably require more splits to have more control for the animation.

### Wind shader
![breakdown_wind](https://github.com/sixrobin/TradingCardShader/assets/55784799/871358e5-80e7-4f2f-85ce-993c82f7baba)

Some textures use a wind effect, that is a simple UV distortion based on a given noise texture. This is an easy way to add motion to the cards, and it fits the large robes pretty well.
Splitting some parts of the clothes can help having a more organic wind, as those parts can use different wind settings, desynchronizing them.

### Character background
![breakdown_background](https://github.com/sixrobin/TradingCardShader/assets/55784799/b5680385-de25-42d4-9951-6ca5dec19897)

The background texture uses a custom parallax code in its shader, as it needs to cover all the space, so moving it along the Z axis could lead to some visible gaps when looking at the card from the side.
Aside from that, the texturing works by applying a color gradient to a paint brushes texture. This brush texture is slowly translating upward, again to add some overall motion.

### Card border and back
![breakdown_border](https://github.com/sixrobin/TradingCardShader/assets/55784799/c93cd6db-3168-49ce-a50d-24d9098e03df)

Card border and back both use the same shader, that's used to apply some highlighting/varnish above the texture. Those textures can have a mask as secondary texture, used to apply the effect on some specific spots.

### Finishing touches
![breakdown_finishingtouches-ezgif com-optimize](https://github.com/sixrobin/TradingCardShader/assets/55784799/724acc88-fc0f-419f-8a68-d7112c12cae9)

To polish everything, some fake point light (here visible behind the hands) and dust particles are added, as well as some post processing, mostly bloom.
Each character has its own custom finishing touches. For instances, some of them have wind in the hair, or the "Moon" character has a moving and glowing moon behind her head, as on the original painting.

## Glass effect
A glass effect was implemented, to make the card and the character blend together even more. The effect looks a bit too noisy and wasn't kept for the gifs and videos that I shared of the project, but is still in the sources. It's made of some simple maths, such as dot products, between the view direction and a voronoi diagram that's tiled across the card.

![glass-ezgif com-optimize](https://github.com/sixrobin/TradingCardShader/assets/55784799/ae76dd07-45e6-455a-a29f-2e9318eeba08)
