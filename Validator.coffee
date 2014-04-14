
class Validator 
	validationErrors = []

	For: (itemToValidate) ->
		GetValidation(itemToValidate)

	GetValidation = (itemToValidate, itemName) =>
		typeOf = typeof itemToValidate

		return new ObjectValidation(itemToValidate, validationErrors, GetValidation, itemName) if typeOf is "object" and not isArray(itemToValidate) and itemToValidate?
		return new FunctionValidation(itemToValidate, validationErrors, GetValidation, itemName) if typeOf is "function"
		return new Validation(itemToValidate, validationErrors, GetValidation, itemName, true)

class Validation 
	@itemName = null
	@currentValue = null
	@validateLength = false

	constructor: (@itemToValidate, @validationErrors, @newValidation, @itemName, @isPrimitiveValue) ->
		@currentValue = @itemToValidate if @isPrimitiveValue
		@itemName = "Value" if not @itemName

		@getValidationValue = ->
			if @validateLength 
			then return @currentValue.length else return @currentValue
		
	AddError: (errorMessage) ->
		@validationErrors.push { value: @itemName,  message: errorMessage }

	Validate: (isValid, message) ->
		itemNameError = (if not @validateLength then "" else "The length of ") + @itemName  
		if @currentValue? and not isValid() then @AddError "#{itemNameError} #{message}"
		@validateLength = false

	#KILL FUNCTION >;D
	For: (itemToValidate, itemName) => 
		@newValidation(itemToValidate, itemName)

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
		@itemToValidate[@itemName]?

	SetCurrent: (fieldName, required) ->
		@itemName = fieldName
		@currentValue = null

		if @itemOptionExists then @currentValue = @itemToValidate[@itemName]
		else if required then @AddError("#{@itemName} is required")

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


