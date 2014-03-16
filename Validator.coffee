
class Validator 
	validationErrors = []

	GetValidation = (type, itemToValidate) ->
		return new ObjectValidation(itemToValidate, validationErrors, @For) if "Object"

	For: (type, itemToValidate) ->
		validation = new GetValidation(type, itemToValidate)

class Validation 
	@currentField = null
	@currentValue = null
	
	constructor: (@itemToValidate, @validationErrors, @KillFunction) ->

	#helpers
	AddError: (errorMessage) ->
		@validationErrors.push { field: @currentField,  message: errorMessage }
	Validate: (valid, message) ->
		if @currentValue? and not valid then @AddError "#{@currentField} #{message}"

	For: (type, itemToValidate) -> 
		@KillFunction(type, itemToValidate)

	#value validators
	GreaterThan: (compareValue) ->
		@Validate @currentValue > compareValue, "must be greater than #{compareValue}"
		return @
	LessThan: (compareValue) ->
		@Validate @currentValue < compareValue, "must be less than #{compareValue}" 
		return @
	Between: (floor, ceiling) ->
		@Validate @currentValue > floor and @currentValue < ceiling, "must be between #{floor} and #{ceiling}"
		return @
	EqualTo: (compareValue) ->
		@Validate @currentValue is compareValue, "must be #{compareValue}"
		return @

	#string validators
	Contains: (substring) ->
		@Validate @currentValue.indexOf(substring) > -1, "must contain #{substring}"
		return @
	
class ObjectValidation extends Validation
	CurrentFieldExists: ->
		@itemToValidate[@currentField]?

	SetCurrent: (fieldName, required) ->
		@currentField = fieldName
		@currentValue = null

		if @CurrentFieldExists then @currentValue = @itemToValidate[@currentField]
		else if required then @AddError("#{@currentField} is required")

	#existance operations
	Require: (fieldName) ->
		@SetCurrent(fieldName, true)
		return @
	Optional: (fieldName) ->
		@SetCurrent(fieldName)
		return @

