# Ultimate goals
* Parametric build for Default: Input: Tube length, engine size, stages; Output: Best set of parts
* Classical rocket shapes: Vostok1, Saturn V, V2



# WIP: 0.5
* Vostok: making it lightweight, more space inside, tinner walls, bigger fins
* WIP: Vostok1b: add intake to boosters, maybe to the stage2/3 
* Default generates OpenRocket config
* ork_to_sjoc: converts OpenRocket files to SJOC receipt
    - Testing models: default (SJOC default), Exocet, AGM-84 Harpoon, AGM-114 Hellfire, FGM-148 Javelin
    - Automated extraction: nosecone, bodytubes, trapezois and freeform fins, lug (WIP), engine size (party)

# 0.4
* Split code base in two parts: models and modules 
* Default model and Vostok-1 model 
* Function to generate fins of different types
* Function to generate male and female joints
* tube3: like tube and tube2 but cylinder

## Flights
* The default model on A engine flew OK, para was perfectly ejected in apogee, however, the shock cord burned as it was too close to the engine. The hook also burned. Suggestion: increase the length of the body, and add more space for gas and pads.
* Vostok1 on C engine: Flew into the ditch. Was heavy and unbalanced, CM was too close to the engine or might be even after its top. Suggestion: make the boosters lighter, decrease overall mass, and try to make the nose heavier.


# 0.3
* No more gates
* Anchor instead of anker inside body
* Extra rod 
* Various nose cones

## Fligths
* Started ok, nose was too tight and didn't eject the para

# 0.2
* Makefile to separate compiling of STLs
* Fins: clipped delta, swept, tapered swept
* 45 degree cut on inner ring
* 45 degree cut on some joints

# 0.1 Initial
* Basic functionality: base, body, cone
* Trapecoid fin
* Variable number of fins
* Two genders on body