var validator = new Validator();
var objMe = {
	name: "Nathan Griffin",
	age: 24,
	job: "Code Ninja",
	address: "1234 Sesame St Atlanta GA 30305",
	favoriteCereal: "Honey Bunches of Oats"
};

var fnMe = function() {
	return "LOL DIS ME"
}

var fnReturnObj = function() {
	return {
		name: "Nathan",
		age: 24
	}
}

var param1 = "HOW", param2 = "NOW", param3 = "BROWN";

var validation = validator
	.For(objMe)
		.Require("age")
			.GreaterThan(30)
		.Require("address")
			.Contains("Atlanta")
			.Contains("GA")
		.Optional("job")
			.Contains("Ninja")
	.Assert();

console.log(validation)