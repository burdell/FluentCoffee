
var validator = new Validator();
var test = {
	name: "Nathan Griffin",
	age: 24,
	job: "Code Ninja",
	address: "1234 Sesame St Atlanta GA 30305",
	favoriteCereal: "Honey Bunches of Oats"
};

var testArray = [1, 2, 3, 4];

var testString = "HOW NOW BROWN COW";

var validation = validator
	.For(test)
		.Require("name").Length().GreaterThan(30)
		.Require("address").Contains("1234")
	.For(testArray, "Test Array")
		.Contains(20)
		.Length().GreaterThan(3)
	.For(testString, "Stupid saying")
		.Length().GreaterThan(100)
		.Contains("NOW")
	.Assert();

console.log(validation)

/*var objMe = {
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
	.For(name).Contains("Griffin")
	.For(age).Between(20, 40)
	.For(job).Contains("Ninja")
	.For(age).GreaterThan(20)
	.For(identityFunction).WithParameters(true)
		.Require("name").EqualTo("George P. Burdell")
		.Require("job").EqualTo("trollol")
		.Require("age").LessThan(90)
	.For(identityFunction).WithParameters()
		.Require("name").Contains("Griffin")
		.Require("age").LessThan(30)
	.Assert();
*/