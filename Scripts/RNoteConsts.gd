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
