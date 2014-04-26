
var objMe = {
	name: "Nathan Griffin",
	age: 24,
	job: "Code Ninja",
	address: "1234 Sesame St Atlanta GA 30305",
	favoriteCereal: "Honey Bunches of Oats"
};

var objBurdell = {
	name: "George P. Burdell",
	job: "trollol",
	age: 87,
	favoriteCereal: "Fruit Loops"
};

var identityFunction = function(isBurdell){
	return (isBurdell ? objBurdell : objMe);
};


var age = 24, 
	name = "Nathan Griffin",
	job = "Code Ninja";

var validator = new Validator();
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
	.For(identityFunction, "Identity Function")
		.WithParameters(true)
			.Require("name").EqualTo("George P. Burdell")
			.Require("job").EqualTo("trollol")
			.Require("age").LessThan(90)
		.WithParameters()
			.Require("name").Contains("Griffin")
			.Require("age").Not().GreaterThan(60)
	.For(name, "name").Contains("Griffin")
	.For(age, "age").Not().Between(20, 40)
	.For(job, "job").Contains("Ninja")
	.For(age).GreaterThan(20)
	.Assert();

console.log(validation)