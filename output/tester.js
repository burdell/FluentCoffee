var validator = new Validator();
var me = {
	name: "Nathan Griffin",
	age: 24,
	job: "developer",
	address: "1234 Sesame St Atlanta GA 30305",
	favoriteCereal: "Honey Bunches of Oats"
};

var validation = validator
	.For("Object", me)
	.Require("age").GreaterThan(30)
	.Require("job").Contains("Ninja")
		
console.log(validation.validationErrors)