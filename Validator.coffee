
class Validator 
	validationErrors = []

	GetValidation = (type, itemToValidate) ->
		return new ObjectValidation(itemToValidate, validationErrors, @For) if "Object"

	For: (type, itemToValidate) ->
		validation = new GetValidation(type, itemToValidate)

class Validation 
	@currentField = null
	constructor: (@itemToValidate, @validationErrors, @KillFunction) ->

	AddError: (errorMessage) ->
		@validationErrors.push { field: @currentField,  message: errorMessage }

	For: (type, itemToValidate) -> 
		@KillFunction(type, itemToValidate)

	#basic validators
	GreaterThan: (compareTo, baseValue) ->
		baseValue > compareTo
	LessThan: (compareTo, baseValue) ->
		baseValue < compareTo
	Between: (floor, ceiling, baseValue) ->
		GreaterThan(floor, baseValue) and LessThan(ceiling, baseValue)
	EqualTo: (compareTo, baseValue) ->
		baseValue is valueToCompare
	
class ObjectValidation extends Validation
	CurrentFieldExists: ->
		@itemToValidate[@currentField]?
	
	#Validate = (validateFn, errorMessage, functionArgs...) ->
	#	if CurrentFieldExists() and not validateFn.apply @, functionArgs then @AddError errorMessage

	Require: (fieldName) ->
		@currentField = fieldName

		if not @CurrentFieldExists() then @AddError("#{@currentField} is required")
		return @

	Optional: (fieldName) ->
		@currentField = fieldName
		return @
