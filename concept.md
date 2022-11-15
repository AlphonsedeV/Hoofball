# Hoofball
The goals will be two invisible walls. The ball will be detected on collision and sent the reset message.\
Message will have form `GOAL [0/1]` and sent directly to the ball. 0 is team one and 1 is team 2.\
Upon receiving the goal message the ball will reset in a "inert" state (phantom, non physical, non responsive to "goal") and will levitate above the middle of the field waiting to be reset by an active command.

# Protocols

Name | description  | Proto | channel 
-----|--------------|-------|--------
Goal | the balls is in a goal. The ball will repeat this for scoreboards. | `GOAL [0/1]` | -155875
Start | The ball is put in play | `HOOF START` | 1
Stop | The ball reset to inert | `HOOF STOP` | 1



# Ball
- [ ] inert state
  - [ ] "Iball" description
  - [ ] listener on 1
  - [ ] nonphysical property
  - [ ] tp to reset point
  - [ ] (Rotate / Musicloop ?)
  - [ ] Clickable with dialog
- [ ] active state
  - [ ] "Aball" description
  - [ ] Physical
  - [ ] listener on 1 and -155875
  - [ ] particle / sound on goal ?
  - [ ] (Color terrain dependant ?)


# Goal
- [ ] Send goal on collision if correct description