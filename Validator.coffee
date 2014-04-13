
class Validator 
	validationErrors = []

	For: (itemToValidate) ->
		GetValidation(itemToValidate)

	GetValidation = (itemToValidate) =>
		typeOf = typeof itemToValidate

		return new ObjectValidation(itemToValidate, validationErrors, GetValidation) if typeOf is "object" and not isArray(itemToValidate) and itemToValidate?
		return new FunctionValidation(itemToValidate, validationErrors, GetValidation) if typeOf is "function"
		return new Validation(itemToValidate, validationErrors, GetValidation, true)

class Validation 
	@itemOption = null
	@currentValue = null
	@validateLength = false

	constructor: (@itemToValidate, @validationErrors, @newValidation, @isPrimitiveValue) ->
		@currentValue = @itemToValidate if @isPrimitiveValue
		@itemOption = "Value" if @isPrimitiveValue

		@getValidationValue = ->
			if @validateLength then validationValue = @currentValue.length
		
	AddError: (errorMessage) ->
		@validationErrors.push { field: @itemOption,  message: errorMessage }

	Validate: (isValid, message) ->
		if @currentValue? and not isValid() then @AddError "#{@itemOption} #{message}"
		@validateLength = false

	#KILL FUNCTION >;D
	For: (itemToValidate, itemName) => 
		@newValidation(itemToValidate)

	Assert: ->
		valid: @validationErrors.length is 0
		errors: @validationErrors

	#validators
	GreaterThan: (compareValue) ->
		@Validate ( => @getValidationValue() > compareValue ), "must be greater than #{compareValue}"
		return @
	LessThan: (compareValue) ->
		@Validate ( => @getValidationValue() < compareValue ), "must be less than #{compareValue}" 
		return @
	Between: (floor, ceiling) ->
		@Validate ( => @getValidationValue() > floor and @currentValue < ceiling ), "must be between #{floor} and #{ceiling}"
		return @
	EqualTo: (compareValue) ->
		@Validate ( => @getValidationValue() is compareValue ), "must be #{compareValue}"
		return @
	Contains: (testItem) -> 
		@Validate ( => @currentValue.indexOf(testItem) > -1 ), "must contain #{testItem}" 
		return @

	Length: ->
		@validateLength = true
		return @

class ObjectValidation extends Validation
	itemOptionExists: ->
		@itemToValidate[@itemOption]?

	SetCurrent: (fieldName, required) ->
		@itemOption = fieldName
		@currentValue = null

		if @itemOptionExists then @currentValue = @itemToValidate[@itemOption]
		else if required then @AddError("#{@itemOption} is required")

	#existance operations
	Require: (fieldName) ->
		@SetCurrent(fieldName, true)
		return @
	Optional: (fieldName) ->
		@SetCurrent(fieldName)
		return @

class FunctionValidation extends Validation
	WithParameters: (parameters...) ->
		result = @itemToValidate(parameters...)
		@newValidation(result)


#HELPERS
isArray = (item) ->
	if Array.isArray then Array.isArray item else toString.call item == '[object Array]'


