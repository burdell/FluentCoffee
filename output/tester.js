var validator = new Validator();
var me = {
	//name: "Nathan Griffin",
	age: 24,
	job: "Code Ninja",
	address: "1234 Sesame St Atlanta GA 30305",
	favoriteCereal: "Honey Bunches of Oats"
};

var validation = validator
	.For("Object", me)
	.Require("name");
			/*.Equals("Nathan Griffin")
		.Require("age")
			.LessThan(25)
		.Optional("job")
			.Equals("Code Ninja")
		.RequireFields("address", "favoriteCereal");*/
	debugger;