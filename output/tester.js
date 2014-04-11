var validator = new Validator();
var objMe = {
	name: "Nathan Griffin",
	age: 24,
	job: "Code Ninja",
	address: "1234 Sesame St Atlanta GA 30305",
	favoriteCereal: "Honey Bunches of Oats"
};

var name = "Nathan Griffin";
var age = 24;
var job = "Code Ninja";

var validation = validator
	.For(objMe)
		.Require("age")
			.LessThan(30)
		.Require("address")
			.Contains("Atlanta")
			.Contains("GA")
		.Optional("job")
			.Contains("Ninja")
			.Contains("Code")
	.For(name)
		.Contains("Griffin")
	.For(age)
		.Between(20, 40)
	.For(job)
		.Contains("Ninja")
	.For(age)
		.GreaterThan(20)
	.Assert();

console.log(validation)