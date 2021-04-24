# Spirited

_This is my entry for [Sprint Lisp Game Jam 2021][1]. Written in [Fennel][2] lisp using [TIC-80][3]._

The game is currently available [here][4]

[1]: https://itch.io/jam/spring-lisp-game-jam-2021
[2]: https://fennel-lang.org/
[3]: https://tic.computer/
[4]: https://dawranliou.itch.io/spirited

## Development notes

### Requirements

- `tic80`: PRO Version to load assets as plain text

### Run from source

- `$ make run`

### Export to HTML

- Run your game with `$ make run`;
- Press `ESC` to open the prompt;
- Enter `export html` and save the zip file wherever you want, for example in
  `build/`;
- Quit the game and unzip the files.

## Design notes

### World-building

The duo-world of Spirited has two major worlds - The Dark Side and The Light
Side, connected by The Bridge of Eternity. Though The Dark Side is full of
dungeons and traps, it is the safer place of the two. The Light side, though
bright and beautiful, is quite a dangerous place. Creatures inhibiting The Light
Side are tough as hell (and sometimes very mean). Traveling between the worlds
are sometimes dangerous too! The last thing you want is to get lost in the
In-between Space.

#### Dark Side

Full of dungeons and traps, but otherwise safe.

#### Light Side

Bright and beautiful. Also dangerous.

### Story

The story is about two friends, Spirit and Ed, that got stuck inside the
duo-world of Light Side and Dark Side.

Notes: I really need to work on the storytelling and dialogues more but it is
what it is.

### Characters

#### Spirit

Spirit is the main protagonist in the story (also the player's POV.) Spirit

#### Ed the Cat

Ed is Spirit's best friend.

### Gameplay

The game play is mostly dialogue driven, there are some potentials to add
exploration/adventure into the game play but didn't have the resource to work on
it. Later, perhaps.

I took a lot of the game mechanics (and code) from technomancy's projects:

- https://gitlab.com/technomancy/fennel-dialog
- https://gitlab.com/emmabukacek/this-is-my-mech/

### Art

- Idle animations for characters
- Walk animations for characters
- Profiles for characters
- NPC sprites
- Ending screen

### Music

- Main theme song

### Sound effects

- Drum
- Hi-hat
- Bass

## Credits and inspirations

I took the boilerplate from the repo. Although I eventually remove the code from
my repo as I progress, really appreciate the authors to get me started.

- https://github.com/stefandevai/fennel-tic80-game/

I studied the code and adopted a big chunk in this game. Thanks to technomancy's
previous work!

- https://gitlab.com/technomancy/fennel-dialog
- https://gitlab.com/emmabukacek/this-is-my-mech/
- https://p.hagelb.org/proton.tic.html

I learned a lot from the tileset in this TIC-80 game I found:

- https://tic80.com/play?cart=636
