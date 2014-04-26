
class Validator 
		
	constructor: () ->
		validationOptions.errorList = []

	GetValidation = (itemToValidate, itemName) =>
		typeOf = typeof itemToValidate
		
		return new ObjectValidation(itemToValidate, validationOptions, itemName) if typeOf is "object" and not isArray(itemToValidate) and itemToValidate?
		return new FunctionValidation(itemToValidate, validationOptions, itemName) if typeOf is "function"
		return new Validation(itemToValidate, validationOptions, itemName, true)

	validationOptions = 
		newValidation: GetValidation
	
	For: (itemToValidate, itemName) ->
		GetValidation(itemToValidate, itemName)

class Validation 
	@currentValue = null
	@validateLength = false
	@applyNot = false

	constructor: (@itemToValidate, validationOptions, @itemName, @isPrimitiveValue) ->
		@currentValue = @itemToValidate if @isPrimitiveValue
		@itemName = "Value" if not @itemName
		@validationErrors = validationOptions.errorList
		@newValidation = validationOptions.newValidation

		@Validate = (validateFn, message) ->
			if @currentValue? and not @valid(validateFn) then @AddError @generateErrorMessage(@itemName, message)

			@validateLength = false
			@applyNot = false

		@getValidationValue = ->
			if @validateLength then @currentValue.length else @currentValue

		@valid = (validateFn) ->
			if @applyNot then !validateFn() else validateFn()

		@AddError = (errorMessage) ->
			@validationErrors.push { value: @itemName,  message: errorMessage }
			
		@generateErrorMessage = (itemName, errorMessage) ->
			(if @validateLength then "The length of " else "") + "#{itemName} must " + (if @applyNot then "not " else "") + errorMessage


	#KILL FUNCTION >;D
	For: (itemToValidate, itemName) => 
		@newValidation(itemToValidate, itemName)

	Assert: ->
		valid: @validationErrors.length is 0
		errors: @validationErrors

	#validators
	GreaterThan: (compareValue) ->
		@Validate ( => @getValidationValue() > compareValue ), "be greater than #{compareValue}"
		return @
	LessThan: (compareValue) ->
		@Validate ( => @getValidationValue() < compareValue ), "be less than #{compareValue}" 
		return @
	Between: (floor, ceiling) ->
		@Validate ( => @getValidationValue() > floor and @currentValue < ceiling ), "be between #{floor} and #{ceiling}"
		return @
	EqualTo: (compareValue) ->
		@Validate ( => @getValidationValue() is compareValue ), "be #{compareValue}"
		return @
	Contains: (testItem) -> 
		@Validate ( => @currentValue.indexOf(testItem) > -1 ), "contain #{testItem}" 
		return @

	#qualifiers
	Length: ->
		@validateLength = true
		return @
	Not: ->
		@applyNot = true
		return @


class ObjectValidation extends Validation
	itemOptionExists: ->
		item = @itemToValidate[@itemName]
		
		item != null and item != undefined

	SetCurrent: (fieldName, required) ->
		@itemName = fieldName
		@currentValue = null
		
		if @itemOptionExists() then @currentValue = @itemToValidate[@itemName]
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
		itemToValidate = @validatingFunction or @itemToValidate
		result = itemToValidate(parameters...)
		resultValidation = @newValidation(result)
		
		#so we dont have to repeat .For() when validating the result of functions
		if typeof result != 'function' 
		then 
		resultValidation.WithParameters = @WithParameters
		resultValidation.validatingFunction = @itemToValidate
		
		resultValidation


#HELPERS
isArray = (item) ->
	if Array.isArray then Array.isArray item else toString.call item is '[object Array]'


