
objBurdell =
	name: "George P. Burdell",
	job: "trollol",
	age: 87,
	favoriteCereal: "Fruit Loops"

objMe = 
	name: "Nathan Griffin",
	age: 24,
	numberOfAppendages: 5
	faveCereal: "Honey Bunches of Oats",
	job: "Code Ninja"

identityFunction = (isMe) ->
	if isMe then objMe else objBurdell

validation = new Validator()
	.For [1, 2, 3, 4, 6], "number array"
		.Contains 2
		.Not().Contains(5)
	.For "how now brown cow", "stupid saying"
		.Length().GreaterThan 10
		.EqualTo("how now brown cow")
	.For 3 * 10, "simple calculation"
		.LessThan 340
		.Between 250, 250
	.For 30 < 40
		.EqualTo true
	.For objMe
		.Require "lol"
		.Require "age"
			.LessThan 30
			.GreaterThan 20
			.Not().EqualTo 29
		.Require "faveCereal"
		.Require "numberOfAppendages"
			.Between 15, 25
		.Require "name"
			.EqualTo "Nathan Griffin"
		.Require "job"
			.Contains "Ninja"
			.Length().GreaterThan 5
		.Optional "nickname"
	.For identityFunction
		.WithParameters true
			.Require "name"
				.EqualTo "Nathan Griffin"
			.Require "job"
				.Contains "Ninja"
		.WithParameters()
			.Require "name"
				.EqualTo "George P. Burdell"
			.Require "address"
				.Contains("lol")
			.Require "age"
				.GreaterThan 50
				.LessThan 90
	.Assert()

console.log validation

