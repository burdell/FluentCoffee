
class Validator 
	validationErrors = []

	For: (itemToValidate) ->
		GetValidation(itemToValidate)

	GetValidation = (itemToValidate) =>
		typeOf = typeof itemToValidate
		return new ObjectValidation(itemToValidate, validationErrors, GetValidation) if typeOf is "object" and itemToValidate != null
		return new FunctionValidation(itemToValidate, validationErrors, GetValidation) if typeOf is "function"
		return new Validation(itemToValidate, validationErrors, GetValidation, true)

class Validation 
	@itemOption = null
	@currentValue = null

	constructor: (@itemToValidate, @validationErrors, @newValidation, @isPrimitiveValue) ->
		@currentValue = @itemToValidate if @isPrimitiveValue
		@itemOption = "Value" if @isPrimitiveValue
		
	AddError: (errorMessage) ->
		@validationErrors.push { field: @itemOption,  message: errorMessage }

	Validate: (isValid, message) ->
		if @currentValue? and not isValid() then @AddError "#{@itemOption} #{message}"

	#KILL FUNCTION >;D
	For: (itemToValidate) => 
		@newValidation(itemToValidate)

	Assert: ->
		valid: @validationErrors.length is 0
		errors: @validationErrors

	#value validators
	GreaterThan: (compareValue) ->
		@Validate ( => @currentValue > compareValue ), "must be greater than #{compareValue}"
		return @
	LessThan: (compareValue) ->
		@Validate ( => @currentValue < compareValue ), "must be less than #{compareValue}" 
		return @
	Between: (floor, ceiling) ->
		@Validate ( => @currentValue > floor and @currentValue < ceiling ), "must be between #{floor} and #{ceiling}"
		return @
	EqualTo: (compareValue) ->
		@Validate ( => @currentValue is compareValue ), "must be #{compareValue}"
		return @

	#string validators
	Contains: (substring) ->
		@Validate ( => @currentValue.indexOf(substring) > -1 ), "must contain #{substring}" 
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
