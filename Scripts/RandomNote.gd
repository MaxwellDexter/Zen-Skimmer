extends Node

# constants for semitone scale multiplication
const ST_POS = 1.0594630944
const ST_NEG = 0.9438743127

# scale enum for holding types of scales to play
# should map to values in dictionary
enum SCALE {
	Major,
	Minor,
	MajorPentatonic,
	MinorPentatonic,
	Custom
}

################
# Scale Arrays #
################
# amount of semitones to note from root
# order doesn't matter but helps with visualising it
# should generally include 0 to play the sample with no scaling
var positive_major = [0, 2, 4, 5, 7, 9, 11]
var positive_minor = [0, 2, 3, 5, 7, 8, 10]

var negative_major = [0, 1, 3, 5, 7, 8, 10]
var negative_minor = [0, 2, 4, 5, 7, 9, 10]

var positive_pent_major = [0, 2, 4, 7, 9]
var negative_pent_major = [0, 3, 5, 8, 10]

var positive_pent_minor = [0, 3, 5, 7, 10]
var negative_pent_minor = [0, 2, 5, 7, 9]

var scales_dict

####################
# Public Variables #
####################
export (SCALE) var scale_type
export (int) var octave_amount_up
export (int) var octave_amount_down

export (Array, int) var positive_custom
export (Array, int) var negative_custom

func _ready():
	make_dictionary()

# makes the dictionary used by the class.
# has to be done in _ready so that the custom scale arrays are loaded.
# returns: null
func make_dictionary():
	scales_dict = {
		SCALE.Major: {true: positive_major, false: negative_major},
		SCALE.Minor: {true: positive_minor, false: negative_minor},
		SCALE.MajorPentatonic: {true: positive_pent_major, false: negative_pent_major},
		SCALE.MinorPentatonic: {true: positive_pent_minor, false: negative_pent_minor},
		SCALE.Custom: {true: positive_custom, false: negative_custom}
	}

# main function to call.
# will return a pitch scale greater than 0.
# best used with audio.set_pitch_scale(pitch).
# returns: float
func get_random_note():
	var note_is_above_root = get_is_note_above()
	if note_is_above_root == null: return 1

	var scale = get_scale(note_is_above_root)
	var ST = get_semitone(note_is_above_root)
	
	var pitch = get_pitch(scale, ST, note_is_above_root)
	return pitch

# will determine what direction the random pitch will generated from.
# e.g. do we use the scale going up and above the note?
# or do we go below the note?
# it's a boolean value to keep things simple since we only
# have two directions to choose from.
# returns: boolean
func get_is_note_above():
	var note_is_above_root
	if octave_amount_up > 0 and octave_amount_down > 0:
		note_is_above_root = true if randf() > 0.5 else false
	elif octave_amount_up < 1 and octave_amount_down > 0:
		note_is_above_root = false
	elif octave_amount_down < 1 and octave_amount_up > 0:
		note_is_above_root = true
	return note_is_above_root

# simple function that returns the semitone multiplier.
# it's a different equation if you scaling up or down.
# returns: float
func get_semitone(note_is_above_root):
	return ST_POS if note_is_above_root else ST_NEG

# accesses the scale dictionary to get the scale array
# to get a random note from.
# returns: array of int
func get_scale(note_is_above_root):
	return scales_dict[scale_type][note_is_above_root]

# where the magic pitch randomisation comes from.
# gets a random int from the array,
# applies the semitone multiplication for the random int,
# then will apply a random octave dependent on user settings.
# returns: float
func get_pitch(scale, ST, note_is_above_root):
	var steps = scale[randi() % scale.size()]
	
	var pitch = 1.0
	for i in range(steps):
		pitch *= ST
	
	if note_is_above_root:
		pitch *= randi() % octave_amount_up + 1
	else:
		pitch /= randi() % octave_amount_down + 1
	
	return pitch